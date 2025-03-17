// SwiftyBeaver_Level+Logger_Level.swift
// SwiftyBeaver
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

import Logging
import SwiftyBeaver

extension SwiftyBeaver.Level {
    @inlinable
    public init(swiftLogLevel: Logger.Level) {
        switch swiftLogLevel {
        case .trace:
            self = .verbose
        case .debug:
            self = .debug
        case .info:
            self = .info
        case .notice:
            self = .info
        case .warning:
            self = .warning
        case .error:
            self = .error
        case .critical:
            self = .critical
        }
    }
}
