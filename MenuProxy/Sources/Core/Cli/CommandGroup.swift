struct CommandGroup {
    private let commands: [Command]

    init(_ commands: [Command]) {
        self.commands = commands
    }

    @discardableResult
    func runAll() throws -> [String] {
        try commands.map { command in
            try command.run() ?? ""
        }
    }
}