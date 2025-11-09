import SwiftUI

public struct MenuBarExtraView: Scene {
    @State private var viewModel = MenuBarExtraViewModel(
        kvStore: UserDefaults.standard, netWorkSetup: NetworkSetupImpl())

    public var body: some Scene {
        MenuBarExtra("Example", systemImage: viewModel.isSwitchOn ? "lightbulb.fill" : "lightbulb")
        {
            Menu(viewModel: viewModel)
                .fixedSize()
        }
        .windowResizability(.contentSize)
        .menuBarExtraStyle(.window)
    }
}

struct Menu: View {
    @State var expanded = false
    @Bindable var viewModel: MenuBarExtraViewModel

    var body: some View {
        VStack {
            Form {
                Section {
                    ForEach(ProxyType.allCases, id: \.self) { type in
                        AnyView(toggle(for: type))
                    }
                }
                SettingsView(menuViewModel: viewModel)
                Section {
                    LabeledContent("Version") {
                        Text(AppUtils.version)
                    }
                    Link("Github", destination: URL(string: "https://github.com")!)
                }
                Section {
                    MenuButton(title: "Quit", shortcut: "⌘Q") {
                        NSApplication.shared.terminate(nil)
                    }
                    .keyboardShortcut("q", modifiers: .command)
                }
            }.formStyle(.grouped)
        }
        .frame(width: 250)
    }

    @ViewBuilder
    func toggle(
        for type: ProxyType
    ) -> any View {
        let binding = viewModel.proxySettingBinding(for: type)
        Toggle("Enable \(type.rawValue.uppercased())", isOn: binding.enabled)
            .onChange(of: binding.wrappedValue) { oldValue, newValue in
                // Until there is a way to observe Observable's props continuously
                viewModel.onEnableStateChanged(
                    for: type, oldState: oldValue.enabled, newState: newValue.enabled)
            }
    }
}

struct MenuButton: View {
    let title: String
    let shortcut: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                if let shortcut = shortcut {
                    Text(shortcut)
                        .foregroundColor(.secondary.opacity(0.5))
                }
            }
            .contentShape(Rectangle())  // ensures the full row is clickable
        }
        .buttonStyle(PlainButtonStyle())  // removes default button styling for menu look
    }
}

#Preview {
    Menu(viewModel: .init(kvStore: UserDefaults.standard, netWorkSetup: NetworkSetupImpl()))
        .frame(height: 400)
}
