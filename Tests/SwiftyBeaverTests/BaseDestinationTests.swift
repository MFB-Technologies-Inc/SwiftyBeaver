// BaseDestinationTests.swift
// SwiftyBeaver
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

import Foundation
@testable import SwiftyBeaver
import XCTest

class BaseDestinationTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInit() {
        let obj = BaseDestination()
        XCTAssertNotNil(obj.queue)
    }

    ////////////////////////////////

    // MARK: Format

    ////////////////////////////////

    func testFormatMessage() {
        let obj = BaseDestination()
        var str = ""
        var format = ""

        // empty format
        format = ""
        str = obj.formatMessage(
            format,
            level: .verbose,
            msg: "Hello",
            thread: "main",
            file: "/path/to/ViewController.swift",
            function: "testFunction()",
            line: 50
        )
        XCTAssertEqual(str, "")

        // format without variables
        format = "Hello"
        str = obj.formatMessage(
            format,
            level: .verbose,
            msg: "Hello",
            thread: "main",
            file: "/path/to/ViewController.swift",
            function: "testFunction()",
            line: 50
        )
        XCTAssertEqual(str, "Hello")

        // format without variables (make sure the L is not interpreted as format character)
        format = "Linda"
        str = obj.formatMessage(
            format,
            level: .verbose,
            msg: "Hello",
            thread: "main",
            file: "/path/to/ViewController.swift",
            function: "testFunction()",
            line: 50
        )
        XCTAssertEqual(str, "Linda")
        format = "$Linda $M"
        str = obj.formatMessage(
            format,
            level: .verbose,
            msg: "Hello",
            thread: "main",
            file: "/path/to/ViewController.swift",
            function: "testFunction()",
            line: 50
        )
        XCTAssertEqual(str, "VERBOSEinda Hello")

        // weird format
        format = "$"
        str = obj.formatMessage(
            format,
            level: .verbose,
            msg: "Hello",
            thread: "main",
            file: "/path/to/ViewController.swift",
            function: "testFunction()",
            line: 50
        )
        XCTAssertEqual(str, "")

        // basic format with ignored color and thread
        format = "|$T| $C$L$c: $M"
        str = obj.formatMessage(
            format,
            level: .verbose,
            msg: "Hello",
            thread: "main",
            file: "/path/to/ViewController.swift",
            function: "testFunction()",
            line: 50
        )
        XCTAssertEqual(str, "|main| VERBOSE: Hello")

        // format with date and color
        let obj2 = BaseDestination()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = formatter.string(from: Date())

        obj2.levelColor.verbose = "?"
        obj2.escape = ">"
        obj2.reset = "<"

        format = "[$Dyyyy-MM-dd HH:mm:ss$d] |$T| $N.$F:$l $C$L$c: $M"
        str = obj2.formatMessage(
            format,
            level: .verbose,
            msg: "Hello",
            thread: "main",
            file: "/path/to/ViewController.swift",
            function: "testFunction()",
            line: 50
        )
        XCTAssertEqual(str, "[\(dateStr)] |main| ViewController.testFunction():50 >?VERBOSE<: Hello")

        //  UTC datetime
        let obj3 = BaseDestination()
        let utcFormatter = DateFormatter()
        utcFormatter.timeZone = TimeZone(abbreviation: "UTC")
        utcFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let utcDateStr = utcFormatter.string(from: Date())
        str = BaseDestination().formatDate(utcFormatter.dateFormat, timeZone: "UTC")

        format = "$Zyyyy-MM-dd HH:mm:ss$z"
        str = obj3.formatMessage(
            format,
            level: .verbose,
            msg: "Hello",
            thread: "main",
            file: "/path/to/ViewController.swift",
            function: "testFunction()",
            line: 50
        )
        XCTAssertEqual(str, "\(utcDateStr)")

        // context in different formats
        let obj4 = BaseDestination()
        format = "$L: $M $X"
        str = obj4.formatMessage(
            format,
            level: .verbose,
            msg: "Hello",
            thread: "main",
            file: "/path/to/ViewController.swift",
            function: "testFunction()",
            line: 50,
            context: "Context!"
        )
        XCTAssertEqual(str, "VERBOSE: Hello Context!")

        str = obj4.formatMessage(
            format,
            level: .verbose,
            msg: "Hello",
            thread: "main",
            file: "/path/to/ViewController.swift",
            function: "testFunction()",
            line: 50,
            context: 123
        )
        XCTAssertEqual(str, "VERBOSE: Hello 123")

        str = obj4.formatMessage(
            format,
            level: .verbose,
            msg: "Hello",
            thread: "main",
            file: "/path/to/ViewController.swift",
            function: "testFunction()",
            line: 50,
            context: [1, "a", 2]
        )
        XCTAssertEqual(str, "VERBOSE: Hello [1, \"a\", 2]")

        str = obj4.formatMessage(
            format,
            level: .verbose,
            msg: "Hello",
            thread: "main",
            file: "/path/to/ViewController.swift",
            function: "testFunction()",
            line: 50,
            context: nil
        )
        XCTAssertEqual(str, "VERBOSE: Hello")

        // context in the middle
        let obj5 = BaseDestination()
        format = "$L: [$X] $M"
        str = obj5.formatMessage(
            format,
            level: .verbose,
            msg: "Hello",
            thread: "main",
            file: "/path/to/ViewController.swift",
            function: "testFunction()",
            line: 50,
            context: "Context!"
        )
        XCTAssertEqual(str, "VERBOSE: [Context!] Hello")
        // no context
        str = obj5.formatMessage(
            format,
            level: .verbose,
            msg: "Hello",
            thread: "main",
            file: "/path/to/ViewController.swift",
            function: "testFunction()",
            line: 50
        )
        XCTAssertEqual(str, "VERBOSE: [] Hello")

        // misc. paddings
        let obj6 = BaseDestination()
        format = "[$-8L]"
        str = obj6.formatMessage(
            format,
            level: .debug,
            msg: "Hello",
            thread: "main",
            file: "/path/to/ViewController.swift",
            function: "testFunction()",
            line: 50
        )
        XCTAssertEqual(str, "[DEBUG   ]")
        format = "$-8L"
        str = obj6.formatMessage(
            format,
            level: .debug,
            msg: "Hello",
            thread: "main",
            file: "/path/to/ViewController.swift",
            function: "testFunction()",
            line: 50
        )
        XCTAssertEqual(str, "DEBUG")
        format = "$8L"
        str = obj6.formatMessage(
            format,
            level: .debug,
            msg: "Hello",
            thread: "main",
            file: "/path/to/ViewController.swift",
            function: "testFunction()",
            line: 50
        )
        XCTAssertEqual(str, "   DEBUG")
        format = "$-8L:_$10X___$M"
        str = obj6.formatMessage(
            format,
            level: .debug,
            msg: "Hello",
            thread: "main",
            file: "/path/to/ViewController.swift",
            function: "testFunction()",
            line: 50,
            context: "Context!"
        )

        obj6.levelColor.verbose = "?"
        obj6.escape = ">"
        obj6.reset = "<"
        XCTAssertEqual(str, "DEBUG   :_  Context!___Hello")
        format = "[$Dyyyy-MM-dd HH:mm:ss$d] |$T| $N.$F:$l $C$L$c: $M"
        str = obj6.formatMessage(
            format,
            level: .verbose,
            msg: "Hello",
            thread: "main",
            file: "/path/to/ViewController.swift",
            function: "testFunction()",
            line: 50
        )
        XCTAssertEqual(str, "[\(dateStr)] |main| ViewController.testFunction():50 >?VERBOSE<: Hello")
    }

    func testMessageToJSON() {
        let obj = BaseDestination()
        guard let str = obj.messageToJSON(
            .info,
            msg: "hello world",
            thread: "main",
            file: "/path/to/ViewController.swift",
            function: "testFunction()",
            line: 50,
            context: ["foo": "bar", "hello": 2]
        ) else {
            XCTFail("str should not be nil"); return
        }
        print(str)
        // decode JSON string into dict and compare if it is the the same
        guard let data = str.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data, options: []),
              let dict = json as? [String: Any],
              let timestamp = dict["timestamp"] as? Double,
              let level = dict["level"] as? Int,
              let message = dict["message"] as? String,
              let thread = dict["thread"] as? String,
              let file = dict["file"] as? String,
              let function = dict["function"] as? String,
              let line = dict["line"] as? Int,
              let context = dict["context"] as? [String: Any]
        else {
            XCTFail("dict and its properties should not be nil"); return
        }
        XCTAssertGreaterThanOrEqual(timestamp, Date().timeIntervalSince1970 - 10)
        XCTAssertEqual(level, SwiftyBeaver.Level.info.rawValue)
        XCTAssertEqual(message, "hello world")
        XCTAssertEqual(thread, "main")
        XCTAssertEqual(file, "/path/to/ViewController.swift")
        XCTAssertEqual(function, "testFunction()")
        XCTAssertEqual(line, 50)
        XCTAssertEqual(context["foo"] as? String, "bar")
        XCTAssertEqual(context["hello"] as? Int, 2)
    }

    func testLevelWord() {
        let obj = BaseDestination()
        var str = ""

        str = obj.levelWord(SwiftyBeaver.Level.verbose)
        XCTAssertNotNil(str, "VERBOSE")
        str = obj.levelWord(SwiftyBeaver.Level.debug)
        XCTAssertNotNil(str, "DEBUG")
        str = obj.levelWord(SwiftyBeaver.Level.info)
        XCTAssertNotNil(str, "INFO")
        str = obj.levelWord(SwiftyBeaver.Level.warning)
        XCTAssertNotNil(str, "WARNING")
        str = obj.levelWord(SwiftyBeaver.Level.error)
        XCTAssertNotNil(str, "ERROR")

        // custom level strings
        obj.levelString.verbose = "Who cares"
        obj.levelString.debug = "Look"
        obj.levelString.info = "Interesting"
        obj.levelString.warning = "Oh oh"
        obj.levelString.error = "OMG!!!"

        str = obj.levelWord(SwiftyBeaver.Level.verbose)
        XCTAssertNotNil(str, "Who cares")
        str = obj.levelWord(SwiftyBeaver.Level.debug)
        XCTAssertNotNil(str, "Look")
        str = obj.levelWord(SwiftyBeaver.Level.info)
        XCTAssertNotNil(str, "Interesting")
        str = obj.levelWord(SwiftyBeaver.Level.warning)
        XCTAssertNotNil(str, "Oh oh")
        str = obj.levelWord(SwiftyBeaver.Level.error)
        XCTAssertNotNil(str, "OMG!!!")
    }

    func testColorForLevel() {
        let obj = BaseDestination()
        var str = ""

        // empty on default
        str = obj.colorForLevel(SwiftyBeaver.Level.verbose)
        XCTAssertNotNil(str, "")
        str = obj.colorForLevel(SwiftyBeaver.Level.debug)
        XCTAssertNotNil(str, "")
        str = obj.colorForLevel(SwiftyBeaver.Level.info)
        XCTAssertNotNil(str, "")
        str = obj.colorForLevel(SwiftyBeaver.Level.warning)
        XCTAssertNotNil(str, "")
        str = obj.colorForLevel(SwiftyBeaver.Level.error)
        XCTAssertNotNil(str, "")

        // custom level color strings
        obj.levelString.verbose = "silver"
        obj.levelString.debug = "green"
        obj.levelString.info = "blue"
        obj.levelString.warning = "yellow"
        obj.levelString.error = "red"

        str = obj.colorForLevel(SwiftyBeaver.Level.verbose)
        XCTAssertNotNil(str, "silver")
        str = obj.colorForLevel(SwiftyBeaver.Level.debug)
        XCTAssertNotNil(str, "green")
        str = obj.colorForLevel(SwiftyBeaver.Level.info)
        XCTAssertNotNil(str, "blue")
        str = obj.colorForLevel(SwiftyBeaver.Level.warning)
        XCTAssertNotNil(str, "yellow")
        str = obj.colorForLevel(SwiftyBeaver.Level.error)
        XCTAssertNotNil(str, "red")
    }

    func testFileNameOfFile() {
        let obj = BaseDestination()
        var str = ""

        str = obj.fileNameOfFile("")
        XCTAssertEqual(str, "")
        str = obj.fileNameOfFile("foo.bar")
        XCTAssertEqual(str, "foo.bar")
        str = obj.fileNameOfFile("path/to/ViewController.swift")
        XCTAssertEqual(str, "ViewController.swift")
    }

    func testFileNameOfFileWithoutSuffix() {
        let obj = BaseDestination()
        var str = ""

        str = obj.fileNameWithoutSuffix("")
        XCTAssertEqual(str, "")
        str = obj.fileNameWithoutSuffix("/")
        XCTAssertEqual(str, "")
        str = obj.fileNameWithoutSuffix("foo")
        XCTAssertEqual(str, "foo")
        str = obj.fileNameWithoutSuffix("foo.bar")
        XCTAssertEqual(str, "foo")
        str = obj.fileNameWithoutSuffix("path/to/ViewController.swift")
        XCTAssertEqual(str, "ViewController")
    }

    func testFormatDate() {
        // empty format
        var str = BaseDestination().formatDate("")
        XCTAssertEqual(str, "")
        // no time format
        str = BaseDestination().formatDate("--")
        XCTAssertGreaterThanOrEqual(str, "--")
        // HH:mm:ss
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let dateStr = formatter.string(from: Date())
        str = BaseDestination().formatDate(formatter.dateFormat)
        XCTAssertEqual(str, dateStr)
        // test UTC
        let utcFormatter = DateFormatter()
        utcFormatter.timeZone = TimeZone(abbreviation: "UTC")
        utcFormatter.dateFormat = "HH:mm:ss"
        let utcDateStr = utcFormatter.string(from: Date())
        str = BaseDestination().formatDate(utcFormatter.dateFormat, timeZone: "UTC")
        XCTAssertEqual(str, utcDateStr)
    }

    ////////////////////////////////

    // MARK: Filters

    ////////////////////////////////

    func test_init_noMinLevelSet() {
        let destination = BaseDestination()
        XCTAssertTrue(destination.shouldLevelBeLogged(SwiftyBeaver.Level.verbose, path: "", function: ""))
        XCTAssertTrue(destination.shouldLevelBeLogged(SwiftyBeaver.Level.debug, path: "", function: ""))
        XCTAssertTrue(destination.shouldLevelBeLogged(SwiftyBeaver.Level.info, path: "", function: ""))
        XCTAssertTrue(destination.shouldLevelBeLogged(SwiftyBeaver.Level.warning, path: "", function: ""))
        XCTAssertTrue(destination.shouldLevelBeLogged(SwiftyBeaver.Level.error, path: "", function: ""))
    }

    func test_init_minLevelSet() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        XCTAssertFalse(destination.shouldLevelBeLogged(SwiftyBeaver.Level.verbose, path: "", function: ""))
        XCTAssertFalse(destination.shouldLevelBeLogged(SwiftyBeaver.Level.debug, path: "", function: ""))
        XCTAssertTrue(destination.shouldLevelBeLogged(SwiftyBeaver.Level.info, path: "", function: ""))
        XCTAssertTrue(destination.shouldLevelBeLogged(SwiftyBeaver.Level.warning, path: "", function: ""))
        XCTAssertTrue(destination.shouldLevelBeLogged(SwiftyBeaver.Level.error, path: "", function: ""))
    }

    func test_shouldLevelBeLogged_hasMinLevel_True() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.verbose
        destination.addFilter(Filters.path.equals("/world/beaver.swift", caseSensitive: true, required: true))
        XCTAssertTrue(destination.shouldLevelBeLogged(
            SwiftyBeaver.Level.warning,
            path: "/world/beaver.swift",
            function: "initialize"
        ))
    }

    func test_shouldLevelBeLogged_hasMinLevel_False() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        destination.addFilter(Filters.path.equals("/world/beaver.swift", caseSensitive: true, required: true))
        XCTAssertTrue(destination.shouldLevelBeLogged(
            SwiftyBeaver.Level.warning,
            path: "/world/beaver.swift",
            function: "initialize"
        ))
    }

    func test_shouldLevelBeLogged_hasMinLevelAndMatchingLevelAndEqualPath_True() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.verbose
        let filter = Filters.path.equals("/world/beaver.swift", caseSensitive: true, required: true, minLevel: .debug)
        destination.addFilter(filter)
        XCTAssertTrue(destination.shouldLevelBeLogged(
            .debug,
            path: "/world/beaver.swift",
            function: "initialize"
        ))
    }

    func test_shouldLevelBeLogged_hasMinLevelAndNoMatchingLevelButEqualPath_False() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        let filter = Filters.path.equals("/world/beaver.swift", caseSensitive: true, required: true, minLevel: .debug)
        destination.addFilter(filter)
        XCTAssertTrue(destination.shouldLevelBeLogged(
            .debug,
            path: "/world/beaver.swift",
            function: "initialize"
        ))
    }

    func test_shouldLevelBeLogged_hasMinLevelAndOneEqualsPathFilterAndDoesNotPass_False() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        destination.addFilter(Filters.path.equals("/world/beaver.swift", caseSensitive: true, required: true))
        XCTAssertFalse(destination.shouldLevelBeLogged(
            .debug,
            path: "/hello/foo.swift",
            function: "initialize"
        ))
    }

    func test_shouldLevelBeLogged_hasMinLevelAndOneRequiredMessageFilterAndDoesNotPass_False() {
        let destination = BaseDestination()
        destination.minLevel = .error
        destination.addFilter(Filters.message.contains(
            "Required",
            caseSensitive: false,
            required: true,
            minLevel: .info
        ))
        XCTAssertFalse(destination.shouldLevelBeLogged(
            .info,
            path: "/hello/foo.swift",
            function: "initialize",
            message: "Test"
        ))
    }

    func test_shouldLevelBeLogged_hasMinLevelAndOneRequiredMessageFilterAndDoesPass_True() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.error
        destination.addFilter(Filters.message.contains(
            "Required",
            caseSensitive: false,
            required: true,
            minLevel: .info
        ))
        XCTAssertTrue(destination.shouldLevelBeLogged(
            .info,
            path: "/hello/foo.swift",
            function: "initialize",
            message: "Required Test"
        ))
    }

    func test_shouldLevelBeLogged_hasLevelFilterAndTwoRequiredPathFiltersAndPasses_True() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        destination.addFilter(Filters.path.startsWith("/world", caseSensitive: true, required: true))
        destination.addFilter(Filters.path.endsWith("beaver.swift", caseSensitive: true, required: true))
        XCTAssertTrue(destination.shouldLevelBeLogged(
            SwiftyBeaver.Level.warning,
            path: "/world/beaver.swift",
            function: "initialize"
        ))
    }

    func test_shouldLevelBeLogged_hasLevelFilterAndTwoRequiredPathFiltersAndDoesNotPass_False() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        destination.addFilter(Filters.path.startsWith("/world", caseSensitive: true, required: true))
        destination.addFilter(Filters.path.endsWith("foo.swift", caseSensitive: true, required: true))
        XCTAssertFalse(destination.shouldLevelBeLogged(
            .debug,
            path: "/hello/foo.swift",
            function: "initialize"
        ))
    }

    func test_shouldLevelBeLogged_hasLevelFilterARequiredPathFilterAndTwoRequiredMessageFiltersAndPasses_True() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        destination.addFilter(Filters.path.startsWith("/world", caseSensitive: true, required: true))
        destination.addFilter(Filters.message.startsWith("SQL:", caseSensitive: true, required: true))
        destination.addFilter(Filters.message.contains("insert", caseSensitive: false, required: true))
        XCTAssertTrue(destination.shouldLevelBeLogged(
            SwiftyBeaver.Level.warning,
            path: "/world/beaver.swift",
            function: "executeSQLStatement",
            message: "SQL: INSERT INTO table (c1, c2) VALUES (1, 2)"
        ))
    }

    func test_shouldLevelBeLogged_hasLevelFilterARequiredPathFilterAndTwoRequiredMessageFiltersAndDoesNotPass_False() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        destination.addFilter(Filters.path.startsWith("/world", caseSensitive: true, required: true))
        destination.addFilter(Filters.message.startsWith("SQL:", caseSensitive: true, required: true))
        destination.addFilter(Filters.message.contains("insert", caseSensitive: false, required: true))
        XCTAssertFalse(destination.shouldLevelBeLogged(
            .debug,
            path: "/world/beaver.swift",
            function: "executeSQLStatement",
            message: "SQL: DELETE FROM table WHERE c1 = 1"
        ))
    }

    func test_shouldLevelBeLogged_hasLevelFilterCombinationOfAllOtherFiltersAndPasses_True() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        destination.addFilter(Filters.path.startsWith("/world", caseSensitive: true, required: true))
        destination.addFilter(Filters.path.endsWith("/beaver.swift", caseSensitive: true, required: true))
        destination.addFilter(Filters.function.equals("executeSQLStatement", required: true))
        destination.addFilter(Filters.message.startsWith("SQL:", caseSensitive: true, required: true))
        destination.addFilter(Filters.message.contains("insert", "update", "delete", required: true))
        XCTAssertTrue(destination.shouldLevelBeLogged(
            SwiftyBeaver.Level.warning,
            path: "/world/beaver.swift",
            function: "executeSQLStatement",
            message: "SQL: INSERT INTO table (c1, c2) VALUES (1, 2)"
        ))
    }

    func test_shouldLevelBeLogged_hasLevelFilterCombinationOfAllOtherFiltersAndDoesNotPass_False() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        destination.addFilter(Filters.path.startsWith("/world", caseSensitive: true, required: true))
        destination.addFilter(Filters.path.endsWith("/beaver.swift", caseSensitive: true, required: true))
        destination.addFilter(Filters.function.equals("executeSQLStatement", required: true))
        destination.addFilter(Filters.message.startsWith("SQL:", caseSensitive: true, required: true))
        destination.addFilter(Filters.message.contains("insert", "update", "delete", required: true))
        XCTAssertFalse(destination.shouldLevelBeLogged(
            .debug,
            path: "/world/beaver.swift",
            function: "executeSQLStatement",
            message: "SQL: CREATE TABLE sample (c1 INTEGER, c2 VARCHAR)"
        ))
    }

    func test_shouldLevelBeLogged_hasLevelFilterCombinationOfOtherFiltersIncludingNonRequiredAndPasses_True() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        destination.addFilter(Filters.path.startsWith("/world", caseSensitive: true, required: true))
        destination.addFilter(Filters.path.endsWith("/beaver.swift", caseSensitive: true, required: true))
        destination.addFilter(Filters.function.equals("executeSQLStatement", required: true))
        destination.addFilter(Filters.message.startsWith("SQL:", caseSensitive: true, required: true))
        destination.addFilter(Filters.message.contains("insert"))
        destination.addFilter(Filters.message.contains("update"))
        destination.addFilter(Filters.message.contains("delete"))
        XCTAssertTrue(destination.shouldLevelBeLogged(
            SwiftyBeaver.Level.warning,
            path: "/world/beaver.swift",
            function: "executeSQLStatement",
            message: "SQL: INSERT INTO table (c1, c2) VALUES (1, 2)"
        ))
    }

    func test_shouldLevelBeLogged_hasLevelFilterCombinationOfOtherFiltersIncludingNonRequired_True() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        destination.addFilter(Filters.path.startsWith("/world", caseSensitive: true, required: true))
        destination.addFilter(Filters.path.endsWith("/beaver.swift", caseSensitive: true, required: true))
        destination.addFilter(Filters.function.equals("executeSQLStatement", required: true))
        destination.addFilter(Filters.message.startsWith("SQL:", caseSensitive: true, required: true))
        destination.addFilter(Filters.message.contains("insert", caseSensitive: true))
        destination.addFilter(Filters.message.contains("update"))
        destination.addFilter(Filters.message.contains("delete"))
        XCTAssertTrue(destination.shouldLevelBeLogged(
            SwiftyBeaver.Level.warning,
            path: "/world/beaver.swift",
            function: "executeSQLStatement",
            message: "SQL: INSERT INTO table (c1, c2) VALUES (1, 2)"
        ))
    }

    func test_shouldLevelBeLogged_hasLevelFilterCombinationOfOtherFiltersIncludingNonRequired_False() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        destination.addFilter(Filters.path.startsWith("/world", caseSensitive: true, required: true))
        destination.addFilter(Filters.path.endsWith("/beaver.swift", caseSensitive: true, required: true))
        destination.addFilter(Filters.function.equals("executeSQLStatement", required: true))
        destination.addFilter(Filters.message.startsWith("SQL:", caseSensitive: true, required: true))
        destination.addFilter(Filters.message.contains("rename", caseSensitive: true, required: true))
        destination.addFilter(Filters.message.contains("update"))
        destination.addFilter(Filters.message.contains("delete"))
        XCTAssertFalse(destination.shouldLevelBeLogged(
            .debug,
            path: "/world/beaver.swift",
            function: "executeSQLStatement",
            message: "SQL: INSERT INTO table (c1, c2) VALUES (1, 2)"
        ))
    }

    func test_shouldLevelBeLogged_hasMatchingNonRequiredFilter_True() {
        let destination = BaseDestination()
        destination.minLevel = .info
        destination.addFilter(Filters.path.contains("/ViewController"))
        XCTAssertTrue(destination.shouldLevelBeLogged(
            .debug,
            path: "/world/ViewController.swift",
            function: "myFunc",
            message: "Hello World"
        ))
    }

    func test_shouldLevelBeLogged_hasNoMatchingNonRequiredFilter_False() {
        let destination = BaseDestination()
        destination.minLevel = .info
        destination.addFilter(Filters.path.contains("/ViewController"))
        XCTAssertFalse(destination.shouldLevelBeLogged(
            .debug,
            path: "/world/beaver.swift",
            function: "myFunc",
            message: "Hello World"
        ))
    }

    func test_shouldLevelBeLogged_hasNoMatchingNonRequiredFilterAndMinLevel_True() {
        let destination = BaseDestination()
        destination.minLevel = .debug
        destination.addFilter(Filters.path.contains("/ViewController", minLevel: .info))
        XCTAssertTrue(destination.shouldLevelBeLogged(
            .debug,
            path: "/world/beaver.swift",
            function: "myFunc",
            message: "Hello World"
        ))
    }

    func test_shouldLevelBeLogged_hasNoMatchingNonRequiredFilterAndMinLevel_False() {
        let destination = BaseDestination()
        destination.minLevel = .verbose
        destination.addFilter(Filters.path.contains("/ViewController", minLevel: .debug))
        XCTAssertFalse(destination.shouldLevelBeLogged(
            .verbose,
            path: "/world/ViewController.swift",
            function: "myFunc",
            message: "Hello World"
        ))
    }

    func test_shouldLevelBeLogged_hasMultipleNonMatchingNonRequiredFilterAndMinLevel_True() {
        let destination = BaseDestination()
        destination.minLevel = .debug
        destination.addFilter(Filters.path.contains("/ViewController", minLevel: .info))
        destination.addFilter(Filters.path.contains("/test", minLevel: .debug))
        XCTAssertTrue(destination.shouldLevelBeLogged(
            .debug,
            path: "/world/beaver.swift",
            function: "myFunc",
            message: "Hello World"
        ))
    }

    func test_shouldLevelBeLogged_hasMultipleNonMatchingNonRequiredFilterAndMinLevel_False() {
        let destination = BaseDestination()
        destination.minLevel = .verbose
        destination.addFilter(Filters.path.contains("/ViewController", minLevel: .debug))
        destination.addFilter(Filters.path.contains("/test", minLevel: .verbose))
        XCTAssertFalse(destination.shouldLevelBeLogged(
            .verbose,
            path: "/world/ViewController.swift",
            function: "myFunc",
            message: "Hello World"
        ))
    }

    func test_shouldLevelBeLogged_noFilters_True() {
        // everything is logged on default
        let destination = BaseDestination()
        XCTAssertTrue(destination.shouldLevelBeLogged(
            .debug,
            path: "/world/ViewController.swift",
            function: "myFunc",
            message: "Hello World"
        ))
    }

    func test_shouldLevelBeLogged_multipleNonRequiredFiltersAndGlobal_True() {
        // everything is logged on default
        let destination = BaseDestination()
        destination.minLevel = .info

        destination.addFilter(Filters.path.contains("/ViewController", minLevel: .debug))
        destination.addFilter(Filters.function.contains("Func", minLevel: .debug))
        destination.addFilter(Filters.message.contains("World", minLevel: .debug))
        // destination.debugPrint = true

        // covered by filters
        XCTAssertTrue(destination.shouldLevelBeLogged(
            .debug,
            path: "/world/ViewController.swift",
            function: "myFunc",
            message: "Hello World"
        ))

        // not in filter and below global minLevel
        XCTAssertFalse(destination.shouldLevelBeLogged(
            .debug,
            path: "hello.swift",
            function: "foo",
            message: "bar"
        ))
    }

    func test_shouldLevelBeLogged_excludeFilter_True() {
        // everything is logged on default
        let destination = BaseDestination()
        destination.minLevel = .error

        destination.addFilter(Filters.path.contains("/ViewController", minLevel: .debug))
        destination.addFilter(Filters.function.excludes("myFunc", minLevel: .debug))
        // destination.debugPrint = true

        // excluded
        XCTAssertFalse(destination.shouldLevelBeLogged(
            .debug,
            path: "/world/ViewController.swift",
            function: "myFunc",
            message: "Hello World"
        ))

        // excluded
        XCTAssertFalse(destination.shouldLevelBeLogged(
            .error,
            path: "/world/ViewController.swift",
            function: "myFunc",
            message: "Hello World"
        ))

        // not excluded, but below minLevel
        XCTAssertFalse(destination.shouldLevelBeLogged(
            .debug,
            path: "/world/OtherViewController.swift",
            function: "otherFunc",
            message: "Hello World"
        ))

        // not excluded, above minLevel, no matching filter
        XCTAssertTrue(destination.shouldLevelBeLogged(
            .error,
            path: "/world/OtherViewController.swift",
            function: "otherFunc",
            message: "Hello World"
        ))

        // not excluded, above minLevel, matching path filter
        XCTAssertTrue(destination.shouldLevelBeLogged(
            .error,
            path: "/ViewController.swift",
            function: "otherFunc",
            message: "Hello World"
        ))
    }

    /// turns dict into JSON-encoded string
    func jsonStringFromDict(_ dict: [String: Any]) -> String? {
        var jsonString: String?

        // try to create JSON string
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
            jsonString = String(data: jsonData, encoding: .utf8)
        } catch {
            print("SwiftyBeaver could not create JSON from dict.")
        }
        return jsonString
    }
}
