import Testing

@testable import MbProxyToggle

final class CommandTests {
    @Test("Runs a successful command")
    func testCommands() throws {
        let group = CommandGroup([
            Command("echo", args: ["hello"])
        ])

        let output = try group.runAll()

        #expect(output.first == "hello\n")
    }

    @Test("Fails with a readable message")
    func testFailure() throws {
        let group = CommandGroup([
            Command("nonexistentcommand", args: ["arg"])
        ])

        do {
            try group.runAll()
        } catch {
            #expect(error is CommandError)
            let err = error as! CommandError
            #expect(err.message.contains("Command failed:"))
        }
    }

    @Test("Stops after the first failure")
    func testStopAfterFailure() throws {
        let group = CommandGroup([
            Command("echo", args: ["one"]),
            Command("nonexistentcommand"),
            Command("echo", args: ["two"]),
        ])

        do {
            let output = try group.runAll()
            #expect(output.contains("one\n"))
            #expect(!output.contains("two"))
        } catch {
            #expect(error is CommandError)
        }
    }
}
