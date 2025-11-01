import SwiftUI

public struct AppMenuBarExtra: Scene {
    @State private var isOn = false

    public var body: some Scene {
        MenuBarExtra("Example", systemImage: isOn ? "lightbulb.fill" : "lightbulb") {
            Menu(isOn: $isOn)
        }
        .menuBarExtraStyle(.menu)
    }
}

struct Menu: View {
    @Binding private var isOn: Bool
    @Environment(\.openWindow) private var openWindow

    init(isOn: Binding<Bool>) {
        self._isOn = isOn
    }

    var body: some View {
        Button(isOn ? "Disable" : "Enable") {
            isOn.toggle()
        }
        Divider()

        Button("Settings…") {
            NSApplication.shared.activate(ignoringOtherApps: true)
            openWindow(id: SettingsWindow.windowId)
        }
        .keyboardShortcut(",", modifiers: .command)

        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }
        .keyboardShortcut("q", modifiers: .command)
    }
}
