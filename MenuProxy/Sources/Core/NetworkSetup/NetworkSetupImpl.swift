// Util struct to create networksetup commands
struct NetworkSetupImpl: NetworkSetup {
    private let command = Command("networksetup")
    private let ni = "Wi-Fi"

    func activateProxy(for type: ProxyType, server: String, port: String) throws {
        let flag =
            switch type {
            case .http: "-setwebproxy"
            case .https: "-setsecurewebproxy"
            case .socks: "-setsocksfirewallproxy"
            }

        try command
            .flag(flag)
            .args([ni, server, port])
            .run()
    }

    func deactivateProxy(_ type: ProxyType) throws {
        let flag =
            switch type {
            case .http: "-setwebproxystate"
            case .https: "-setsecurewebproxystate"
            case .socks: "-setsocksfirewallproxystate"
            }
        try command
            .flag(flag)
            .args([ni, "off"])
            .run()
    }
}
