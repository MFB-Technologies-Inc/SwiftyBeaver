// UncheckedSendable.swift
// SwiftyBeaver
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

/// Temporary tool for silencing warnings and errors when a sendable closure captures a non-sendable value
///
/// Every place this is currently used, it is an error with Swift 6.0 but a warning with Swift 6.1. They may become
/// errors again in a later version.
@available(swift, deprecated: 6.1, message: "All silenced errors in 6.0 are warnings in 6.1.")
struct UncheckedSendable<T>: @unchecked Sendable {
    let wrapped: T
}
