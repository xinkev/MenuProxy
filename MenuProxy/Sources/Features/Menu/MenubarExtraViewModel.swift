import Observation
import SwiftUI

@Observable final class MenuBarExtraViewModel {
    var isSwitchOn = false
    var proxies: [ProxyType: ProxySetting] = [:]

    private let networkSetup: NetworkSetup
    private let kvStore: KvStore
    private var debounceTimer: Timer?

    init(kvStore: KvStore, netWorkSetup: NetworkSetup) {
        self.kvStore = kvStore
        self.networkSetup = netWorkSetup
        self.proxies = [:]
        self.hydrate()
    }

    func onEnableStateChanged(for type: ProxyType, oldState: Bool, newState: Bool) {
        guard oldState != newState else { return }
        if newState == true {
            // Turn it on
            activateProxy(for: type)
        } else {
            // Turn it off
            deactivateProxy(for: type)
        }
    }

    func proxySettingBinding(for proxyType: ProxyType) -> Binding<ProxySetting> {
        Binding(
            get: {
                self.proxies[proxyType]!
            },
            set: { newValue in
                self.debounce {
                    self.proxies[proxyType] = newValue
                    self.kvStore.setData(self.kvKey(for: proxyType), newValue)
                }
            })
    }

    // MARK: - Private Helpers

    // Restore the data on intialization
    private func hydrate() {
        for proxyType in ProxyType.allCases {
            let key = kvKey(for: proxyType)
            let defaultSetting = ProxySetting(type: proxyType)

            if let savedData: ProxySetting = kvStore.getData(key) {
                proxies[proxyType] = savedData

                if savedData.enabled {
                    activateProxy(for: savedData.type)
                } else {
                    deactivateProxy(for: savedData.type)
                }
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

    private func activateProxy(for type: ProxyType) {
        print("Activating: \(type)")
        guard var setting = proxies[type] else { return }
        do {
            try networkSetup.activateProxy(
                for: type, server: setting.server, port: setting.port)
        } catch {
            setting.enabled = false
            print("Failed to activate proxies", error)
        }
    }

    private func deactivateProxy(for type: ProxyType) {
        guard var setting = proxies[type] else { return }
        do {
            try networkSetup.deactivateProxy(type)
        } catch {
            setting.enabled = false
            print("Failed to deactivate proxies.")
        }
    }

    private func debounce(delay: TimeInterval = 0.3, action: @escaping () -> Void) {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            action()
        }
    }
}
