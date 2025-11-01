import SwiftUI

@Observable
class SettingsViewModel {
    let appVersion: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String

    var proxies: [ProxySetting] = ProxyType.allCases.map { ProxySetting.init(type: $0) }
}
