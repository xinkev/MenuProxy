import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: SettingsViewModel = .init()

    var body: some View {
        VStack {
            Form {
                ForEach($viewModel.proxies) { $proxy in
                    ProxyField(proxy: $proxy)
                }
                LabeledContent("Version") {
                    Text(viewModel.appVersion)
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
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(.regularMaterial)
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
