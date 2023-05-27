// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "txt",
  products: [
    .library(
      name: "txt",
      targets: ["txt"]),
  ],
  targets: [
    .target(
      name: "txt",
      dependencies:["CJPEGTurbo"]),
    .systemLibrary(
      name: "CJPEGTurbo",
      pkgConfig: "libturbojpeg",
      providers: [
        .brew(["jpeg-turbo"])
      ]),
    .testTarget(
      name: "txtTests",
      dependencies: ["txt"]),
  ]
)
