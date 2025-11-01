struct ProxySetting: Identifiable {
    // Make this struct identifiable by type
    var id: ProxyType { type }
    let type: ProxyType
    var address: String
    var enabled: Bool

    init(type: ProxyType) {
        self.type = type
        self.address = ""
        self.enabled = false
    }
}
