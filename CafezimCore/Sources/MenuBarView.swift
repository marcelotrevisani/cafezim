import SwiftUI

public struct MenuBarView: View {
    @EnvironmentObject var sleepManager: SleepManager
    @State private var selectedMode: DurationMode = .indefinite
    @State private var customHours: String = "1"

    public enum DurationMode: String, CaseIterable {
        case indefinite = "Indefinitely"
        case thirtyMinutes = "30 minutes"
        case oneHour = "1 hour"
        case twoHours = "2 hours"
        case fourHours = "4 hours"
        case eightHours = "8 hours"
        case custom = "Custom hours..."
    }

    public init() {}

    public var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Image(systemName: sleepManager.isActive ? "cup.and.saucer.fill" : "cup.and.saucer")
                    .font(.title2)
                Text("Cafezim")
                    .font(.headline)
                Spacer()
            }
            .padding(.bottom, 4)

            // Status
            statusView

            Divider()

            if sleepManager.isActive {
                activeControls
            } else {
                inactiveControls
            }

            Divider()

            Button("Quit Cafezim") {
                sleepManager.deactivate()
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
        .padding()
        .frame(width: 260)
    }

    // MARK: - Subviews

    private var statusView: some View {
        HStack {
            Circle()
                .fill(sleepManager.isActive ? Color.green : Color.gray)
                .frame(width: 8, height: 8)
            Text(sleepManager.isActive ? "Keeping Mac awake" : "Inactive")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
        }
    }

    private var activeControls: some View {
        VStack(spacing: 8) {
            if let remaining = sleepManager.timeRemaining {
                Text("Time remaining: \(formattedTime(remaining))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                Text("Running indefinitely")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Button("Deactivate") {
                sleepManager.deactivate()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .controlSize(.large)
        }
    }

    private var inactiveControls: some View {
        VStack(spacing: 8) {
            Picker("Duration", selection: $selectedMode) {
                ForEach(DurationMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.radioGroup)
            .labelsHidden()

            if selectedMode == .custom {
                HStack {
                    TextField("Hours", text: $customHours)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                    Text("hours")
                        .foregroundColor(.secondary)
                }
            }

            Button("Activate") {
                let hours = hoursForMode(selectedMode)
                sleepManager.activate(hours: hours)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }

    // MARK: - Helpers

    public static func hoursForMode(_ mode: DurationMode) -> Double? {
        switch mode {
        case .indefinite: return nil
        case .thirtyMinutes: return 0.5
        case .oneHour: return 1
        case .twoHours: return 2
        case .fourHours: return 4
        case .eightHours: return 8
        case .custom: return nil
        }
    }

    private func hoursForMode(_ mode: DurationMode) -> Double? {
        switch mode {
        case .indefinite: return nil
        case .thirtyMinutes: return 0.5
        case .oneHour: return 1
        case .twoHours: return 2
        case .fourHours: return 4
        case .eightHours: return 8
        case .custom: return Double(customHours)
        }
    }

    private func formattedTime(_ seconds: TimeInterval) -> String {
        let h = Int(seconds) / 3600
        let m = (Int(seconds) % 3600) / 60
        let s = Int(seconds) % 60
        if h > 0 {
            return String(format: "%dh %02dm", h, m)
        } else {
            return String(format: "%dm %02ds", m, s)
        }
    }
}
