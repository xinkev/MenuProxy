import Testing
import Foundation
@testable import MenuProxy

extension KvStoreKey where T == String {
    static let testString = KvStoreKey(rawValue: "string")
}

extension KvStoreKey where T == ProxySetting {
    static let testCodable = KvStoreKey(rawValue: "codable")
}

class KvStoreTests {
    let mockStore: KvStore = MockStore()
    let testDefaults = UserDefaults(suiteName: "TestSuite")

    init() {
        testDefaults?.removePersistentDomain(forName: "TestSuite")
    }

    deinit {
        testDefaults?.removePersistentDomain(forName: "TestSuite")
    }

    // Testing abstraction
    @Test func keysStillsWorksinMocks() async throws {
        let expected = "this_is_http"
        mockStore.set(.testString, expected)
        #expect(mockStore.get(.testString) == expected)
    }
    
    @Test func serializationWorks() async throws {
        let expected = ProxySetting(type: .http)
        testDefaults!.setData(.testCodable, expected)
        let data = testDefaults!.getData(.testCodable)
        #expect(data != nil)
        #expect(data!.type == .http)
    }

}
