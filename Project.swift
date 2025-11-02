import ProjectDescription

let project = Project(
    name: "MbProxyToggle",
    targets: [
        .target(
            name: "MbProxyToggle",
            destinations: .macOS,
            product: .app,
            bundleId: "com.xinkev.MbProxyToggle",
            infoPlist: .extendingDefault(with: [
                "LSUIElement": true,
                "CFBundleShortVersionString": "1.0.0",
                "CFBundleVersion": "1"
            ]),
            buildableFolders: [
                "MbProxyToggle/Sources",
                "MbProxyToggle/Resources",
            ],
            dependencies: []
        ),
        .target(
            name: "MbProxyToggleTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "dev.tuist.MbProxyToggleTests",
            infoPlist: .default,
            buildableFolders: [
                "MbProxyToggle/Tests"
            ],
            dependencies: [.target(name: "MbProxyToggle")]
        ),
    ],
)

