// BaseDestination.swift
// SwiftyBeaver
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

// swiftlint:disable file_length

import Dispatch
import Foundation

// swiftlint:disable type_body_length

/// destination which all others inherit from. do not directly use
open class BaseDestination: Hashable, Equatable {
    /// output format pattern, see documentation for syntax
    open var format = "$DHH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M"

    /// runs in own serial background thread for better performance
    open var asynchronously = true

    /// do not log any message which has a lower level than this one
    open var minLevel = SwiftyBeaver.Level.verbose

    /// set custom log level words for each level
    open var levelString = LevelString()

    /// set custom log level colors for each level
    open var levelColor = LevelColor()

    /// set custom calendar for dateFormatter
    open var calendar = Calendar.current

    public struct LevelString {
        public var verbose = "VERBOSE"
        public var debug = "DEBUG"
        public var info = "INFO"
        public var warning = "WARNING"
        public var error = "ERROR"
        public var critical = "CRITICAL"
        public var fault = "FAULT"
    }

    // For a colored log level word in a logged line
    // empty on default
    public struct LevelColor {
        public var verbose = "" // silver
        public var debug = "" // green
        public var info = "" // blue
        public var warning = "" // yellow
        public var error = "" // red
        public var critical = "" // red
        public var fault = "" // red
    }

    var reset = ""
    var escape = ""

    var filters = [FilterType]()
    let formatter = DateFormatter()
    let startDate = Date()

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(Self.self))
    }

    // each destination instance must have an own serial queue to ensure serial output
    // GCD gives it a prioritization between User Initiated and Utility
    var queue: DispatchQueue? // dispatch_queue_t?
    var debugPrint = false // set to true to debug the internal filter logic of the class

    public init() {
        let uuid = NSUUID().uuidString
        let queueLabel = "swiftybeaver-queue-" + uuid
        queue = DispatchQueue(label: queueLabel, target: queue)
    }

    // swiftlint:disable function_parameter_count
    /// send / store the formatted log message to the destination
    /// returns the formatted log message for processing by inheriting method
    /// and for unit tests (nil if error)
    open func send(
        _ level: SwiftyBeaver.Level,
        msg: String,
        thread: String,
        file: String,
        function: String,
        line: Int,
        context: Any? = nil
    ) -> String? {
        if format.hasPrefix("$J") {
            messageToJSON(
                level,
                msg: msg,
                thread: thread,
                file: file,
                function: function,
                line: line,
                context: context
            )

        } else {
            formatMessage(
                format,
                level: level,
                msg: msg,
                thread: thread,
                file: file,
                function: function,
                line: line,
                context: context
            )
        }
    }

    // swiftlint:enable function_parameter_count

    // Allows customization of fallback logging. Defaults to `print`
    open class func fallbackLog(
        _ message: @autoclosure () -> String,
        file _: String = #file,
        function _: String = #function,
        line _: Int = #line,
        context _: Any? = nil
    ) {
        print("SwiftyBeaver.\(String(describing: Self.self)): \(message())")
    }

    public func execute(synchronously: Bool, block: @escaping () -> Void) {
        guard let queue else {
            fatalError("Queue not set")
        }
        if synchronously {
            queue.sync(execute: block)
        } else {
            queue.async(execute: block)
        }
    }

    public func executeSynchronously<T>(block: @escaping () throws -> T) rethrows -> T {
        guard let queue else {
            fatalError("Queue not set")
        }
        return try queue.sync(execute: block)
    }

    ////////////////////////////////

    // MARK: Format

    ////////////////////////////////

    /// returns (padding length value, offset in string after padding info)
    private func parsePadding(_ text: String) -> (Int, Int) {
        // look for digits followed by a alpha character
        // swiftlint:disable:next identifier_name
        var s: String!
        var sign: Int = 1
        if text.first == "-" {
            sign = -1
            s = String(text.suffix(from: text.index(text.startIndex, offsetBy: 1)))
        } else {
            s = text
        }
        let numStr = String(s.prefix { $0 >= "0" && $0 <= "9" })
        if let num = Int(numStr) {
            return (sign * num, (sign == -1 ? 1 : 0) + numStr.count)
        } else {
            return (0, 0)
        }
    }

    private func paddedString(_ text: String, _ toLength: Int, truncating: Bool = false) -> String {
        if toLength > 0 {
            // Pad to the left of the string
            if text.count > toLength {
                // Hm... better to use suffix or prefix?
                return truncating ? String(text.suffix(toLength)) : text
            } else {
                return "".padding(toLength: toLength - text.count, withPad: " ", startingAt: 0)
                    + text
            }
        } else if toLength < 0 {
            // Pad to the right of the string
            let maxLength = truncating ? -toLength : max(-toLength, text.count)
            return text.padding(toLength: maxLength, withPad: " ", startingAt: 0)
        } else {
            return text
        }
    }

    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_body_length
    // swiftlint:disable function_parameter_count
    /// returns the log message based on the format pattern
    func formatMessage(
        _ format: String,
        level: SwiftyBeaver.Level,
        msg: String,
        thread: String,
        file: String,
        function: String,
        line: Int,
        context: Any? = nil
    ) -> String {
        var text = ""
        // Prepend a $I for 'ignore' or else the first character is interpreted as a format character
        // even if the format string did not start with a $.
        let phrases: [String] = ("$I" + format).components(separatedBy: "$")

        for phrase in phrases where !phrase.isEmpty {
            let (padding, offset) = parsePadding(phrase)
            let formatCharIndex = phrase.index(phrase.startIndex, offsetBy: offset)
            let formatChar = phrase[formatCharIndex]
            let rangeAfterFormatChar = phrase.index(formatCharIndex, offsetBy: 1) ..< phrase.endIndex
            let remainingPhrase = phrase[rangeAfterFormatChar]

            switch formatChar {
            case "I": // ignore
                text += remainingPhrase
            case "L":
                text += paddedString(levelWord(level), padding) + remainingPhrase
            case "M":
                text += paddedString(msg, padding) + remainingPhrase
            case "T":
                text += paddedString(thread, padding) + remainingPhrase
            case "N":
                // name of file without suffix
                text += paddedString(fileNameWithoutSuffix(file), padding) + remainingPhrase
            case "n":
                // name of file with suffix
                text += paddedString(fileNameOfFile(file), padding) + remainingPhrase
            case "F":
                text += paddedString(function, padding) + remainingPhrase
            case "l":
                text += paddedString(String(line), padding) + remainingPhrase
            case "D":
                // start of datetime format
                text += paddedString(formatDate(String(remainingPhrase)), padding)
            case "d":
                text += remainingPhrase
            case "U":
                text += paddedString(uptime(), padding) + remainingPhrase
            case "Z":
                // start of datetime format in UTC timezone
                text += paddedString(
                    formatDate(String(remainingPhrase), timeZone: "UTC"), padding
                )
            case "z":
                text += remainingPhrase
            case "C":
                // color code ("" on default)
                text += escape + colorForLevel(level) + remainingPhrase
            case "c":
                text += reset + remainingPhrase
            case "X":
                // add the context
                // swiftlint:disable:next identifier_name
                if let cx = context {
                    text +=
                        paddedString(
                            String(describing: cx).trimmingCharacters(in: .whitespacesAndNewlines),
                            padding
                        ) + remainingPhrase
                } else {
                    text += paddedString("", padding) + remainingPhrase
                }
            default:
                text += phrase
            }
        }
        // right trim only
        return text.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
    }

    // swiftlint:enable cyclomatic_complexity
    // swiftlint:enable function_body_length
    // swiftlint:enable function_parameter_count

    // swiftlint:disable function_parameter_count
    /// returns the log payload as optional JSON string
    func messageToJSON(
        _ level: SwiftyBeaver.Level,
        msg: String,
        thread: String,
        file: String,
        function: String,
        line: Int,
        context: Any? = nil
    ) -> String? {
        var dict: [String: Any] = [
            "timestamp": Date().timeIntervalSince1970,
            "level": level.rawValue,
            "message": msg,
            "thread": thread,
            "file": file,
            "function": function,
            "line": line,
        ]
        // swiftlint:disable:next identifier_name
        if let cx = context {
            dict["context"] = cx
        }
        return jsonStringFromDict(dict)
    }

    // swiftlint:enable function_parameter_count

    /// returns the string of a level
    func levelWord(_ level: SwiftyBeaver.Level) -> String {
        var str = ""

        switch level {
        case .verbose:
            str = levelString.verbose

        case .debug:
            str = levelString.debug

        case .info:
            str = levelString.info

        case .warning:
            str = levelString.warning

        case .error:
            str = levelString.error

        case .critical:
            str = levelString.critical

        case .fault:
            str = levelString.fault
        }
        return str
    }

    /// returns color string for level
    func colorForLevel(_ level: SwiftyBeaver.Level) -> String {
        var color = ""

        switch level {
        case .verbose:
            color = levelColor.verbose

        case .debug:
            color = levelColor.debug

        case .info:
            color = levelColor.info

        case .warning:
            color = levelColor.warning

        case .error:
            color = levelColor.error

        case .critical:
            color = levelColor.critical

        case .fault:
            color = levelColor.fault
        }
        return color
    }

    /// returns the filename of a path
    func fileNameOfFile(_ file: String) -> String {
        let fileParts = file.components(separatedBy: "/")
        if let lastPart = fileParts.last {
            return lastPart
        }
        return ""
    }

    /// returns the filename without suffix (= file ending) of a path
    func fileNameWithoutSuffix(_ file: String) -> String {
        let fileName = fileNameOfFile(file)

        if !fileName.isEmpty {
            let fileNameParts = fileName.components(separatedBy: ".")
            if let firstPart = fileNameParts.first {
                return firstPart
            }
        }
        return ""
    }

    /// returns a formatted date string
    /// optionally in a given abbreviated timezone like "UTC"
    func formatDate(_ dateFormat: String, timeZone: String = "") -> String {
        if !timeZone.isEmpty {
            formatter.timeZone = TimeZone(abbreviation: timeZone)
        }
        formatter.calendar = calendar
        formatter.dateFormat = dateFormat
        // let dateStr = formatter.string(from: NSDate() as Date)
        let dateStr = formatter.string(from: Date())
        return dateStr
    }

    /// returns a uptime string
    func uptime() -> String {
        let interval = Date().timeIntervalSince(startDate)

        let hours = Int(interval) / 3600
        let minutes = Int(interval / 60) - Int(hours * 60)
        let seconds = Int(interval) - (Int(interval / 60) * 60)
        let milliseconds = Int(interval.truncatingRemainder(dividingBy: 1) * 1000)

        return String(
            format: "%0.2d:%0.2d:%0.2d.%03d", arguments: [hours, minutes, seconds, milliseconds]
        )
    }

    /// returns the json-encoded string value
    /// after it was encoded by jsonStringFromDict
    func jsonStringValue(_ jsonString: String?, key: String) -> String {
        guard let str = jsonString else {
            return ""
        }

        // remove the leading {"key":" from the json string and the final }
        let offset = key.count + 5
        let endIndex = str.index(
            str.startIndex,
            offsetBy: str.count - 2
        )
        let range = str.index(str.startIndex, offsetBy: offset) ..< endIndex
        return String(str[range])
    }

    /// turns dict into JSON-encoded string
    func jsonStringFromDict(_ dict: [String: Any]) -> String? {
        var jsonString: String?

        // try to create JSON string
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
            jsonString = String(data: jsonData, encoding: .utf8)
        } catch {
            Self.fallbackLog("Could not create JSON from dict. Error: \(String(describing: error))")
        }
        return jsonString
    }

    ////////////////////////////////

    // MARK: Filters

    ////////////////////////////////

    /// Add a filter that determines whether or not a particular message will be logged to this destination
    public func addFilter(_ filter: FilterType) {
        filters.append(filter)
    }

    /// Remove a filter from the list of filters
    public func removeFilter(_ filter: FilterType) {
        let index = filters.firstIndex {
            ObjectIdentifier($0) == ObjectIdentifier(filter)
        }

        guard let filterIndex = index else {
            return
        }

        filters.remove(at: filterIndex)
    }

    /// Answer whether the destination has any message filters
    /// returns boolean and is used to decide whether to resolve
    /// the message before invoking shouldLevelBeLogged
    func hasMessageFilters() -> Bool {
        !getFiltersTargeting(
            Filter.TargetType.message(.equals([], true)),
            fromFilters: filters
        ).isEmpty
    }

    // swiftlint:disable cyclomatic_complexity
    /// checks if level is at least minLevel or if a minLevel filter for that path does exist
    /// returns boolean and can be used to decide if a message should be logged or not
    func shouldLevelBeLogged(
        _ level: SwiftyBeaver.Level,
        path: String,
        function: String,
        message: String? = nil
    ) -> Bool {
        if filters.isEmpty {
            if level.rawValue >= minLevel.rawValue {
                if debugPrint {
                    Self.fallbackLog("filters are empty and level >= minLevel")
                }
                return true
            } else {
                if debugPrint {
                    Self.fallbackLog("filters are empty and level < minLevel")
                }
                return false
            }
        }

        let filterCheckResult = FilterValidator.validate(
            input: .init(
                filters: filters,
                level: level,
                path: path,
                function: function,
                message: message
            )
        )

        // Exclusion filters match if they do NOT meet the filter condition (see Filter.apply(_:) method)
        switch filterCheckResult[.excluded] {
        case .some(.someFiltersMatch):
            // Exclusion filters are present and at least one of them matches the log entry
            if debugPrint {
                Self.fallbackLog("filters are not empty and message was excluded")
            }
            return false
        case .some(.allFiltersMatch), .some(.noFiltersMatchingType), .none: break
        }

        // If required filters exist, we should validate or invalidate the log if all of them pass or not
        switch filterCheckResult[.required] {
        case .some(.allFiltersMatch): return true
        case .some(.someFiltersMatch): return false
        case .some(.noFiltersMatchingType), .none: break
        }

        let checkLogLevel: () -> Bool = {
            // Check if the log message's level matches or exceeds the minLevel of the destination
            level.rawValue >= self.minLevel.rawValue
        }

        // Non-required filters should only be applied if the log entry matches the filter condition (e.g. path)
        switch filterCheckResult[.nonRequired] {
        case .some(.allFiltersMatch): return true
        case .some(.noFiltersMatchingType), .none: return checkLogLevel()
        case let .some(.someFiltersMatch(partialMatchData)):
            if partialMatchData.fullMatchCount > 0 {
                // The log entry matches at least one filter condition and the destination's log level
                return true
            } else if partialMatchData.conditionMatchCount > 0 {
                // The log entry matches at least one filter condition, but does not match or exceed the destination's
                // log level
                return false
            } else {
                // There is no filter with a matching filter condition. Check the destination's log level
                return checkLogLevel()
            }
        }
    }

    // swiftlint:enable cyclomatic_complexity

    func getFiltersTargeting(_ target: Filter.TargetType, fromFilters: [FilterType]) -> [FilterType] {
        fromFilters.filter { filter in
            filter.getTarget() == target
        }
    }

    /**
      Triggered by main flush() method on each destination. Runs in background thread.
     Use for destinations that buffer log items, implement this function to flush those
     buffers to their final destination (web server...)
     */
    func flush() {
        // no implementation in base destination needed
    }
}

// swiftlint:enable type_body_length

public func == (lhs: BaseDestination, rhs: BaseDestination) -> Bool {
    ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}
