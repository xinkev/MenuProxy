import SwiftUI

struct SettingsView: View {
    @State private var expanded: Bool = false
    @Bindable var menuViewModel: MenuBarExtraViewModel
    
    var body: some View {
        DisclosureGroup(isExpanded: $expanded) {
            ForEach(ProxyType.allCases, id: \.self) { type in
                ProxyField(proxy: menuViewModel.proxySettingBinding(for: type))
            }
        } label: {
            Text("Proxy Settings")
        }
    }
}


struct ProxyField: View {
    @Binding var proxy: ProxySetting

    var body: some View {
        let proxyType = proxy.type.rawValue.uppercased()
        TextField(proxyType, text: $proxy.address, prompt: Text("sever:port"))
            .transition(.move(edge: .top).combined(with: .opacity))
            .multilineTextAlignment(.leading)
    }
}
