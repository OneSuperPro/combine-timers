// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "combine-timers",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
    ],
    products: [
        .library(
            name: "CalendarTimer",
            targets: ["CalendarTimer"]
        ),
        .library(
            name: "RepeatingTimer",
            targets: ["RepeatingTimer"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/combine-schedulers", from: "0.5.2"),
    ],
    targets: [
        .target(
            name: "CalendarTimer",
            dependencies: [
                .product(name: "CombineSchedulers", package: "combine-schedulers"),
            ]
        ),
        .target(
            name: "RepeatingTimer",
            dependencies: [
                .product(name: "CombineSchedulers", package: "combine-schedulers"),
            ]
        ),
        .testTarget(
            name: "CalendarTimerTests",
            dependencies: [
                "CalendarTimer",
                .product(name: "CombineSchedulers", package: "combine-schedulers"),
            ]
        ),
        .testTarget(
            name: "RepeatingTimerTests",
            dependencies: [
                "RepeatingTimer",
                .product(name: "CombineSchedulers", package: "combine-schedulers"),
            ]
        ),
    ]
)
