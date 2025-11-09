import Observation
import Testing
import Foundation

@testable import MenuProxy

class MenuBarExtraViewModelTests {
    private let mockStore: MockStore
    private let viewModel: MenuBarExtraViewModel
    private let mockNetworkSetup: MockNetworkSetup

    init() {
        mockStore = .init()
        mockNetworkSetup = .init()
        viewModel = .init(kvStore: mockStore, netWorkSetup: mockNetworkSetup)
    }

    @Test("Hydration works correctly")
    func testHydration() {
        defer { mockStore.clear() }
        let setting = ProxySetting("1.1.1.1:8080", type: .http, enabled: true)
        mockStore.storage = [
            KvStoreKey.http.rawValue: setting
        ]
        let vm = MenuBarExtraViewModel(kvStore: mockStore, netWorkSetup: mockNetworkSetup)
        #expect(vm.proxies[.http] == setting)
    }

    @Test("Proxy setting change should trigger observervation")
    func testObservability() async {
        let setting = ProxySetting("1.1.1.1:8080", type: .http, enabled: true)

        await confirmation(expectedCount: 1) { confirm in
            withObservationTracking {
                _ = viewModel.proxies[.http]
            } onChange: {
                confirm()
            }

            viewModel.proxies[.http] = setting
        }

        #expect(viewModel.proxies[.http] == setting)
    }

    @Test("Enabling a proxy should call network activation")
    func testEnableCallsActivate() async {
        defer { mockStore.clear() }

        // prepare a proxy setting with address
        let setting = ProxySetting("1.2.3.4:8888", type: .http, enabled: false)
        viewModel.proxies[.http] = setting

        // call the enable state change to trigger activation
        viewModel.onEnableStateChanged(for: .http, oldState: false, newState: true)

        // the mock network setup should have recorded the activation
        #expect(mockNetworkSetup.activated.count == 1)
        if let (type, server, port) = mockNetworkSetup.activated.first {
            #expect(type == .http)
            #expect(server == "1.2.3.4")
            #expect(port == "8888")
        }
    }

    @Test("Disabling a proxy should call network deactivation")
    func testDisableCallsDeactivate() async {
        defer { mockStore.clear() }

        let setting = ProxySetting("1.2.3.4:8888", type: .http, enabled: true)
        viewModel.proxies[.http] = setting

        viewModel.onEnableStateChanged(for: .http, oldState: true, newState: false)

        #expect(mockNetworkSetup.deactivated.count == 1)
        if let type = mockNetworkSetup.deactivated.first {
            #expect(type == .http)
        }
    }

    @Test("Changing proxy via binding should debounce and save to store")
    func testProxyBindingDebounceSaves() {
        defer { mockStore.clear() }

        let newSetting = ProxySetting("9.9.9.9:9999", type: .http, enabled: true)
        let binding = viewModel.proxySettingBinding(for: .http)

        // Update through the binding. The view model will debounce the kvStore write.
        binding.wrappedValue = newSetting

        // Run the run loop so the Timer scheduled by debounce can fire.
        RunLoop.current.run(until: Date().addingTimeInterval(0.5))

        // After the debounce fires, both the in-memory proxies and the kv store should be updated
        #expect(viewModel.proxies[.http] == newSetting)
        let saved: ProxySetting? = mockStore.getData(.http)
        #expect(saved == newSetting)
    }

}
