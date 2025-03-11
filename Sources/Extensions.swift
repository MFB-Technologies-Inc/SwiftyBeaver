// Extensions.swift
// SwiftyBeaver
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

import Foundation

extension String {
    /// cross-Swift compatible characters count
    var length: Int {
        count
    }

    /// cross-Swift-compatible first character
    var firstChar: Character? {
        first
    }

    /// cross-Swift-compatible last character
    var lastChar: Character? {
        last
    }

    /// cross-Swift-compatible index
    func find(_ char: Character) -> Index? {
        return firstIndex(of: char)
    }
}
