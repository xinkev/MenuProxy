import SwiftUI

public struct MenuBarExtraView: Scene {
    @State private var viewModel = MenuBarExtraViewModel(
        kvStore: UserDefaults.standard, netWorkSetup: .init())

    public var body: some Scene {
        MenuBarExtra("Example", systemImage: viewModel.isSwitchOn ? "lightbulb.fill" : "lightbulb")
        {
            Menu(isOn: $viewModel.isSwitchOn)
        }
        .menuBarExtraStyle(.menu)
        .onChange(of: viewModel.isSwitchOn) { oldState, newState in
            // Until there is a way to observe Observable's props continuously
            viewModel.handleToggleSwitch(oldState, newState)
        }
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
