// SwiftyBeaver+Destinations.swift
// SwiftyBeaver
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

import Foundation

extension SwiftyBeaver {
    open class Destinations {
        // a set of active destinations
        public private(set) var destinations = Set<BaseDestination>()

        /// A private queue for synchronizing access to `destinations`.
        /// Read accesses are done concurrently.
        /// Write accesses are done with a barrier, ensuring only 1 operation is ran at that time.
        private static let queue = DispatchQueue(label: "destination queue", attributes: .concurrent)

        // MARK: Destination Handling

        /// returns boolean about success
        @discardableResult
        open func addDestination(_ destination: BaseDestination) -> Bool {
            Self.queue.sync(flags: DispatchWorkItemFlags.barrier) {
                if destinations.contains(destination) {
                    return false
                }
                destinations.insert(destination)
                return true
            }
        }

        /// returns boolean about success
        @discardableResult
        open func removeDestination(_ destination: BaseDestination) -> Bool {
            Self.queue.sync(flags: DispatchWorkItemFlags.barrier) {
                if destinations.contains(destination) == false {
                    return false
                }
                destinations.remove(destination)
                return true
            }
        }

        /// if you need to start fresh
        open func removeAllDestinations() {
            Self.queue.sync(flags: DispatchWorkItemFlags.barrier) {
                destinations.removeAll()
            }
        }

        /// returns the amount of destinations
        open func countDestinations() -> Int {
            Self.queue.sync { destinations.count }
        }

        /// internal helper which dispatches send to dedicated queue if minLevel is ok
        public func dispatch_send(
            // swiftlint:disable:previous function_parameter_count
            level: SwiftyBeaver.Level,
            message: @autoclosure () -> Any,
            thread: String,
            file: String,
            function: String,
            line: UInt,
            context: Any?
        ) {
            var resolvedMessage: String?
            let destinations = Self.queue.sync { self.destinations }
            for dest in destinations {
                guard let queue = dest.queue else {
                    continue
                }

                resolvedMessage =
                    resolvedMessage == nil && dest.hasMessageFilters()
                        ? "\(message())" : resolvedMessage
                if dest.shouldLevelBeLogged(
                    level, path: file, function: function, message: resolvedMessage
                ) {
                    // try to convert msg object to String and put it on queue
                    let msgStr = resolvedMessage == nil ? "\(message())" : resolvedMessage!
                    // swiftlint:disable:next identifier_name
                    let f = Self.stripParams(function: function)

                    if dest.asynchronously {
                        queue.async {
                            _ = dest.send(
                                level,
                                msg: msgStr,
                                thread: thread,
                                file: file,
                                function: f,
                                line: line,
                                context: context
                            )
                        }
                    } else {
                        queue.sync {
                            _ = dest.send(
                                level,
                                msg: msgStr,
                                thread: thread,
                                file: file,
                                function: f,
                                line: line,
                                context: context
                            )
                        }
                    }
                }
            }
        }

        // MARK: Levels

        /// log something generally unimportant (lowest priority)
        @inlinable
        open func verbose(
            _ message: @autoclosure () -> Any,
            file: String = #file,
            function: String = #function,
            line: UInt = #line,
            context: Any? = nil
        ) {
            custom(
                level: .verbose, message: message(), file: file, function: function, line: line,
                context: context
            )
        }

        /// log something which help during debugging (low priority)
        @inlinable
        open func debug(
            _ message: @autoclosure () -> Any,
            file: String = #file,
            function: String = #function,
            line: UInt = #line,
            context: Any? = nil
        ) {
            custom(
                level: .debug, message: message(), file: file, function: function, line: line,
                context: context
            )
        }

        /// log something which you are really interested but which is not an issue or error (normal priority)
        @inlinable
        open func info(
            _ message: @autoclosure () -> Any,
            file: String = #file,
            function: String = #function,
            line: UInt = #line,
            context: Any? = nil
        ) {
            custom(
                level: .info, message: message(), file: file, function: function, line: line,
                context: context
            )
        }

        /// log something which may cause big trouble soon (high priority)
        @inlinable
        open func warning(
            _ message: @autoclosure () -> Any,
            file: String = #file,
            function: String = #function,
            line: UInt = #line,
            context: Any? = nil
        ) {
            custom(
                level: .warning, message: message(), file: file, function: function, line: line,
                context: context
            )
        }

        /// log something which will keep you awake at night (highest priority)
        @inlinable
        open func error(
            _ message: @autoclosure () -> Any,
            file: String = #file,
            function: String = #function,
            line: UInt = #line,
            context: Any? = nil
        ) {
            custom(
                level: .error, message: message(), file: file, function: function, line: line,
                context: context
            )
        }

        /// log something which will keep you awake at night (highest priority)
        @inlinable
        open func critical(
            _ message: @autoclosure () -> Any,
            file: String = #file,
            function: String = #function,
            line: UInt = #line,
            context: Any? = nil
        ) {
            custom(
                level: .critical, message: message(), file: file, function: function, line: line,
                context: context
            )
        }

        /// log something which will keep you awake at night (highest priority)
        @inlinable
        open func fault(
            _ message: @autoclosure () -> Any,
            file: String = #file,
            function: String = #function,
            line: UInt = #line,
            context: Any? = nil
        ) {
            custom(
                level: .fault, message: message(), file: file, function: function, line: line,
                context: context
            )
        }

        /// custom logging to manually adjust values, should just be used by other frameworks
        @inlinable
        open func custom(
            // swiftlint:disable:previous function_parameter_count
            level: SwiftyBeaver.Level,
            message: @autoclosure () -> Any,
            file: String,
            function: String,
            line: UInt,
            context: Any?
        ) {
            dispatch_send(
                level: level,
                message: message(),
                thread: Self.threadName(),
                file: file,
                function: function,
                line: line,
                context: context
            )
        }

        /// flush all destinations to make sure all logging messages have been written out
        /// returns after all messages flushed or timeout seconds
        /// returns: true if all messages flushed, false if timeout or error occurred
        public func flush(secondTimeout: Int64) -> Bool {
            let grp = DispatchGroup()
            let destinations = Self.queue.sync { self.destinations }
            for dest in destinations {
                guard let queue = dest.queue else {
                    continue
                }
                grp.enter()
                if dest.asynchronously {
                    queue.async {
                        dest.flush()
                        grp.leave()
                    }
                } else {
                    queue.sync {
                        dest.flush()
                        grp.leave()
                    }
                }
            }
            return grp.wait(timeout: .now() + .seconds(Int(secondTimeout))) == .success
        }

        /// returns the current thread name
        open class func threadName() -> String {
            #if os(Linux)
                // on 9/30/2016 not yet implemented in server-side Swift:
                // > import Foundation
                // > Thread.isMainThread

                // 2025/03/13 `Thread.isMainThread` is implemented on non-Darwin platforms. However,
                // `__dispatch_queue_get_label` is not exposed on non-Darwin platforms.
                // `dispatch_queue_get_label` is marked as unavailable.
                return ""
            #else
                if Thread.isMainThread {
                    return ""
                } else {
                    let name = __dispatch_queue_get_label(nil)
                    return String(cString: name, encoding: .utf8) ?? Thread.current.description
                }
            #endif
        }

        /// removes the parameters from a function because it looks weird with a single param
        @_spi(Testable)
        public class func stripParams(function: String) -> String {
            // swiftlint:disable:next identifier_name
            var f = function
            if let indexOfBrace = f.firstIndex(of: "(") {
                f = String(f[..<indexOfBrace])
            }
            f += "()"
            return f
        }

        public init() {
            // empty
        }
    }
}
