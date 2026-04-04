import Foundation
import ServiceManagement

public final class LaunchAtLoginManager: ObservableObject {
    @Published public var isEnabled: Bool {
        didSet {
            if isEnabled {
                try? SMAppService.mainApp.register()
            } else {
                try? SMAppService.mainApp.unregister()
            }
        }
    }

    public init() {
        isEnabled = SMAppService.mainApp.status == .enabled
    }
}
