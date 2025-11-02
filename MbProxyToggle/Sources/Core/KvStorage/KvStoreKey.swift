// 1. Make the struct and its init PUBLIC
public struct KvStoreKey<T> {
    public let rawValue: String

    // This public init fixes the "no accessible initializers" error
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension KvStoreKey where T == ProxySetting {
    static let http = KvStoreKey(rawValue: "http")
    static let https = KvStoreKey(rawValue: "https")
    static let socks = KvStoreKey(rawValue: "socks")
}
