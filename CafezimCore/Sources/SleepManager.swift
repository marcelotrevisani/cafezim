import Foundation
import IOKit.pwr_mgt

/// Manages macOS sleep prevention using IOKit power assertions.
public final class SleepManager: ObservableObject {
    @Published public private(set) var isActive = false
    @Published public var durationHours: Double? = nil // nil = indefinite

    public private(set) var assertionID: IOPMAssertionID = .init(0)
    private var timer: Timer?
    public private(set) var activatedAt: Date?

    public init() {}

    /// Time remaining in seconds, or nil if indefinite / inactive.
    public var timeRemaining: TimeInterval? {
        guard isActive, let hours = durationHours, let start = activatedAt else {
            return nil
        }
        let elapsed = Date().timeIntervalSince(start)
        let total = hours * 3600
        return max(0, total - elapsed)
    }

    // MARK: - Public API

    /// Activate sleep prevention. Pass `nil` for indefinite, or a number of hours.
    public func activate(hours: Double? = nil) {
        guard !isActive else { return }
        durationHours = hours

        let success = createAssertion()
        guard success else { return }

        isActive = true
        activatedAt = Date()

        if let hours {
            scheduleTimer(hours: hours)
        }
    }

    /// Deactivate sleep prevention.
    public func deactivate() {
        guard isActive else { return }

        releaseAssertion()
        cancelTimer()

        isActive = false
        activatedAt = nil
    }

    // MARK: - IOKit Power Assertions

    private func createAssertion() -> Bool {
        let reason = "Cafezim: keeping your Mac awake" as CFString
        let type = kIOPMAssertionTypeNoDisplaySleep as CFString

        let result = IOPMAssertionCreateWithName(
            type,
            IOPMAssertionLevel(kIOPMAssertionLevelOn),
            reason,
            &assertionID
        )

        return result == kIOReturnSuccess
    }

    private func releaseAssertion() {
        IOPMAssertionRelease(assertionID)
        assertionID = IOPMAssertionID(0)
    }

    // MARK: - Timer

    private func scheduleTimer(hours: Double) {
        cancelTimer()
        let interval = hours * 3600
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.deactivate()
            }
        }
    }

    private func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }

    deinit {
        if isActive {
            releaseAssertion()
            cancelTimer()
        }
    }
}
