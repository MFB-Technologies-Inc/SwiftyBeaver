// SwiftyBeaverLogHandlerTests.swift
// SwiftyBeaver
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import Logging
import SwiftyBeaver
import SwiftyBeaverSwiftLog
import Testing

// Bootstapping `LoggingSystem` more than once causes a crash
let bootstapped: Bool = {
    LoggingSystem.bootstrap { label in
        SwiftyBeaverLogHandler(metadata: ["label": .string(label)])
    }
    return true
}()

@Suite(.serialized)
final class SwiftyBeaverLogHandlerTests {
    init() {
        _ = bootstapped
        SwiftyBeaver.removeAllDestinations()
    }

    @Test
    func setLogLevel() {
        let destinationA = InMemoryDestination()
        destinationA.minLevel = .debug
        let destinationB = FileDestination()
        destinationB.minLevel = .warning
        let destinationC = GoogleCloudDestination(serviceName: "")
        destinationC.minLevel = .critical

        SwiftyBeaver.addDestination(destinationA)
        SwiftyBeaver.addDestination(destinationB)
        SwiftyBeaver.addDestination(destinationC)

        var logger = Logger(label: "LABEL")

        #expect(destinationA.minLevel == .debug)
        #expect(destinationB.minLevel == .warning)
        #expect(destinationC.minLevel == .critical)

        logger.logLevel = .info
        let logLevel = logger.logLevel

        #expect(logLevel == .info)

        #expect(destinationA.minLevel == .debug)
        #expect(destinationB.minLevel == .warning)
        #expect(destinationC.minLevel == .critical)
    }

    @Test
    func logMessages() {
        let destination = InMemoryDestination()
        SwiftyBeaver.addDestination(destination)

        let logger = Logger(label: "LABEL")

        logger.trace("trace-message", line: 1)
        logger.debug("debug-message", line: 2)
        logger.info("info-message", line: 3)
        logger.notice("notice-message", line: 4)
        logger.warning("warning-message", line: 5)
        logger.error("error-message", line: 6)
        logger.critical("critical-message", line: 7)

        #expect(destination.messages == [
            "18:00:00.000 VERBOSE SwiftyBeaverLogHandlerTests.logMessages():1 - trace-message",
            "18:00:00.000 DEBUG SwiftyBeaverLogHandlerTests.logMessages():2 - debug-message",
            "18:00:00.000 INFO SwiftyBeaverLogHandlerTests.logMessages():3 - info-message",
            "18:00:00.000 INFO SwiftyBeaverLogHandlerTests.logMessages():4 - notice-message",
            "18:00:00.000 WARNING SwiftyBeaverLogHandlerTests.logMessages():5 - warning-message",
            "18:00:00.000 ERROR SwiftyBeaverLogHandlerTests.logMessages():6 - error-message",
            "18:00:00.000 CRITICAL SwiftyBeaverLogHandlerTests.logMessages():7 - critical-message",
        ])
    }

    @Test
    func logMessagesWithIndependentDestinationMinLogLevel() {
        let destinationA = InMemoryDestination()
        destinationA.minLevel = .debug
        SwiftyBeaver.addDestination(destinationA)

        let destinationB = InMemoryDestination()
        destinationB.minLevel = .error
        SwiftyBeaver.addDestination(destinationB)

        var logger = Logger(label: "LABEL")

        logger.logLevel = .info

        logger.trace("trace-message", line: 1)
        logger.debug("debug-message", line: 2)
        logger.info("info-message", line: 3)
        logger.notice("notice-message", line: 4)
        logger.warning("warning-message", line: 5)
        logger.error("error-message", line: 6)
        logger.critical("critical-message", line: 7)

        #expect(destinationA.messages == [
            "18:00:00.000 INFO SwiftyBeaverLogHandlerTests.logMessagesWithIndependentDestinationMinLogLevel():3 - info-message",
            "18:00:00.000 INFO SwiftyBeaverLogHandlerTests.logMessagesWithIndependentDestinationMinLogLevel():4 - notice-message",
            "18:00:00.000 WARNING SwiftyBeaverLogHandlerTests.logMessagesWithIndependentDestinationMinLogLevel():5 - warning-message",
            "18:00:00.000 ERROR SwiftyBeaverLogHandlerTests.logMessagesWithIndependentDestinationMinLogLevel():6 - error-message",
            "18:00:00.000 CRITICAL SwiftyBeaverLogHandlerTests.logMessagesWithIndependentDestinationMinLogLevel():7 - critical-message",
        ])

        #expect(destinationB.messages == [
            "18:00:00.000 ERROR SwiftyBeaverLogHandlerTests.logMessagesWithIndependentDestinationMinLogLevel():6 - error-message",
            "18:00:00.000 CRITICAL SwiftyBeaverLogHandlerTests.logMessagesWithIndependentDestinationMinLogLevel():7 - critical-message",
        ])
    }

    @Test
    func logMessagesWithMetaData() {
        let destination = InMemoryDestination()
        destination.format = "$X - $M"
        SwiftyBeaver.addDestination(destination)

        let logger = Logger(label: "LABEL")

        logger.critical("critical-message", line: 1)

        #expect(destination.messages == [
            #"["label": LABEL] - critical-message"#.description,
        ])
    }

    @Test
    func logMessagesWithMinimumLevelOfDebug() {
        let destination = InMemoryDestination()
        SwiftyBeaver.addDestination(destination)

        var logger = Logger(label: "LABEL")
        logger.handler.logLevel = .debug

        logger.trace("trace-message", line: 1)
        logger.debug("debug-message", line: 2)
        logger.info("info-message", line: 3)
        logger.notice("notice-message", line: 4)
        logger.warning("warning-message", line: 5)
        logger.error("error-message", line: 6)
        logger.critical("critical-message", line: 7)

        #expect(destination.messages == [
            "18:00:00.000 DEBUG SwiftyBeaverLogHandlerTests.logMessagesWithMinimumLevelOfDebug():2 - debug-message",
            "18:00:00.000 INFO SwiftyBeaverLogHandlerTests.logMessagesWithMinimumLevelOfDebug():3 - info-message",
            "18:00:00.000 INFO SwiftyBeaverLogHandlerTests.logMessagesWithMinimumLevelOfDebug():4 - notice-message",
            "18:00:00.000 WARNING SwiftyBeaverLogHandlerTests.logMessagesWithMinimumLevelOfDebug():5 - warning-message",
            "18:00:00.000 ERROR SwiftyBeaverLogHandlerTests.logMessagesWithMinimumLevelOfDebug():6 - error-message",
            "18:00:00.000 CRITICAL SwiftyBeaverLogHandlerTests.logMessagesWithMinimumLevelOfDebug():7 - critical-message",
        ])
    }

    @Test
    func logMessagesWithMinimumLevelOfInfo() {
        let destination = InMemoryDestination()
        SwiftyBeaver.addDestination(destination)

        var logger = Logger(label: "LABEL")
        logger.handler.logLevel = .info

        logger.trace("trace-message", line: 1)
        logger.debug("debug-message", line: 2)
        logger.info("info-message", line: 3)
        logger.notice("notice-message", line: 4)
        logger.warning("warning-message", line: 5)
        logger.error("error-message", line: 6)
        logger.critical("critical-message", line: 7)

        #expect(destination.messages == [
            "18:00:00.000 INFO SwiftyBeaverLogHandlerTests.logMessagesWithMinimumLevelOfInfo():3 - info-message",
            "18:00:00.000 INFO SwiftyBeaverLogHandlerTests.logMessagesWithMinimumLevelOfInfo():4 - notice-message",
            "18:00:00.000 WARNING SwiftyBeaverLogHandlerTests.logMessagesWithMinimumLevelOfInfo():5 - warning-message",
            "18:00:00.000 ERROR SwiftyBeaverLogHandlerTests.logMessagesWithMinimumLevelOfInfo():6 - error-message",
            "18:00:00.000 CRITICAL SwiftyBeaverLogHandlerTests.logMessagesWithMinimumLevelOfInfo():7 - critical-message",
        ])
    }

    @Test
    func logMessagesWithMinimumLevelOfNotice() {
        let destination = InMemoryDestination()
        SwiftyBeaver.addDestination(destination)

        var logger = Logger(label: "LABEL")
        logger.handler.logLevel = .notice

        logger.trace("trace-message", line: 1)
        logger.debug("debug-message", line: 2)
        logger.info("info-message", line: 3)
        logger.notice("notice-message", line: 4)
        logger.warning("warning-message", line: 5)
        logger.error("error-message", line: 6)
        logger.critical("critical-message", line: 7)

        #expect(destination.messages == [
            "18:00:00.000 INFO SwiftyBeaverLogHandlerTests.logMessagesWithMinimumLevelOfNotice():4 - notice-message",
            "18:00:00.000 WARNING SwiftyBeaverLogHandlerTests.logMessagesWithMinimumLevelOfNotice():5 - warning-message",
            "18:00:00.000 ERROR SwiftyBeaverLogHandlerTests.logMessagesWithMinimumLevelOfNotice():6 - error-message",
            "18:00:00.000 CRITICAL SwiftyBeaverLogHandlerTests.logMessagesWithMinimumLevelOfNotice():7 - critical-message",
        ])
    }

    @Test
    func logMessagesWithMinimumLevelOfWarning() {
        let destination = InMemoryDestination()
        SwiftyBeaver.addDestination(destination)

        var logger = Logger(label: "LABEL")
        logger.handler.logLevel = .warning

        logger.trace("trace-message", line: 1)
        logger.debug("debug-message", line: 2)
        logger.info("info-message", line: 3)
        logger.notice("notice-message", line: 4)
        logger.warning("warning-message", line: 5)
        logger.error("error-message", line: 6)
        logger.critical("critical-message", line: 7)

        #expect(destination.messages == [
            "18:00:00.000 WARNING SwiftyBeaverLogHandlerTests.logMessagesWithMinimumLevelOfWarning():5 - warning-message",
            "18:00:00.000 ERROR SwiftyBeaverLogHandlerTests.logMessagesWithMinimumLevelOfWarning():6 - error-message",
            "18:00:00.000 CRITICAL SwiftyBeaverLogHandlerTests.logMessagesWithMinimumLevelOfWarning():7 - critical-message",
        ])
    }

    @Test
    func logMessagesWithMinimumLevelOfError() {
        let destination = InMemoryDestination()
        SwiftyBeaver.addDestination(destination)

        var logger = Logger(label: "LABEL")
        logger.handler.logLevel = .error

        logger.trace("trace-message", line: 1)
        logger.debug("debug-message", line: 2)
        logger.info("info-message", line: 3)
        logger.notice("notice-message", line: 4)
        logger.warning("warning-message", line: 5)
        logger.error("error-message", line: 6)
        logger.critical("critical-message", line: 7)

        #expect(destination.messages == [
            "18:00:00.000 ERROR SwiftyBeaverLogHandlerTests.logMessagesWithMinimumLevelOfError():6 - error-message",
            "18:00:00.000 CRITICAL SwiftyBeaverLogHandlerTests.logMessagesWithMinimumLevelOfError():7 - critical-message",
        ])
    }

    @Test
    func logMessagesWithMinimumLevelOfCritical() {
        let destination = InMemoryDestination()
        SwiftyBeaver.addDestination(destination)

        var logger = Logger(label: "LABEL")
        logger.handler.logLevel = .critical

        logger.trace("trace-message", line: 1)
        logger.debug("debug-message", line: 2)
        logger.info("info-message", line: 3)
        logger.notice("notice-message", line: 4)
        logger.warning("warning-message", line: 5)
        logger.error("error-message", line: 6)
        logger.critical("critical-message", line: 7)

        #expect(destination.messages == [
            "18:00:00.000 CRITICAL SwiftyBeaverLogHandlerTests.logMessagesWithMinimumLevelOfCritical():7 - critical-message",
        ])
    }
}

final class InMemoryDestination: BaseDestination {
    var messages: [String]

    init(messages: [String] = []) {
        self.messages = messages
        super.init()
        asynchronously = false
    }

    override class func date() -> Date {
        Date(timeIntervalSinceReferenceDate: 0)
    }

    override func send(
        _ level: SwiftyBeaver.Level,
        msg: String,
        thread: String,
        file: String,
        function: String,
        line: UInt,
        context: Any? = nil
    ) -> String? {
        guard let formattedMessage = super.send(
            level,
            msg: msg,
            thread: thread,
            file: file,
            function: function,
            line: line,
            context: context
        ) else {
            Issue.record("No formatted message returned for message: \(msg)")
            return msg
        }
        messages.append(formattedMessage)
        return formattedMessage
    }
}
