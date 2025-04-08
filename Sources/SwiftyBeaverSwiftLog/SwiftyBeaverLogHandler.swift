// SwiftyBeaverLogHandler.swift
// SwiftyBeaver
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

import Logging
import SwiftyBeaver

/// A `swift-log` `LogHandler` implementation that integates `SwiftyBeaver`.
public struct SwiftyBeaverLogHandler: LogHandler {
    public let levelConversion: LevelConversion
    /// The current minimum log level. Independent of `SwiftyBeaver` destinations.
    ///
    /// Not automatically kept in sync with `SwiftyBeaver` destinations
    public var logLevel: Logger.Level
    public var metadata: Logger.Metadata

    public init(
        levelConversion: LevelConversion = LevelConversion(),
        logLevel: Logger.Level = .trace,
        metadata: Logger.Metadata = [:]
    ) {
        self.levelConversion = levelConversion
        self.logLevel = logLevel
        self.metadata = metadata
    }

    /// Allows the customization of mapping between `Logger.Level` and `SwiftyBeaver.Level`
    public struct LevelConversion: Sendable {
        public let fromSwiftyBeaver: @Sendable (SwiftyBeaver.Level) -> Logger.Level
        public let toSwiftyBeaver: @Sendable (Logger.Level) -> SwiftyBeaver.Level

        public init(
            fromSwiftyBeaver: @escaping @Sendable (SwiftyBeaver.Level) -> Logger.Level = Logger.Level
                .init(swiftyBeaverLevel:),
            toSwiftyBeaver: @escaping @Sendable (Logger.Level) -> SwiftyBeaver.Level = SwiftyBeaver.Level
                .init(swiftLogLevel:)
        ) {
            self.fromSwiftyBeaver = fromSwiftyBeaver
            self.toSwiftyBeaver = toSwiftyBeaver
        }
    }

    public subscript(metadataKey key: String) -> Logging.Logger.Metadata.Value? {
        get {
            metadata[key]
        }
        set(newValue) {
            metadata[key] = newValue
        }
    }

    // swiftlint:disable function_parameter_count
    @inlinable
    public func log(
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata?,
        source _: String,
        file: String,
        function: String,
        line: UInt
    ) {
        SwiftyBeaver.custom(
            level: levelConversion.toSwiftyBeaver(level),
            message: message,
            file: file,
            function: function,
            line: line,
            context: metadata ?? self.metadata
        )
    }
    // swiftlint:enable function_parameter_count
}
