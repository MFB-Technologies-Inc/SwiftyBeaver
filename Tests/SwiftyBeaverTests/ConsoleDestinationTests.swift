// ConsoleDestinationTests.swift
// SwiftyBeaver
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

import Foundation
@testable import SwiftyBeaver
import XCTest

class ConsoleDestinationTests: XCTestCase {
    override func setUp() {
        super.setUp()
        SwiftyBeaver.removeAllDestinations()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testUseTerminalColors() {
        let log = SwiftyBeaver.self
        let console = ConsoleDestination()
        XCTAssertTrue(log.addDestination(console))

        // default xcode colors
        XCTAssertFalse(console.useTerminalColors)
        XCTAssertEqual(console.levelColor.verbose, "⬜️ ")
        XCTAssertEqual(console.reset, "")
        XCTAssertEqual(console.escape, "")

        // switch to terminal colors
        console.useTerminalColors = true
        XCTAssertTrue(console.useTerminalColors)
        XCTAssertEqual(console.levelColor.verbose, "251m")
        XCTAssertEqual(console.reset, "\u{001b}[0m")
        XCTAssertEqual(console.escape, "\u{001b}[38;5;")
    }
}
