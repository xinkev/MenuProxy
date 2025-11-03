// Util struct to create networksetup commands
struct NetworkSetup {
    private let command = Command("networksetup")
    private let ni = "Wi-Fi"

    func buildActivateProxyCommands(proxies: [ProxySetting]) -> [Command] {
        proxies
            .filter { $0.enabled }
            .map { proxy in
                activateProxy(for: proxy.type, server: proxy.server, port: proxy.port)
            }
    }
    func buildDeactivateProxyCommands(proxies: [ProxySetting]) -> [Command] {
        proxies
            .filter { $0.enabled }
            .map { proxy in
                deactivateProxy(proxy.type)
            }
    }

    private func activateProxy(for type: ProxyType, server: String, port: String) -> Command {
        let flag =
            switch type {
            case .http: "-setwebproxy"
            case .https: "-setsecurewebproxy"
            case .socks: "-setsocksfirewallproxy"
            }
        return
            command
            .flag(flag)
            .args([ni, server, port])
    }

    private func deactivateProxy(_ type: ProxyType) -> Command {
        let flag =
            switch type {
            case .http: "-setwebproxystate"
            case .https: "-setsecurewebproxystate"
            case .socks: "-setsocksfirewallproxystate"
            }
        return command
            .flag(flag)
            .args([ni, "off"])
    }
}
