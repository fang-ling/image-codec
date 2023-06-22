// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "txt",
  products: [
    .library(name: "ImageCodec",targets: ["ImageCodec"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/tayloraswift/swift-png",
      from: "4.0.2"
    ),
    .package(
      url: "https://github.com/fang-ling/image-intermedia",
      from: "0.0.1"
    )
  ],
  targets: [
    .target(
      name: "ImageCodec",
      dependencies:[
        .product(name: "ImageIntermedia", package: "image-intermedia"),
        "CJPEGTurbo",
        .product(name: "PNG", package: "swift-png"),
        "CHEIF",
        "CWebP"
      ]
    ),
    .systemLibrary(
      name: "CJPEGTurbo",
      pkgConfig: "libturbojpeg",
      providers: [
        .brew(["jpeg-turbo"])
      ]
    ),
    .systemLibrary(
      name: "CHEIF",
      pkgConfig: "libheif",
      providers: [
        .brew(["libheif"])
      ]
    ),
    .systemLibrary(
      name: "CWebP",
      pkgConfig: "libwebp",
      providers: [
        .brew(["webp"])
      ]
    ),
    .testTarget(
      name: "ImageCodecTests",
      dependencies: ["ImageCodec"]
    ),
  ]
)
