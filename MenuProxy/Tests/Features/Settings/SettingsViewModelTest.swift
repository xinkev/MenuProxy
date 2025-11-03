import Observation
import Testing

@testable import MenuProxy

class SettingsViewModelTest {
    let mockStore: MockStore
    let viewModel: SettingsViewModel

    init() {
        mockStore = .init()
        viewModel = .init(kvStore: mockStore)
    }

    @Test("Hydration should work")
    func testHydrate() throws {
        // Tear down
        defer { mockStore.storage.removeAll() }
        let setting = ProxySetting("1.1.1.1:8080", type: .http, enabled: true)
        mockStore.storage = [
            KvStoreKey.http.rawValue: setting
        ]

        let vm = SettingsViewModel(kvStore: mockStore)

        #expect(vm.proxies[.http]! == setting)
    }

    @Test("Save functionality should work") func testSave() throws {
        // Tear down
        defer { mockStore.storage.removeAll() }

        let setting = ProxySetting(
            "1.1.1.1:8080",
            type: .http,
            enabled: true
        )

        viewModel.proxies[.http] = setting

        var completionCalled = false

        viewModel.onClickSave {
            completionCalled = true
        }

        #expect(completionCalled)
        #expect(mockStore.storage.count == viewModel.proxies.count)

        let savedData = try #require(mockStore.getData(.http))
        #expect(savedData.address == "1.1.1.1:8080")
        #expect(savedData.enabled)
    }

    @Test func test_proxyChange_triggersObservation() async {
        defer { mockStore.storage.removeAll() }

        let setting = ProxySetting("1.1.1.1:8080", type: .http, enabled: true)

        // We expect the closure to be called exactly once (count: 1)
        await confirmation(expectedCount: 1) { confirm in
            // This is the setup block for observation
            withObservationTracking {
                _ = viewModel.proxies[.http]
            } onChange: {
                // This is the asynchronous event that confirms the action occurred.
                // When this closure runs, it satisfies one of the expected confirmations.
                confirm()
            }

            // This is the action that triggers the observation change
            viewModel.proxies[.http] = setting
        }

        viewModel.proxies[.http] = setting

        #expect(viewModel.proxies[.http]?.address == "1.1.1.1:8080")
    }

    @Test func test_bindingSetter_updatesStateAndObserves() async throws {
        defer { mockStore.storage.removeAll() }

        let binding = viewModel.proxySettingBinding(for: .http)
        let setting = ProxySetting("1.1.1.1:8080", type: .http, enabled: true)

        // We expect the closure to be called exactly once (count: 1)
        await confirmation(expectedCount: 1) { confirm in
            // This is the setup block for observation
            withObservationTracking {
                _ = viewModel.proxies[.http]
            } onChange: {
                // This is the asynchronous event that confirms the action occurred.
                // When this closure runs, it satisfies one of the expected confirmations.
                confirm()
            }

            // This is the action that triggers the observation change
            viewModel.proxies[.http] = setting
        }
        binding.wrappedValue = setting

        // Check if the internal state was updated
        #expect(viewModel.proxies[.http]?.address == "1.1.1.1:8080")
    }
}
