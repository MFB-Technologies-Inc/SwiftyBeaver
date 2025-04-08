// BaseDestinationTests.swift
// SwiftyBeaver
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

import Foundation
@_spi(Testable) import SwiftyBeaver
import Testing

@Suite
struct BaseDestinationTests {
    @Test
    func initialize() {
        let obj = BaseDestination()
        #expect(obj.queue != nil)
    }

    ////////////////////////////////

    // MARK: Format

    ////////////////////////////////

    @Test
    func formatMessage() {
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
        #expect(str == "")

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
        #expect(str == "Hello")

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
        #expect(str == "Linda")
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
        #expect(str == "VERBOSEinda Hello")

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
        #expect(str == "")

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
        #expect(str == "|main| VERBOSE: Hello")

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
        #expect(
            str == "[\(dateStr)] |main| ViewController.testFunction():50 >?VERBOSE<: Hello"
        )

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
        #expect(str == "\(utcDateStr)")

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
        #expect(str == "VERBOSE: Hello Context!")

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
        #expect(str == "VERBOSE: Hello 123")

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
        #expect(str == "VERBOSE: Hello [1, \"a\", 2]")

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
        #expect(str == "VERBOSE: Hello")

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
        #expect(str == "VERBOSE: [Context!] Hello")
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
        #expect(str == "VERBOSE: [] Hello")

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
        #expect(str == "[DEBUG   ]")
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
        #expect(str == "DEBUG")
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
        #expect(str == "   DEBUG")
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
        #expect(str == "DEBUG   :_  Context!___Hello")
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
        #expect(
            str == "[\(dateStr)] |main| ViewController.testFunction():50 >?VERBOSE<: Hello"
        )
    }

    @Test
    func messageToJSON() {
        let obj = BaseDestination()
        guard
            let str = obj.messageToJSON(
                .info,
                msg: "hello world",
                thread: "main",
                file: "/path/to/ViewController.swift",
                function: "testFunction()",
                line: 50,
                context: ["foo": "bar", "hello": 2]
            )
        else {
            Issue.record("str should not be nil")
            return
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
            Issue.record("dict and its properties should not be nil")
            return
        }
        #expect(timestamp >= Date().timeIntervalSince1970 - 10)
        #expect(level == SwiftyBeaver.Level.info.rawValue)
        #expect(message == "hello world")
        #expect(thread == "main")
        #expect(file == "/path/to/ViewController.swift")
        #expect(function == "testFunction()")
        #expect(line == 50)
        #expect(context["foo"] as? String == "bar")
        #expect(context["hello"] as? Int == 2)
    }

    @Test
    func levelWord() {
        let obj = BaseDestination()
        var str = ""

        str = obj.levelWord(SwiftyBeaver.Level.verbose)
        #expect(str == "VERBOSE")
        str = obj.levelWord(SwiftyBeaver.Level.debug)
        #expect(str == "DEBUG")
        str = obj.levelWord(SwiftyBeaver.Level.info)
        #expect(str == "INFO")
        str = obj.levelWord(SwiftyBeaver.Level.warning)
        #expect(str == "WARNING")
        str = obj.levelWord(SwiftyBeaver.Level.error)
        #expect(str == "ERROR")

        // custom level strings
        obj.levelString.verbose = "Who cares"
        obj.levelString.debug = "Look"
        obj.levelString.info = "Interesting"
        obj.levelString.warning = "Oh oh"
        obj.levelString.error = "OMG!!!"

        str = obj.levelWord(SwiftyBeaver.Level.verbose)
        #expect(str == "Who cares")
        str = obj.levelWord(SwiftyBeaver.Level.debug)
        #expect(str == "Look")
        str = obj.levelWord(SwiftyBeaver.Level.info)
        #expect(str == "Interesting")
        str = obj.levelWord(SwiftyBeaver.Level.warning)
        #expect(str == "Oh oh")
        str = obj.levelWord(SwiftyBeaver.Level.error)
        #expect(str == "OMG!!!")
    }

    @Test
    func colorForLevel() {
        let obj = BaseDestination()
        var str = ""

        // empty on default
        str = obj.colorForLevel(SwiftyBeaver.Level.verbose)
        #expect(str == "")
        str = obj.colorForLevel(SwiftyBeaver.Level.debug)
        #expect(str == "")
        str = obj.colorForLevel(SwiftyBeaver.Level.info)
        #expect(str == "")
        str = obj.colorForLevel(SwiftyBeaver.Level.warning)
        #expect(str == "")
        str = obj.colorForLevel(SwiftyBeaver.Level.error)
        #expect(str == "")

        // custom level color strings
        obj.levelColor.verbose = "silver"
        obj.levelColor.debug = "green"
        obj.levelColor.info = "blue"
        obj.levelColor.warning = "yellow"
        obj.levelColor.error = "red"

        str = obj.colorForLevel(SwiftyBeaver.Level.verbose)
        #expect(str == "silver")
        str = obj.colorForLevel(SwiftyBeaver.Level.debug)
        #expect(str == "green")
        str = obj.colorForLevel(SwiftyBeaver.Level.info)
        #expect(str == "blue")
        str = obj.colorForLevel(SwiftyBeaver.Level.warning)
        #expect(str == "yellow")
        str = obj.colorForLevel(SwiftyBeaver.Level.error)
        #expect(str == "red")
    }

    @Test
    func fileNameOfFile() {
        let obj = BaseDestination()
        var str = ""

        str = obj.fileNameOfFile("")
        #expect(str == "")
        str = obj.fileNameOfFile("foo.bar")
        #expect(str == "foo.bar")
        str = obj.fileNameOfFile("path/to/ViewController.swift")
        #expect(str == "ViewController.swift")
    }

    @Test
    func fileNameOfFileWithoutSuffix() {
        let obj = BaseDestination()
        var str = ""

        str = obj.fileNameWithoutSuffix("")
        #expect(str == "")
        str = obj.fileNameWithoutSuffix("/")
        #expect(str == "")
        str = obj.fileNameWithoutSuffix("foo")
        #expect(str == "foo")
        str = obj.fileNameWithoutSuffix("foo.bar")
        #expect(str == "foo")
        str = obj.fileNameWithoutSuffix("path/to/ViewController.swift")
        #expect(str == "ViewController")
    }

    @Test
    func formatDate() {
        // empty format
        var str = BaseDestination().formatDate("")
        #expect(str == "")
        // no time format
        str = BaseDestination().formatDate("--")
        #expect(str >= "--")
        // HH:mm:ss
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let dateStr = formatter.string(from: Date())
        str = BaseDestination().formatDate(formatter.dateFormat)
        #expect(str == dateStr)
        // test UTC
        let utcFormatter = DateFormatter()
        utcFormatter.timeZone = TimeZone(abbreviation: "UTC")
        utcFormatter.dateFormat = "HH:mm:ss"
        let utcDateStr = utcFormatter.string(from: Date())
        str = BaseDestination().formatDate(utcFormatter.dateFormat, timeZone: "UTC")
        #expect(str == utcDateStr)
    }

    ////////////////////////////////

    // MARK: Filters

    ////////////////////////////////

    @Test
    func init_noMinLevelSet() {
        let destination = BaseDestination()
        #expect(
            destination.shouldLevelBeLogged(SwiftyBeaver.Level.verbose, path: "", function: "")
        )
        #expect(
            destination.shouldLevelBeLogged(SwiftyBeaver.Level.debug, path: "", function: "")
        )
        #expect(
            destination.shouldLevelBeLogged(SwiftyBeaver.Level.info, path: "", function: "")
        )
        #expect(
            destination.shouldLevelBeLogged(SwiftyBeaver.Level.warning, path: "", function: "")
        )
        #expect(
            destination.shouldLevelBeLogged(SwiftyBeaver.Level.error, path: "", function: "")
        )
    }

    @Test
    func init_minLevelSet() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        #expect(
            !destination.shouldLevelBeLogged(SwiftyBeaver.Level.verbose, path: "", function: "")
        )
        #expect(
            !destination.shouldLevelBeLogged(SwiftyBeaver.Level.debug, path: "", function: "")
        )
        #expect(
            destination.shouldLevelBeLogged(SwiftyBeaver.Level.info, path: "", function: "")
        )
        #expect(
            destination.shouldLevelBeLogged(SwiftyBeaver.Level.warning, path: "", function: "")
        )
        #expect(
            destination.shouldLevelBeLogged(SwiftyBeaver.Level.error, path: "", function: "")
        )
    }

    @Test
    func shouldLevelBeLogged_hasMinLevel_True() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.verbose
        destination.addFilter(
            Filters.path.equals("/world/beaver.swift", caseSensitive: true, required: true)
        )
        #expect(
            destination.shouldLevelBeLogged(
                SwiftyBeaver.Level.warning,
                path: "/world/beaver.swift",
                function: "initialize"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_hasMinLevel_False() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        destination.addFilter(
            Filters.path.equals("/world/beaver.swift", caseSensitive: true, required: true)
        )
        #expect(
            destination.shouldLevelBeLogged(
                SwiftyBeaver.Level.warning,
                path: "/world/beaver.swift",
                function: "initialize"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_hasMinLevelAndMatchingLevelAndEqualPath_True() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.verbose
        let filter = Filters.path.equals(
            "/world/beaver.swift", caseSensitive: true, required: true, minLevel: .debug
        )
        destination.addFilter(filter)
        #expect(
            destination.shouldLevelBeLogged(
                .debug,
                path: "/world/beaver.swift",
                function: "initialize"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_hasMinLevelAndNoMatchingLevelButEqualPath_False() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        let filter = Filters.path.equals(
            "/world/beaver.swift", caseSensitive: true, required: true, minLevel: .debug
        )
        destination.addFilter(filter)
        #expect(
            destination.shouldLevelBeLogged(
                .debug,
                path: "/world/beaver.swift",
                function: "initialize"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_hasMinLevelAndOneEqualsPathFilterAndDoesNotPass_False() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        destination.addFilter(
            Filters.path.equals("/world/beaver.swift", caseSensitive: true, required: true)
        )
        #expect(
            !destination.shouldLevelBeLogged(
                .debug,
                path: "/hello/foo.swift",
                function: "initialize"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_hasMinLevelAndOneRequiredMessageFilterAndDoesNotPass_False() {
        let destination = BaseDestination()
        destination.minLevel = .error
        destination.addFilter(
            Filters.message.contains(
                "Required",
                caseSensitive: false,
                required: true,
                minLevel: .info
            )
        )
        #expect(
            !destination.shouldLevelBeLogged(
                .info,
                path: "/hello/foo.swift",
                function: "initialize",
                message: "Test"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_hasMinLevelAndOneRequiredMessageFilterAndDoesPass_True() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.error
        destination.addFilter(
            Filters.message.contains(
                "Required",
                caseSensitive: false,
                required: true,
                minLevel: .info
            )
        )
        #expect(
            destination.shouldLevelBeLogged(
                .info,
                path: "/hello/foo.swift",
                function: "initialize",
                message: "Required Test"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_hasLevelFilterAndTwoRequiredPathFiltersAndPasses_True() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        destination.addFilter(
            Filters.path.startsWith("/world", caseSensitive: true, required: true)
        )
        destination.addFilter(
            Filters.path.endsWith("beaver.swift", caseSensitive: true, required: true)
        )
        #expect(
            destination.shouldLevelBeLogged(
                SwiftyBeaver.Level.warning,
                path: "/world/beaver.swift",
                function: "initialize"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_hasLevelFilterAndTwoRequiredPathFiltersAndDoesNotPass_False() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        destination.addFilter(
            Filters.path.startsWith("/world", caseSensitive: true, required: true)
        )
        destination.addFilter(
            Filters.path.endsWith("foo.swift", caseSensitive: true, required: true)
        )
        #expect(
            !destination.shouldLevelBeLogged(
                .debug,
                path: "/hello/foo.swift",
                function: "initialize"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_hasLevelFilterARequiredPathFilterAndTwoRequiredMessageFiltersAndPasses_True() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        destination.addFilter(
            Filters.path.startsWith("/world", caseSensitive: true, required: true)
        )
        destination.addFilter(
            Filters.message.startsWith("SQL:", caseSensitive: true, required: true)
        )
        destination.addFilter(
            Filters.message.contains("insert", caseSensitive: false, required: true)
        )
        #expect(
            destination.shouldLevelBeLogged(
                SwiftyBeaver.Level.warning,
                path: "/world/beaver.swift",
                function: "executeSQLStatement",
                message: "SQL: INSERT INTO table (c1, c2) VALUES (1, 2)"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_hasLevelFilterARequiredPathFilterAndTwoRequiredMessageFiltersAndDoesNotPass_False() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        destination.addFilter(
            Filters.path.startsWith("/world", caseSensitive: true, required: true)
        )
        destination.addFilter(
            Filters.message.startsWith("SQL:", caseSensitive: true, required: true)
        )
        destination.addFilter(
            Filters.message.contains("insert", caseSensitive: false, required: true)
        )
        #expect(
            !destination.shouldLevelBeLogged(
                .debug,
                path: "/world/beaver.swift",
                function: "executeSQLStatement",
                message: "SQL: DELETE FROM table WHERE c1 = 1"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_hasLevelFilterCombinationOfAllOtherFiltersAndPasses_True() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        destination.addFilter(
            Filters.path.startsWith("/world", caseSensitive: true, required: true)
        )
        destination.addFilter(
            Filters.path.endsWith("/beaver.swift", caseSensitive: true, required: true)
        )
        destination.addFilter(Filters.function.equals("executeSQLStatement", required: true))
        destination.addFilter(
            Filters.message.startsWith("SQL:", caseSensitive: true, required: true)
        )
        destination.addFilter(
            Filters.message.contains("insert", "update", "delete", required: true)
        )
        #expect(
            destination.shouldLevelBeLogged(
                SwiftyBeaver.Level.warning,
                path: "/world/beaver.swift",
                function: "executeSQLStatement",
                message: "SQL: INSERT INTO table (c1, c2) VALUES (1, 2)"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_hasLevelFilterCombinationOfAllOtherFiltersAndDoesNotPass_False() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        destination.addFilter(
            Filters.path.startsWith("/world", caseSensitive: true, required: true)
        )
        destination.addFilter(
            Filters.path.endsWith("/beaver.swift", caseSensitive: true, required: true)
        )
        destination.addFilter(Filters.function.equals("executeSQLStatement", required: true))
        destination.addFilter(
            Filters.message.startsWith("SQL:", caseSensitive: true, required: true)
        )
        destination.addFilter(
            Filters.message.contains("insert", "update", "delete", required: true)
        )
        #expect(
            !destination.shouldLevelBeLogged(
                .debug,
                path: "/world/beaver.swift",
                function: "executeSQLStatement",
                message: "SQL: CREATE TABLE sample (c1 INTEGER, c2 VARCHAR)"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_hasLevelFilterCombinationOfOtherFiltersIncludingNonRequiredAndPasses_True() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        destination.addFilter(
            Filters.path.startsWith("/world", caseSensitive: true, required: true)
        )
        destination.addFilter(
            Filters.path.endsWith("/beaver.swift", caseSensitive: true, required: true)
        )
        destination.addFilter(Filters.function.equals("executeSQLStatement", required: true))
        destination.addFilter(
            Filters.message.startsWith("SQL:", caseSensitive: true, required: true)
        )
        destination.addFilter(Filters.message.contains("insert"))
        destination.addFilter(Filters.message.contains("update"))
        destination.addFilter(Filters.message.contains("delete"))
        #expect(
            destination.shouldLevelBeLogged(
                SwiftyBeaver.Level.warning,
                path: "/world/beaver.swift",
                function: "executeSQLStatement",
                message: "SQL: INSERT INTO table (c1, c2) VALUES (1, 2)"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_hasLevelFilterCombinationOfOtherFiltersIncludingNonRequired_True() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        destination.addFilter(
            Filters.path.startsWith("/world", caseSensitive: true, required: true)
        )
        destination.addFilter(
            Filters.path.endsWith("/beaver.swift", caseSensitive: true, required: true)
        )
        destination.addFilter(Filters.function.equals("executeSQLStatement", required: true))
        destination.addFilter(
            Filters.message.startsWith("SQL:", caseSensitive: true, required: true)
        )
        destination.addFilter(Filters.message.contains("insert", caseSensitive: true))
        destination.addFilter(Filters.message.contains("update"))
        destination.addFilter(Filters.message.contains("delete"))
        #expect(
            destination.shouldLevelBeLogged(
                SwiftyBeaver.Level.warning,
                path: "/world/beaver.swift",
                function: "executeSQLStatement",
                message: "SQL: INSERT INTO table (c1, c2) VALUES (1, 2)"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_hasLevelFilterCombinationOfOtherFiltersIncludingNonRequired_False() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.info
        destination.addFilter(
            Filters.path.startsWith("/world", caseSensitive: true, required: true)
        )
        destination.addFilter(
            Filters.path.endsWith("/beaver.swift", caseSensitive: true, required: true)
        )
        destination.addFilter(Filters.function.equals("executeSQLStatement", required: true))
        destination.addFilter(
            Filters.message.startsWith("SQL:", caseSensitive: true, required: true)
        )
        destination.addFilter(
            Filters.message.contains("rename", caseSensitive: true, required: true)
        )
        destination.addFilter(Filters.message.contains("update"))
        destination.addFilter(Filters.message.contains("delete"))
        #expect(
            !destination.shouldLevelBeLogged(
                .debug,
                path: "/world/beaver.swift",
                function: "executeSQLStatement",
                message: "SQL: INSERT INTO table (c1, c2) VALUES (1, 2)"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_hasMatchingNonRequiredFilter_True() {
        let destination = BaseDestination()
        destination.minLevel = .info
        destination.addFilter(Filters.path.contains("/ViewController"))
        #expect(
            destination.shouldLevelBeLogged(
                .debug,
                path: "/world/ViewController.swift",
                function: "myFunc",
                message: "Hello World"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_hasNoMatchingNonRequiredFilter_False() {
        let destination = BaseDestination()
        destination.minLevel = .info
        destination.addFilter(Filters.path.contains("/ViewController"))
        #expect(
            !destination.shouldLevelBeLogged(
                .debug,
                path: "/world/beaver.swift",
                function: "myFunc",
                message: "Hello World"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_hasNoMatchingNonRequiredFilterAndMinLevel_True() {
        let destination = BaseDestination()
        destination.minLevel = .debug
        destination.addFilter(Filters.path.contains("/ViewController", minLevel: .info))
        #expect(
            destination.shouldLevelBeLogged(
                .debug,
                path: "/world/beaver.swift",
                function: "myFunc",
                message: "Hello World"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_hasNoMatchingNonRequiredFilterAndMinLevel_False() {
        let destination = BaseDestination()
        destination.minLevel = .verbose
        destination.addFilter(Filters.path.contains("/ViewController", minLevel: .debug))
        #expect(
            !destination.shouldLevelBeLogged(
                .verbose,
                path: "/world/ViewController.swift",
                function: "myFunc",
                message: "Hello World"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_hasMultipleNonMatchingNonRequiredFilterAndMinLevel_True() {
        let destination = BaseDestination()
        destination.minLevel = .debug
        destination.addFilter(Filters.path.contains("/ViewController", minLevel: .info))
        destination.addFilter(Filters.path.contains("/test", minLevel: .debug))
        #expect(
            destination.shouldLevelBeLogged(
                .debug,
                path: "/world/beaver.swift",
                function: "myFunc",
                message: "Hello World"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_hasMultipleNonMatchingNonRequiredFilterAndMinLevel_False() {
        let destination = BaseDestination()
        destination.minLevel = .verbose
        destination.addFilter(Filters.path.contains("/ViewController", minLevel: .debug))
        destination.addFilter(Filters.path.contains("/test", minLevel: .verbose))
        #expect(
            !destination.shouldLevelBeLogged(
                .verbose,
                path: "/world/ViewController.swift",
                function: "myFunc",
                message: "Hello World"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_noFilters_True() {
        // everything is logged on default
        let destination = BaseDestination()
        #expect(
            destination.shouldLevelBeLogged(
                .debug,
                path: "/world/ViewController.swift",
                function: "myFunc",
                message: "Hello World"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_multipleNonRequiredFiltersAndGlobal_True() {
        // everything is logged on default
        let destination = BaseDestination()
        destination.minLevel = .info

        destination.addFilter(Filters.path.contains("/ViewController", minLevel: .debug))
        destination.addFilter(Filters.function.contains("Func", minLevel: .debug))
        destination.addFilter(Filters.message.contains("World", minLevel: .debug))
        // destination.debugPrint = true

        // covered by filters
        #expect(
            destination.shouldLevelBeLogged(
                .debug,
                path: "/world/ViewController.swift",
                function: "myFunc",
                message: "Hello World"
            )
        )

        // not in filter and below global minLevel
        #expect(
            !destination.shouldLevelBeLogged(
                .debug,
                path: "hello.swift",
                function: "foo",
                message: "bar"
            )
        )
    }

    @Test
    func shouldLevelBeLogged_excludeFilter_True() {
        // everything is logged on default
        let destination = BaseDestination()
        destination.minLevel = .error

        destination.addFilter(Filters.path.contains("/ViewController", minLevel: .debug))
        destination.addFilter(Filters.function.excludes("myFunc", minLevel: .debug))
        // destination.debugPrint = true

        // excluded
        #expect(
            !destination.shouldLevelBeLogged(
                .debug,
                path: "/world/ViewController.swift",
                function: "myFunc",
                message: "Hello World"
            )
        )

        // excluded
        #expect(
            !destination.shouldLevelBeLogged(
                .error,
                path: "/world/ViewController.swift",
                function: "myFunc",
                message: "Hello World"
            )
        )

        // not excluded, but below minLevel
        #expect(
            !destination.shouldLevelBeLogged(
                .debug,
                path: "/world/OtherViewController.swift",
                function: "otherFunc",
                message: "Hello World"
            )
        )

        // not excluded, above minLevel, no matching filter
        #expect(
            destination.shouldLevelBeLogged(
                .error,
                path: "/world/OtherViewController.swift",
                function: "otherFunc",
                message: "Hello World"
            )
        )

        // not excluded, above minLevel, matching path filter
        #expect(
            destination.shouldLevelBeLogged(
                .error,
                path: "/ViewController.swift",
                function: "otherFunc",
                message: "Hello World"
            )
        )
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
