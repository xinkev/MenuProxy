import SwiftUI

struct SettingsWindow: Scene {
    static let windowId = "settings"

    var body: some Scene {
        Window("Settings", id: Self.windowId) {
            SettingsView()
                .frame(width: 300, height: 450)
        }
        .windowResizability(.contentSize)
        .windowIdealSize(.fitToContent)
    }
}
