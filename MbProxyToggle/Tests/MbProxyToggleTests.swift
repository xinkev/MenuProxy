import Testing
@testable import MbProxyToggle

class MbProxyToggleTests {
    var testStore: KvStore = MockStore()

    @Test func mockStoreWorks() async throws {
        let expected = "this_is_http"
        testStore.set(.http, expected)
        #expect(testStore.get(.http) == expected)
    }

}
