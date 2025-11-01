import ProjectDescription

let project = Project(
    name: "MbProxyToggle",
    targets: [
        .target(
            name: "MbProxyToggle",
            destinations: .macOS,
            product: .app,
            bundleId: "dev.tuist.MbProxyToggle",
            infoPlist: .extendingDefault(with: [
                "LSUIElement": true
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
