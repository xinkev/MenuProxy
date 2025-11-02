struct ProxySetting: Identifiable, Codable, Hashable, Equatable {
    // Make this struct identifiable by type
    var id: ProxyType { type }
    let type: ProxyType
    var address: String
    var enabled: Bool

    var server: String {
        address.components(separatedBy: ":")[0]
    }

    var port: String {
        address.components(separatedBy: ":")[1]
    }

    init(type: ProxyType) {
        self.type = type
        self.address = ""
        self.enabled = false
    }

    init(
        _ address: String,
        type: ProxyType,
        enabled: Bool
    ) {
        self.type = type
        self.address = address
        self.enabled = enabled
    }
}
