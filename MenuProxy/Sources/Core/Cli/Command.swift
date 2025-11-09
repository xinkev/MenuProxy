import Foundation

struct Command {
    private let executable: String
    private var arguments: [String]

    init(_ exectable: String, args: [String]) {
        self.executable = exectable
        self.arguments = args
    }

    init(_ executable: String) {
        self.executable = executable
        self.arguments = []
    }

    func args(_ args: [String]) -> Command {
        var copy = self
        copy.arguments += args
        return copy
    }

    func arg(_ value: String) -> Command {
        var copy = self
        copy.arguments.append(value)
        return copy
    }

    func flag(_ value: String) -> Command {
        arg(value)
    }

    @discardableResult
    func run() throws -> String? {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = [executable] + arguments

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        print("running: \(toString())")
        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        if let output = output {
            print(output)
        }

        if process.terminationStatus != 0 {
            throw CommandError(command: toString(), output: output ?? "")
        } else {
            return output
        }
    }

    func toString() -> String {
        ([executable] + arguments).joined(separator: " ")
    }
}