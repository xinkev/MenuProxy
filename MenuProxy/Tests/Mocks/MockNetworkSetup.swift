@testable import MenuProxy

class MockNetworkSetup: NetworkSetup {
    // Spy properties to assert calls in tests
    private(set) var activated: [(ProxyType, String, String)] = []
    private(set) var deactivated: [ProxyType] = []

    // Configure to throw when activating/deactivating (useful for error-path tests)
    var shouldThrowOnActivate = false
    var shouldThrowOnDeactivate = false

    enum MockError: Error {
        case activateFailed
        case deactivateFailed
    }

    func activateProxy(for type: ProxyType, server: String, port: String) throws {
    if shouldThrowOnActivate { throw MockError.activateFailed }
        activated.append((type, server, port))
    }

    func deactivateProxy(_ type: ProxyType) throws {
    if shouldThrowOnDeactivate { throw MockError.deactivateFailed }
        deactivated.append(type)
    }
}