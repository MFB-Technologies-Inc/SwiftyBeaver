// Logger_Level+SwiftyBeaver_Level.swift
// SwiftyBeaver
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

import Logging
import SwiftyBeaver

extension Logger.Level {
    @inlinable
    public init(swiftyBeaverLevel: SwiftyBeaver.Level) {
        switch swiftyBeaverLevel {
        case .verbose:
            self = .trace
        case .debug:
            self = .debug
        case .info:
            self = .info
        case .warning:
            self = .warning
        case .error:
            self = .error
        case .critical:
            self = .critical
        case .fault:
            self = .critical
        }
    }
}
