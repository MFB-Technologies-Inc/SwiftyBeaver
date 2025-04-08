// GoogleCloudDestinationTests.swift
// SwiftyBeaver
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

//
//  GoogleCloudDestinationTests.swift
//  SwiftyBeaver
//
//  Created by Laurent Gaches on 10/04/2017.
//  Copyright © 2017 Sebastian Kreutzberger. All rights reserved.
//
import Foundation
@_spi(Testable) import SwiftyBeaver
import XCTest

class GoogleCloudDestinationTests: XCTestCase {
    func testUseGoogleCloudPDestination() {
        let log = SwiftyBeaver.Destinations()
        let gcpDestination = GoogleCloudDestination(serviceName: "TEST")
        gcpDestination.minLevel = .verbose
        XCTAssertTrue(log.addDestination(gcpDestination))
    }

    func testSend() {
        // let dateStr = formatter.stringFromDate(NSDate())
        let msg = "test message\nNewlineäößø"
        let thread = ""
        let file = "/file/path.swift"
        let function = "TestFunction()"
        let line: UInt = 123

        let gcpDestination = GoogleCloudDestination(serviceName: "TEST")
        let str = gcpDestination.send(.verbose, msg: msg, thread: thread, file: file, function: function, line: line)
        XCTAssertNotNil(str)
        if let str {
            XCTAssertEqual(str.first, "{")
            XCTAssertEqual(str.last, "}")
            XCTAssertNotNil(str.range(of: "{\"service\":\"TEST\"}"))
            XCTAssertNotNil(str.range(of: "\"severity\":\"DEBUG\""))
            XCTAssertNotNil(str.range(of: "\"message\":\"test message\\nNewlineäößø\""))
            XCTAssertNotNil(str.range(of: "\"functionName\":\"TestFunction()\""))
        }
    }

    func testContextMessage() {
        let msg = "test message\nNewlineäößø"
        let thread = ""
        let file = "/file/path.swift"
        let function = "TestFunction()"
        let line: UInt = 123

        let gcd = GoogleCloudDestination(serviceName: "SwiftyBeaver")

        let str = gcd.send(
            .verbose,
            msg: msg,
            thread: thread,
            file: file,
            function: function,
            line: line,
            context: ["user": "Beaver", "httpRequest": ["method": "GET", "responseStatusCode": 200]]
        )

        XCTAssertNotNil(str)
        if let str {
            XCTAssertEqual(str.first, "{")
            XCTAssertEqual(str.last, "}")
            XCTAssertNotNil(str.range(of: "{\"service\":\"SwiftyBeaver\"}"))
            XCTAssertNotNil(str.range(of: "\"severity\":\"DEBUG\""))
            XCTAssertNotNil(str.range(of: "\"message\":\"test message\\nNewlineäößø\""))
            XCTAssertNotNil(str.range(of: "\"functionName\":\"TestFunction()\""))
            XCTAssertNotNil(str.range(of: "\"user\":\"Beaver\""))
            XCTAssertNotNil(str.range(of: "\"method\":\"GET\""))
            XCTAssertNotNil(str.range(of: "\"responseStatusCode\":200"))
        }
    }
}

#if canImport(Testing)
    import Testing

    @Suite
    struct _GoogleCloudDestinationTests {
        @Test
        func useGoogleCloudPDestination() {
            let log = SwiftyBeaver.Destinations()
            let gcpDestination = GoogleCloudDestination(serviceName: "TEST")
            gcpDestination.minLevel = .verbose
            #expect(log.addDestination(gcpDestination))
        }

        @Test
        func send() {
            // let dateStr = formatter.stringFromDate(NSDate())
            let msg = "test message\nNewlineäößø"
            let thread = ""
            let file = "/file/path.swift"
            let function = "TestFunction()"
            let line: UInt = 123

            let gcpDestination = GoogleCloudDestination(serviceName: "TEST")
            let str = gcpDestination.send(
                .verbose, msg: msg, thread: thread, file: file, function: function, line: line
            )
            #expect(str != nil)
            if let str {
                #expect(str.first == "{")
                #expect(str.last == "}")
                #expect(str.range(of: "{\"service\":\"TEST\"}") != nil)
                #expect(str.range(of: "\"severity\":\"DEBUG\"") != nil)
                #expect(str.range(of: "\"message\":\"test message\\nNewlineäößø\"") != nil)
                #expect(str.range(of: "\"functionName\":\"TestFunction()\"") != nil)
            }
        }

        @Test
        func contextMessage() {
            let msg = "test message\nNewlineäößø"
            let thread = ""
            let file = "/file/path.swift"
            let function = "TestFunction()"
            let line: UInt = 123

            let gcd = GoogleCloudDestination(serviceName: "SwiftyBeaver")

            let str = gcd.send(
                .verbose,
                msg: msg,
                thread: thread,
                file: file,
                function: function,
                line: line,
                context: [
                    "user": "Beaver", "httpRequest": ["method": "GET", "responseStatusCode": 200],
                ]
            )

            #expect(str != nil)
            if let str {
                #expect(str.first == "{")
                #expect(str.last == "}")
                #expect(str.range(of: "{\"service\":\"SwiftyBeaver\"}") != nil)
                #expect(str.range(of: "\"severity\":\"DEBUG\"") != nil)
                #expect(str.range(of: "\"message\":\"test message\\nNewlineäößø\"") != nil)
                #expect(str.range(of: "\"functionName\":\"TestFunction()\"") != nil)
                #expect(str.range(of: "\"user\":\"Beaver\"") != nil)
                #expect(str.range(of: "\"method\":\"GET\"") != nil)
                #expect(str.range(of: "\"responseStatusCode\":200") != nil)
            }
        }
    }

#endif
