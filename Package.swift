// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "txt",
  products: [
    .library(
      name: "txt",
      targets: ["txt"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/tayloraswift/swift-png",
      .upToNextMajor(from: "4.0.2")
    )
  ],
  targets: [
    .target(
      name: "txt",
      dependencies:[
        "CJPEGTurbo",
        .product(name: "PNG", package: "swift-png")
      ]),
    .systemLibrary(
      name: "CJPEGTurbo",
      pkgConfig: "libturbojpeg",
      providers: [
        .brew(["jpeg-turbo"])
      ]),
//    .systemLibrary(
//      name: "CPNG",
//      pkgConfig: "libpng",
//      providers: [
//        .brew(["libpng"])
//      ]),
    .testTarget(
      name: "txtTests",
      dependencies: ["txt"]),
  ]
)
