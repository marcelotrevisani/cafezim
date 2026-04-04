import SwiftUI
import CafezimCore

@main
struct CafezimApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject private var sleepManager = AppDelegate.shared.sleepManager

    var body: some Scene {
        MenuBarExtra {
            MenuBarView()
                .environmentObject(sleepManager)
        } label: {
            Image(systemName: sleepManager.isActive ? "cup.and.saucer.fill" : "cup.and.saucer")
        }
        .menuBarExtraStyle(.window)
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    static let shared = AppDelegate()
    let sleepManager = SleepManager()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }
}
