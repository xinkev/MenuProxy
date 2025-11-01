
// 1. Make the struct and its init PUBLIC
public struct KvStoreKey<T> {
    public let rawValue: String
    
    // This public init fixes the "no accessible initializers" error
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension KvStoreKey where T == String {
    public static let http = KvStoreKey<String>(rawValue: "http")
    public static let https = KvStoreKey<String>(rawValue: "https")
    public static let socks = KvStoreKey<String>(rawValue: "socks")
}