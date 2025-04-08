// ConsoleDestinationTests.swift
// SwiftyBeaver
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

import Foundation
@_spi(Testable) import SwiftyBeaver
import Testing

@Suite
struct ConsoleDestinationTests {
    @Test
    func useTerminalColors() {
        let log = SwiftyBeaver.Destinations()
        let console = ConsoleDestination()
        #expect(log.addDestination(console))

        // default xcode colors
        #expect(!console.useTerminalColors)
        #expect(console.levelColor.verbose == "⬜️ ")
        #expect(console.reset == "")
        #expect(console.escape == "")

        // switch to terminal colors
        console.useTerminalColors = true
        #expect(console.useTerminalColors)
        #expect(console.levelColor.verbose == "251m")
        #expect(console.reset == "\u{001b}[0m")
        #expect(console.escape == "\u{001b}[38;5;")
    }
}
