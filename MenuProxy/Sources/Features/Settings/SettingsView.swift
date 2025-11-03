import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appearsActive) var appearsActive
    @State private var viewModel: SettingsViewModel = .init(kvStore: UserDefaults.standard)

    var body: some View {
        VStack {
            Form {
                ForEach(viewModel.proxyTypes, id: \.self) { type in
                    ProxyField(proxy: viewModel.proxySettingBinding(for: type))
                }
                LabeledContent("Version") {
                    Text(AppUtils.version)
                }
            }
            .formStyle(.grouped)

            Divider()

            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                Button("Save") {
                    viewModel.onClickSave {
                        dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(.regularMaterial)
        }
        .onChange(of: appearsActive) { _, active in
            // Dismiss when window is not focused
            if !active {
                dismiss()
            }
        }
    }
}

struct ProxyField: View {
    @Binding var proxy: ProxySetting

    var body: some View {
        let proxyType = proxy.type.rawValue.uppercased()
        Section(proxyType) {
            Toggle("Enable \(proxyType)", isOn: $proxy.enabled.animation(.easeInOut))
            if proxy.enabled {
                TextField("Proxy", text: $proxy.address, prompt: Text("sever:port"))
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .multilineTextAlignment(.leading)

            }
        }
    }
}

#Preview {
    SettingsView()
}
