import Combine
import SwiftUI

@Observable
class SettingsViewModel {
    let proxyTypes = ProxyType.allCases

    // MARK: Properties
    var proxies: [ProxyType: ProxySetting] = [:]

    // MARK: Dependencies
    private let kvStore: KvStore

    init(kvStore: KvStore) {
        self.kvStore = kvStore
        self.hydrate()
    }

    func onClickSave(_ onComplete: () -> Void) {
        defer { onComplete() }
        for (type, setting) in proxies {
            let key = kvKey(for: type)
            kvStore.setData(key, setting)
        }
    }

    func proxySettingBinding(for proxyType: ProxyType) -> Binding<ProxySetting> {
        Binding(
            get: {
                self.proxies[proxyType]!
            },
            set: { newValue in
                self.proxies[proxyType] = newValue
            })
    }

    // MARK: - Private Helpers

    // Restore the data on intialization
    private func hydrate() {
        for proxyType in proxyTypes {
            let key = kvKey(for: proxyType)
            let defaultSetting = ProxySetting(type: proxyType)

            if let savedData: ProxySetting = kvStore.getData(key) {
                proxies[proxyType] = savedData
            } else {
                proxies[proxyType] = defaultSetting
            }
        }
    }

    private func kvKey(for type: ProxyType) -> KvStoreKey<ProxySetting> {
        switch type {
        case .http: .http
        case .https: .https
        case .socks: .socks
        }
    }
}
