protocol NetworkSetup {
    func activateProxy(for type: ProxyType, server: String, port: String) throws
    func deactivateProxy(_ type: ProxyType) throws
}