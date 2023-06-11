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
      from: "4.0.2"
    )
  ],
  targets: [
    .target(
      name: "txt",
      dependencies:[
        "CJPEGTurbo",
        .product(name: "PNG", package: "swift-png"),
        "CHEIF",
        "CWebP"
      ]),
    .systemLibrary(
      name: "CJPEGTurbo",
      pkgConfig: "libturbojpeg",
      providers: [
        .brew(["jpeg-turbo"])
      ]),
    .systemLibrary(
      name: "CHEIF",
      pkgConfig: "libheif",
      providers: [
        .brew(["libheif"])
      ]),
    .systemLibrary(
      name: "CWebP",
      pkgConfig: "libwebp",
      providers: [
        .brew(["webp"])
      ]),
    .testTarget(
      name: "txtTests",
      dependencies: ["txt"]),
  ]
)
