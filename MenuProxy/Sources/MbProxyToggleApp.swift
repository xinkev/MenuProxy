import SwiftUI

@main
struct MenuProxyApp: App {
    var body: some Scene {
        SettingsWindow()
        MenuBarExtraView()
            .menuBarExtraStyle(.menu)
    }
}
