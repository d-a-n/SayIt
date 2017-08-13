// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "spm",
    dependencies: [
        .Package(url: "https://github.com/d-a-n/swift-language-detector.git", majorVersion: 1)
    ]
)
