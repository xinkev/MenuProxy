
@testable import MbProxyToggle

class MockStore: KvStore {
    var storage: [String: Any] = [:]
    func get<T>(_ key: KvStoreKey<T>) -> T? {
        return storage[key.rawValue] as? T
    }
    
    func set<T>(_ key: KvStoreKey<T>, _ value: T) {
        storage[key.rawValue] = value
    }

    func setData<T>(_ key: KvStoreKey<T>, _ value: T) where T : Encodable {
       storage[key.rawValue] = value;
    }

    func getData<T>(_ key: KvStoreKey<T>) -> T? where T : Decodable {
        return storage[key.rawValue] as? T
    }
}
