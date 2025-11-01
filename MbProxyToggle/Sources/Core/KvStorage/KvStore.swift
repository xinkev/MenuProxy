/// A key-value store
protocol KvStore {
    func set<T>(_ key: KvStoreKey<T>, _ value: T)
    func get<T>(_ key: KvStoreKey<T>) -> T?
}
