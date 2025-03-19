// LevelConversionTests.swift
// SwiftyBeaver
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

#if canImport(Testing)
    import Logging
    import SwiftyBeaver
    import SwiftyBeaverSwiftLog
    import Testing

    @Suite
    struct LevelConversionTests {
        @Test
        func fromSwiftyBeaver() {
            let levelConversion = SwiftyBeaverLogHandler.LevelConversion()

            let swiftyBeaverLevels = SwiftyBeaver.Level.allCases

            let swiftLogLevels = swiftyBeaverLevels.map(levelConversion.fromSwiftyBeaver)

            #expect(swiftLogLevels == [
                .trace,
                .debug,
                .info,
                .warning,
                .error,
                .critical,
                .critical,
            ])
        }

        @Test
        func toSwiftyBeaver() {
            let levelConversion = SwiftyBeaverLogHandler.LevelConversion()

            let swiftLogLevels = Logger.Level.allCases

            let swiftyBeaverLevels = swiftLogLevels.map(levelConversion.toSwiftyBeaver)

            #expect(swiftyBeaverLevels == [
                .verbose,
                .debug,
                .info,
                .info,
                .warning,
                .error,
                .critical,
            ])
        }
    }
#endif
