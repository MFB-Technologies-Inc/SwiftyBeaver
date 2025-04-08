// SwiftyBeaverTests.swift
// SwiftyBeaver
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

import Foundation
@_spi(Testable) import SwiftyBeaver
import Testing

@Suite
struct SwiftyBeaverTests {
    var instanceVar = "an instance variable"

    @Test
    func addDestination() {
        let log = SwiftyBeaver.Destinations()

        // add invalid destination
        #expect(log.countDestinations() == 0)

        // add valid destinations
        let console = ConsoleDestination()
        let console2 = ConsoleDestination()
        let mock = MockDestination()

        #expect(log.countDestinations() == 0)
        #expect(log.addDestination(console))
        #expect(log.countDestinations() == 1)
        #expect(!log.addDestination(console))
        #expect(log.countDestinations() == 1)
        #expect(log.addDestination(console2))
        #expect(log.countDestinations() == 2)
        #expect(!log.addDestination(console2))
        #expect(log.addDestination(mock))
        #expect(log.countDestinations() == 3)
    }

    @Test
    func removeDestination() {
        let log = SwiftyBeaver.Destinations()

        // remove invalid destination
        #expect(log.countDestinations() == 0)

        // remove valid destinations
        let console = ConsoleDestination()
        let console2 = ConsoleDestination()
        let mock = MockDestination()

        // add destinations
        #expect(log.addDestination(console))
        #expect(log.addDestination(console2))
        #expect(log.addDestination(mock))
        #expect(log.countDestinations() == 3)
        // remove destinations
        #expect(log.removeDestination(console))
        #expect(log.countDestinations() == 2)
        #expect(!log.removeDestination(console))
        #expect(log.countDestinations() == 2)
        #expect(log.removeDestination(console2))
        #expect(!log.removeDestination(console2))
        #expect(log.countDestinations() == 1)
        #expect(log.removeDestination(mock))
        #expect(log.countDestinations() == 0)
    }

    @Test
    func logVerifiesIfShouldLogOnAllDestinations() {
        let log = SwiftyBeaver.Destinations()

        let dest1 = MockDestination()
        dest1.asynchronously = false
        let dest2 = MockDestination()
        dest2.asynchronously = false

        log.addDestination(dest1)
        log.addDestination(dest2)

        log.dispatch_send(
            level: .warning,
            message: "Message",
            thread: "Thread",
            file: "File",
            function: "Function()",
            line: 123,
            context: "Context"
        )

        #expect(dest1.shouldLogToLevel == SwiftyBeaver.Level.warning)
        #expect(dest2.shouldLogToLevel == SwiftyBeaver.Level.warning)

        #expect(dest1.shouldLogPath == "File")
        #expect(dest2.shouldLogPath == "File")

        #expect(dest1.shouldLogFunction == "Function()")
        #expect(dest2.shouldLogFunction == "Function()")

        #expect(dest1.shouldLogMessage == "Message")
        #expect(dest2.shouldLogMessage == "Message")
    }

    @Test
    func logCallsAllDestinations() {
        let log = SwiftyBeaver.Destinations()

        let dest1 = MockDestination()
        dest1.asynchronously = false
        let dest2 = MockDestination()
        dest2.asynchronously = false

        log.addDestination(dest1)
        log.addDestination(dest2)

        log.dispatch_send(
            level: .warning,
            message: "Message",
            thread: "Thread",
            file: "File",
            function: "Function()",
            line: 123,
            context: "Context"
        )

        #expect(dest1.didSendToLevel == SwiftyBeaver.Level.warning)
        #expect(dest2.didSendToLevel == SwiftyBeaver.Level.warning)

        #expect(dest1.didSendMessage == "Message")
        #expect(dest2.didSendMessage == "Message")

        #expect(dest1.didSendToThread == "Thread")
        #expect(dest2.didSendToThread == "Thread")

        #expect(dest1.didSendFile == "File")
        #expect(dest2.didSendFile == "File")

        #expect(dest1.didSendFunction == "Function()")
        #expect(dest2.didSendFunction == "Function()")

        #expect(dest1.didSendLine == 123)
        #expect(dest2.didSendLine == 123)

        #expect(dest1.didSendContext as? String == "Context")
        #expect(dest2.didSendContext as? String == "Context")
    }

    @Test
    func loggingWithoutDestination() {
        let log = SwiftyBeaver.Destinations()
        // no destination was set, yet
        log.verbose("Where do I log to?")
    }

    @Test
    func destinationIntegration() {
        let log = SwiftyBeaver.Destinations()
        log.verbose("that should lead to nowhere")

        // add console
        let console = ConsoleDestination()
        #expect(log.addDestination(console))
        log.verbose("the default console destination")
        // add another console and set it to be less chatty
        let console2 = ConsoleDestination()
        #expect(log.addDestination(console2))
        #expect(log.countDestinations() == 2)
        console2.format = "$L: $M"
        console2.minLevel = SwiftyBeaver.Level.debug
        log.verbose("a verbose hello from hopefully just 1 console!")
        log.debug("a debug hello from 2 different consoles!")

        // add mock
        let mock = MockDestination()
        #expect(log.addDestination(mock))
        #expect(log.countDestinations() == 3)
        log.verbose("default mock msg 1")
        log.verbose("default mock msg 2")
        log.verbose("default mock msg 3")

        // log to another mock
        let mock2 = MockDestination()
        console2.format = "$L: $M"
        mock2.minLevel = SwiftyBeaver.Level.debug
        #expect(log.addDestination(mock2))
        #expect(log.countDestinations() == 4)
        log.verbose("this should be in mock 1")
        log.debug("this should be in both mocks, msg 1")
        log.info("this should be in both mocks, msg 2")

        // log to default mock location
        let mock3 = MockDestination()
        console2.format = "$L: $M"
        #expect(log.addDestination(mock3))
        #expect(log.countDestinations() == 5)
    }

    @Test
    func colors() {
        let log = SwiftyBeaver.Destinations()
        log.verbose("that should lead to nowhere")

        // add console
        let console = ConsoleDestination()
        #expect(log.addDestination(console))

        // add mock
        let mock = MockDestination()
        mock.format = "$L: $M"
        #expect(log.addDestination(mock))

        log.verbose("not so important")
        log.debug("something to debug")
        log.info("a nice information")
        log.warning("oh no, that won’t be good")
        log.error("ouch, an error did occur!")

        #expect(log.countDestinations() == 2)
    }

    @Test
    func uptime() {
        let log = SwiftyBeaver.Destinations()
        log.verbose("that should lead to nowhere")

        // add console
        let console = ConsoleDestination()
        console.format = "$U: $M"
        #expect(log.addDestination(console))

        // add mock
        let mock = MockDestination()
        mock.format = "$U: $M"
        #expect(log.addDestination(mock))

        log.verbose("not so important")
        log.debug("something to debug")
        log.info("a nice information")
        log.warning("oh no, that won’t be good")
        log.error("ouch, an error did occur!")

        #expect(log.countDestinations() == 2)
    }

    @Test
    func modifiedColors() {
        let log = SwiftyBeaver.Destinations()

        // add console
        let console = ConsoleDestination()
        #expect(log.addDestination(console))

        // change default color
        console.levelColor.verbose = "fg255,0,255;"
        console.levelColor.debug = "fg255,100,0;"
        console.levelColor.info = ""
        console.levelColor.warning = "fg255,255,255;"
        console.levelColor.error = "fg100,0,200;"

        log.verbose("not so important, level in magenta")
        log.debug("something to debug, level in orange")
        log.info("a nice information, level in black")
        log.warning("oh no, that won’t be good, level in white")
        log.error("ouch, an error did occur!, level in purple")
    }

    @Test
    func differentMessageTypes() {
        let log = SwiftyBeaver.Destinations()

        // add console
        let console = ConsoleDestination()
        console.format = "$L: $M"
        console.levelString.info = "interesting number"
        #expect(log.addDestination(console))

        log.verbose("My name is üÄölèå")
        log.verbose(123)
        log.info(-123.45678)
        log.warning(NSDate())
        log.error(["I", "like", "logs!"])
        log.error(["beaver": "yeah", "age": 12])

        // JSON Logging
        let jsonConsole = ConsoleDestination()
        jsonConsole.format = "$J"
        #expect(log.addDestination(jsonConsole))

        log.verbose("My name is üÄölèå")
        log.verbose(123)
        log.info(-123.45678)
        log.warning(NSDate())
        log.error(["I", "like", "logs!"])
        log.error(["beaver": "yeah", "age": 12])

        #expect(log.countDestinations() == 2)
    }

    @Test
    func autoClosure() {
        let log = SwiftyBeaver.Destinations()
        // add console
        let console = ConsoleDestination()
        #expect(log.addDestination(console))
        // should not create a compile error relating autoclosure
        log.info(instanceVar)
    }

    @Test
    func longRunningTaskIsNotExecutedWhenLoggingUnderMinLevel() {
        let log = SwiftyBeaver.Destinations()

        // add console
        let console = ConsoleDestination()
        // set info level on default
        console.minLevel = .info

        #expect(log.addDestination(console))

        func longRunningTask() -> String {
            Issue.record(
                "A block passed should not be executed if the log should not be logged."
            )
            return "This should NOT BE VISIBLE!"
        }

        log.verbose(longRunningTask())
    }

    @Test
    func versionAndBuild() {
        #expect(SwiftyBeaver.version.count > 4)
        #expect(SwiftyBeaver.build > 500)
    }

    @Test
    func stripParams() {
        var f = "singleParam"
        #expect(SwiftyBeaver.Destinations.stripParams(function: f) == "singleParam()")
        f = "logWithParamFunc(_:foo:hello:)"
        #expect(SwiftyBeaver.Destinations.stripParams(function: f) == "logWithParamFunc()")
        f = "aFunc()"
        #expect(SwiftyBeaver.Destinations.stripParams(function: f) == "aFunc()")
    }

    @Test
    func getCorrectThread() async {
        #if !os(Linux)
            let log = SwiftyBeaver.Destinations()
            let mock = MockDestination()
            // set info level on default
            mock.minLevel = .verbose
            mock.asynchronously = false

            log.addDestination(mock)

            await Task(priority: .userInitiated) {
                log.verbose("Hi")
                #expect(mock.didSendToThread == "com.apple.root.user-initiated-qos.cooperative")
                log.debug("Hi")
                #expect(mock.didSendToThread == "com.apple.root.user-initiated-qos.cooperative")
                log.info("Hi")
                #expect(mock.didSendToThread == "com.apple.root.user-initiated-qos.cooperative")
                log.warning("Hi")
                #expect(mock.didSendToThread == "com.apple.root.user-initiated-qos.cooperative")
                log.error("Hi")
                #expect(mock.didSendToThread == "com.apple.root.user-initiated-qos.cooperative")
            }.value

            await Task(priority: .background) {
                log.verbose("Hi")
                #expect(mock.didSendToThread == "com.apple.root.background-qos.cooperative")
                log.debug("Hi")
                #expect(mock.didSendToThread == "com.apple.root.background-qos.cooperative")
                log.info("Hi")
                #expect(mock.didSendToThread == "com.apple.root.background-qos.cooperative")
                log.warning("Hi")
                #expect(mock.didSendToThread == "com.apple.root.background-qos.cooperative")
                log.error("Hi")
                #expect(mock.didSendToThread == "com.apple.root.background-qos.cooperative")
            }.value

            let dispatchQueue = DispatchQueue(label: "MyTestLabel")
            dispatchQueue.sync {
                log.verbose("Hi")
                #expect(mock.didSendToThread == "MyTestLabel")
                log.debug("Hi")
                #expect(mock.didSendToThread == "MyTestLabel")
                log.info("Hi")
                #expect(mock.didSendToThread == "MyTestLabel")
                log.warning("Hi")
                #expect(mock.didSendToThread == "MyTestLabel")
                log.error("Hi")
                #expect(mock.didSendToThread == "MyTestLabel")
            }
        #endif
    }
}

private class MockDestination: BaseDestination, @unchecked Sendable {
    var didSendToLevel: SwiftyBeaver.Level?
    var didSendMessage: String?
    var didSendToThread: String?
    var didSendFile: String?
    var didSendFunction: String?
    var didSendLine: UInt?
    var didSendContext: Any??

    override func send(
        _ level: SwiftyBeaver.Level,
        msg: String,
        thread: String,
        file: String,
        function: String,
        line: UInt,
        context: Any?
    ) -> String? {
        didSendToLevel = level
        didSendMessage = msg
        didSendToThread = thread
        didSendFile = file
        didSendFunction = function
        didSendLine = line
        didSendContext = context

        return ""
    }

    var shouldLogToLevel: SwiftyBeaver.Level?
    var shouldLogPath: String?
    var shouldLogFunction: String?
    var shouldLogMessage: String?
    override func shouldLevelBeLogged(
        _ level: SwiftyBeaver.Level,
        path: String,
        function: String,
        message: String?
    ) -> Bool {
        shouldLogToLevel = level
        shouldLogPath = path
        shouldLogFunction = function
        shouldLogMessage = message
        return true
    }

    override func hasMessageFilters() -> Bool {
        true
    }
}
