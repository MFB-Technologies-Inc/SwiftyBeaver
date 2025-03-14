// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "SwiftyBeaver",
    products: [
        .library(name: "SwiftyBeaver", targets: ["SwiftyBeaver"]),
    ],
    targets: [
        .target(name: "SwiftyBeaver", path: "Sources"),
        .testTarget(name: "SwiftyBeaverTests", dependencies: ["SwiftyBeaver"]),
    ]
)
