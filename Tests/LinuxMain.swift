// LinuxMain.swift
// SwiftyBeaver
//
// Copyright (c) 2015 Sebastian Kreutzberger
// All rights reserved.
//
// Copyright 2025 MFB Technologies, Inc.
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

@testable import SwiftyBeaverTests
import XCTest

XCTMain([
    testCase(BaseDestinationTests.allTests),
    testCase(ConsoleDestinationTests.allTests),
    testCase(SwiftyBeaverTests.allTests),
])
