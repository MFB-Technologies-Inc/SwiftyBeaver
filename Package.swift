// swift-tools-version:6.0

import Foundation
import PackageDescription

let package = Package(
    name: "SwiftyBeaver",
    products: [
        .library(name: "SwiftyBeaver", targets: ["SwiftyBeaver"]),
    ],
    targets: [
        .target(name: "SwiftyBeaver"),
        .testTarget(name: "SwiftyBeaverTests", dependencies: ["SwiftyBeaver"]),
    ]
)

extension ProcessInfo {
    // No value set enables `swift-log` integration.
    // To disable, explicit value is required.
    static let swiftLogIntegrationEnabled: Bool = ["YES", "TRUE", nil]
        .contains((ProcessInfo.processInfo.environment["SWIFT_LOG_INTEGRATION"])?.uppercased())
}

if ProcessInfo.swiftLogIntegrationEnabled {
    package.dependencies += [
        .package(
            url: "https://github.com/apple/swift-log.git",
            from: "1.0.0"
        ),
    ]

    package.targets += [
        .target(
            name: "SwiftyBeaverSwiftLog",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                "SwiftyBeaver",
            ]
        ),
        .testTarget(
            name: "SwiftyBeaverSwiftLogTests",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                "SwiftyBeaver",
                "SwiftyBeaverSwiftLog",
            ]
        ),
    ]

    package.products += [
        .library(
            name: "SwiftyBeaverSwiftLog",
            targets: ["SwiftyBeaverSwiftLog"]
        ),
    ]
}
