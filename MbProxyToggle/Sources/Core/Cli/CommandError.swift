struct CommandError: Error {
    let command: String
    let output: String

    var message: String {
        var msg = "\nCommand failed:\n\(command)"
        if !output.isEmpty {
            msg += "\n\n\(output)"
        }
        return msg
    }
}
