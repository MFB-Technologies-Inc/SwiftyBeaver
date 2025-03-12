// LinuxMain.swift
// SwiftyBeaver
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

@testable import SwiftyBeaverTests
import XCTest

XCTMain([
    testCase(BaseDestinationTests.allTests),
    testCase(ConsoleDestinationTests.allTests),
    testCase(SwiftyBeaverTests.allTests),
])
