// SwiftyBeaver.swift
// SwiftyBeaver
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

import Foundation

open class SwiftyBeaver {
    /// version string of framework
    public static let version = "2.1.1" // UPDATE ON RELEASE!
    /// build number of framework
    public static let build = 2110 // version 1.6.2 -> 1620, UPDATE ON RELEASE!

    public enum Level: Int, CaseIterable {
        case verbose = 0
        case debug = 1
        case info = 2
        case warning = 3
        case error = 4
        case critical = 5
        case fault = 6
    }

    public static let destinationsState = Destinations()

    // a set of active destinations
    public static var destinations: Set<BaseDestination> {
        destinationsState.destinations
    }

    // MARK: Destination Handling

    /// returns boolean about success
    @discardableResult
    open class func addDestination(_ destination: BaseDestination) -> Bool {
        destinationsState.addDestination(destination)
    }

    /// returns boolean about success
    @discardableResult
    open class func removeDestination(_ destination: BaseDestination) -> Bool {
        destinationsState.removeDestination(destination)
    }

    /// if you need to start fresh
    open class func removeAllDestinations() {
        destinationsState.removeAllDestinations()
    }

    /// returns the amount of destinations
    open class func countDestinations() -> Int {
        destinationsState.countDestinations()
    }

    /// returns the current thread name
    @inlinable
    open class func threadName() -> String {
        Destinations.threadName()
    }

    // MARK: Levels

    /// log something generally unimportant (lowest priority)
    @inlinable
    open class func verbose(
        _ message: @autoclosure () -> Any,
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        context: Any? = nil
    ) {
        destinationsState.verbose(
            message(),
            file: file,
            function: function,
            line: line,
            context: context
        )
    }

    /// log something which help during debugging (low priority)
    @inlinable
    open class func debug(
        _ message: @autoclosure () -> Any,
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        context: Any? = nil
    ) {
        destinationsState.debug(
            message(),
            file: file,
            function: function,
            line: line,
            context: context
        )
    }

    /// log something which you are really interested but which is not an issue or error (normal priority)
    @inlinable
    open class func info(
        _ message: @autoclosure () -> Any,
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        context: Any? = nil
    ) {
        destinationsState.info(
            message(),
            file: file,
            function: function,
            line: line,
            context: context
        )
    }

    /// log something which may cause big trouble soon (high priority)
    @inlinable
    open class func warning(
        _ message: @autoclosure () -> Any,
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        context: Any? = nil
    ) {
        destinationsState.warning(
            message(),
            file: file,
            function: function,
            line: line,
            context: context
        )
    }

    /// log something which will keep you awake at night (highest priority)
    @inlinable
    open class func error(
        _ message: @autoclosure () -> Any,
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        context: Any? = nil
    ) {
        destinationsState.error(
            message(),
            file: file,
            function: function,
            line: line,
            context: context
        )
    }

    /// log something which will keep you awake at night (highest priority)
    @inlinable
    open class func critical(
        _ message: @autoclosure () -> Any,
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        context: Any? = nil
    ) {
        destinationsState.critical(
            message(),
            file: file,
            function: function,
            line: line,
            context: context
        )
    }

    /// log something which will keep you awake at night (highest priority)
    @inlinable
    open class func fault(
        _ message: @autoclosure () -> Any,
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        context: Any? = nil
    ) {
        destinationsState.fault(
            message(),
            file: file,
            function: function,
            line: line,
            context: context
        )
    }

    /// custom logging to manually adjust values, should just be used by other frameworks
    @inlinable
    open class func custom(
        level: SwiftyBeaver.Level,
        message: @autoclosure () -> Any,
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        context: Any? = nil
    ) {
        destinationsState.custom(
            level: level,
            message: message(),
            file: file,
            function: function,
            line: line,
            context: context
        )
    }

    /// flush all destinations to make sure all logging messages have been written out
    /// returns after all messages flushed or timeout seconds
    /// returns: true if all messages flushed, false if timeout or error occurred
    public class func flush(secondTimeout: Int64) -> Bool {
        destinationsState.flush(secondTimeout: secondTimeout)
    }
}

// MARK: Sendable

extension SwiftyBeaver.Level: Sendable {}
