import Observation

@Observable final class MenuBarExtraViewModel {
    var isSwitchOn = false

    private let proxies: [ProxySetting]
    private let networkSetup: NetworkSetup

    init(kvStore: KvStore, netWorkSetup: NetworkSetup) {
        self.networkSetup = netWorkSetup
        self.proxies = [
            kvStore.getData(.http),
            kvStore.getData(.https),
            kvStore.getData(.socks),
        ].compactMap { $0 }
    }

    func handleToggleSwitch(_ oldState: Bool, _ newState: Bool) {
        if oldState != newState && newState == true {
            // Turn it on
            activateProxies()

        } else {
            // Turn it off
            deactivateProxies()
        }
    }

    private func activateProxies() {
        print("activate")
        do {
            let commands = networkSetup.buildActivateProxyCommands(proxies: proxies)
            try CommandGroup(commands).runAll()
        } catch {
            isSwitchOn = false
            print("Failed to activate proxies", error)
        }
    }

    private func deactivateProxies() {
        print("deactivate")

        do {
            let commands = networkSetup.buildDeactivateProxyCommands(proxies: proxies)
            try CommandGroup(commands).runAll()
        } catch {
            print("Failed to deactivate proxies.")
        }
    }

}
