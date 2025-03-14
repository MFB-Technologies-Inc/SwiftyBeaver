// DestinationSetTests.swift
// SwiftyBeaver
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

import SwiftyBeaver
import XCTest

class DestinationSetTests: XCTestCase {
    override func setUp() {
        super.setUp()
        SwiftyBeaver.removeAllDestinations()
    }

    override func tearDown() {
        super.tearDown()
        SwiftyBeaver.removeAllDestinations()
    }

    func testChangeDestinationsMinLogLevels() {
        let log = SwiftyBeaver.self

        // Test for default state
        XCTAssertEqual(log.countDestinations(), 0)

        // add valid destinations
        let console = ConsoleDestination()
        let console2 = ConsoleDestination()
        let gcd = GoogleCloudDestination(serviceName: "service-name")

        XCTAssertTrue(log.addDestination(console))
        XCTAssertTrue(log.addDestination(console2))
        XCTAssertTrue(log.addDestination(gcd))

        // Test that destinations are successfully added
        XCTAssertEqual(log.countDestinations(), 3)

        // Test default log level of destinations
        for destination in log.destinations {
            XCTAssertEqual(destination.minLevel, SwiftyBeaver.Level.verbose)
        }

        // Change min log level for all destinations
        log.destinations.forEach { $0.minLevel = .info }

        // Test min level of destinations has changed
        for destination in log.destinations {
            XCTAssertEqual(destination.minLevel, SwiftyBeaver.Level.info)
        }
    }

    func testRemoveConsoleDestinations() {
        let log = SwiftyBeaver.self

        // Test for default state
        XCTAssertEqual(log.countDestinations(), 0)

        // add valid destinations
        let console = ConsoleDestination()
        let console2 = ConsoleDestination()
        let gcd = GoogleCloudDestination(serviceName: "service-name")

        XCTAssertTrue(log.addDestination(console))
        XCTAssertTrue(log.addDestination(console2))
        XCTAssertTrue(log.addDestination(gcd))

        // Test that destinations are successfully added
        XCTAssertEqual(log.countDestinations(), 3)

        // Remove console destinations
        for destination in log.destinations {
            if let consoleDestination = destination as? ConsoleDestination {
                XCTAssertTrue(log.removeDestination(consoleDestination))
            }
        }

        // Test that console destinations are removed
        XCTAssertEqual(log.countDestinations(), 1)
    }

    /*
     func testModifyingDestinationsWhileLoggingFromDifferentThread() {
         let log = SwiftyBeaver.self

         // Test for default state
         XCTAssertEqual(log.countDestinations(), 0)

         let concurrentQueue = DispatchQueue(label: "log queue", attributes: .concurrent)
         let serialQueue = DispatchQueue(label: "destination queue") // serial

         let expectation = XCTestExpectation(description: "Enough mutations on log destinations were made to likely trigger the race condition")

         startMutatingDestinations(log: log, queue: serialQueue, expectation: expectation)
         startSpammingLogs(log: log, queue: concurrentQueue)
         startSpammingLogs(log: log, queue: concurrentQueue)

         wait(for: [expectation], timeout: 10.0)
     }
     */

    private func startMutatingDestinations(
        log: SwiftyBeaver.Type,
        queue: DispatchQueue,
        expectation: XCTestExpectation,
        onGoingMutationCount: Int = 0
    ) {
        if onGoingMutationCount >= 1 {
            expectation.fulfill()
        }

        queue.async { [weak self, weak queue] in
            let destination = ConsoleDestination()
            log.addDestination(destination)

            queue?.asyncAfter(deadline: .now() + 0.2) { [weak self, weak queue] in
                _ = log.removeDestination(destination)

                queue?.asyncAfter(deadline: .now() + 0.2) { [weak self, weak queue] in
                    guard let self, let queue else { return }

                    startMutatingDestinations(
                        log: log,
                        queue: queue,
                        expectation: expectation,
                        onGoingMutationCount: onGoingMutationCount + 1
                    )
                }
            }
        }
    }

    private func startSpammingLogs(log: SwiftyBeaver.Type, queue: DispatchQueue) {
        queue.async { [weak self, weak queue] in
            log.info("Test Message")

            guard let self, let queue else { return }
            startSpammingLogs(log: log, queue: queue)
        }
    }
}
