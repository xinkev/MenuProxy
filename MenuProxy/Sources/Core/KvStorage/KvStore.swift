/// A key-value store
protocol KvStore {
    func set<T>(_ key: KvStoreKey<T>, _ value: T)
    func get<T>(_ key: KvStoreKey<T>) -> T?
    func setData<T: Encodable>(_ key: KvStoreKey<T>, _ value: T)
    func getData<T: Decodable>(_ key: KvStoreKey<T>) -> T?
}
