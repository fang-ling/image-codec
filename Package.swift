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
      dependencies:["CJPEGTurbo", "CPNG"]),
    .systemLibrary(
      name: "CJPEGTurbo",
      pkgConfig: "libturbojpeg",
      providers: [
        .brew(["jpeg-turbo"])
      ]),
    .systemLibrary(
      name: "CPNG",
      pkgConfig: "libpng",
      providers: [
        .brew(["libpng"])
      ]),
    .testTarget(
      name: "txtTests",
      dependencies: ["txt"]),
  ]
)
