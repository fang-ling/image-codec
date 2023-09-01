## ImageCodec

**ImageCodec** is an image encoder/decoder built on top of the system's [Image I/O](https://developer.apple.com/documentation/imageio) and [Accelerate/vImage](https://developer.apple.com/documentation/accelerate/vimage#overview) framework.

### Features

- [x] Support most image file formats:

| Format | Decode | Encode | Compatibility |
| ------ | ------ | ------ | ------------- |
| PNG    | YES    | YES    |               |
| JPEG   | YES    | YES    |               |
| HEIC   | YES    | YES    | macOS High Sierra+ |
| WebP   | YES    |        | macOS Big Sur+     |
| AVIF   | YES    |        | macOS Ventura+     |
| JPEG-XL| YES    |        | macOS Sonoma+      |

- [x] Offer high efficiency, color management, and access to image metadata.

## Usage

Decode an image:

```swift

```

Encode an image:
```swift

```

## Using ImageCodec in your project

To use this package in a SwiftPM project, you need to set it up as a package dependency:
```swift
// swift-tools-version:5.8
import PackageDescription

let package = Package(
  name: "MyPackage",
  dependencies: [
    .package(url: "https://github.com/fang-ling/image-codec", from: "0.0.12"),
  ],
  targets: [
    .target(
      name: "MyTarget",
      dependencies: [
        .product(name: "ImageCodec", package: "image-codec"),
      ]
    )
  ]
)
```

## Building image-codec

### Build Requirements

#### macOS

  - Xcode 

### Build Procedure

```shell
cd image-codec
swift build
```
