import Foundation

extension UserDefaults: KvStore {
    func set<T>(_ key: KvStoreKey<T>, _ value: T) {
        self.set(value, forKey: key.rawValue)
    }

    func get<T>(_ key: KvStoreKey<T>) -> T? {
        return self.object(forKey: key.rawValue) as? T
    }
}
