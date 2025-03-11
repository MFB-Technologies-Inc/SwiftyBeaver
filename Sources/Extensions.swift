// Extensions.swift
// SwiftyBeaver
//
// Copyright (c) 2015 Sebastian Kreutzberger
// All rights reserved.
//
// Copyright 2025 MFB Technologies, Inc.
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
        #if swift(>=5)
            return firstIndex(of: char)
        #else
            return index(of: char)
        #endif
    }
}
