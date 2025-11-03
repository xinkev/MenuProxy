import SwiftUI

@main
struct MbProxyToggleApp: App {
    var body: some Scene {
        SettingsWindow()
        MenuBarExtraView()
            .menuBarExtraStyle(.menu)
    }
}
