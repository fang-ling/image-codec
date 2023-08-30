// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "txt",
  platforms: [.macOS(.v13)],
  products: [
    .library(name: "ImageCodec",targets: ["ImageCodec"]),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "ImageCodec",
      dependencies:[]
    ),
    .testTarget(
      name: "ImageCodecTests",
      dependencies: ["ImageCodec"]
    ),
  ]
)
