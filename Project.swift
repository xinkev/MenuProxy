import ProjectDescription

let project = Project(
    name: "MenuProxy",
    targets: [
        .target(
            name: "MenuProxy",
            destinations: .macOS,
            product: .app,
            bundleId: "com.xinkev.menuproxy",
            infoPlist: .extendingDefault(with: [
                "LSUIElement": true,
                "CFBundleShortVersionString": "1.0.0",
                "CFBundleVersion": "1"
            ]),
            buildableFolders: [
                "MenuProxy/Sources",
                "MenuProxy/Resources",
            ],
            dependencies: []
        ),
        .target(
            name: "MenuProxyTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "com.xinkev.menuproxy.tests",
            infoPlist: .default,
            buildableFolders: [
                "MenuProxy/Tests"
            ],
            dependencies: [.target(name: "MenuProxy")]
        ),
    ],
)

