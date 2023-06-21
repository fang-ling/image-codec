## ImageCodec

**ImageCodec** is a Swift wrapper of [libwebp](https://github.com/webmproject/libwebp), [libheif](https://github.com/strukturag/libheif) and [libjpeg-turbo](https://github.com/libjpeg-turbo/libjpeg-turbo), which also uses [swift-png](https://github.com/tayloraswift/swift-png) to provide support for the PNG format.

### Features

- [x] Support multiple formats (PNG, JPEG, HEIF and WebP)
- [x] Support macOS and Linux

### To do

- [ ] Auxiliary data and metadata
- [ ] Advanced Encoder API
- [ ] Swift error handling

| Format | Decode | Encode |
| ------ | ------ | ------ |
| PNG    | YES    |        |
| JPEG   | YES    |        |
| HEIF   | YES    |        |
| WebP   | YES    | YES    |

## Usage

Decode an image:

```swift
import txt
var rgba64 = Decoder.decode(from_png: png_file_path)
// Other formats
// decode(from_heif: String) -> RGBA64 (Value)
// decode(from_jpeg: String) -> RGBA64 (Value)
// decode(from_webp: String) -> RGBA64 (Value)

// Or use a generic decode function:
var rgba64_2 = Decoder.decode(from: image_file_path)
```

Encode an image:
```swift
import txt
Encoder.encode(to_webp: String, raw: RGBA64, quality: Float)
// To perform lossless encoding
Encoder.encode(to_webp: String, raw: RGBA64, is_lossless: true)
```

**RGBA64** is an intermediate structure used to store raw RGBA data, and it includes an array of 64-bit unsigned integers. The four color components, R, G, B, and A, are stored in the lowest 16 bits, the second 16 bits, the third 16 bits, and the highest 16 bits of each 64-bit integer, respectively.
Note that in this storage format, color components are not remapped. For example, an 8-bit color value of 255 is stored as a 16-bit unsigned integer value of 255, not 65535.

## Using ImageCodec in your project

To use this package in a SwiftPM project, you need to set it up as a package dependency:
```swift
// swift-tools-version:5.8
import PackageDescription

let package = Package(
  name: "MyPackage",
  dependencies: [
    .package(url: "https://github.com/fang-ling/image-codec", from: "0.0.9"),
  ],
  targets: [
    .target(
      name: "MyTarget",
      dependencies: [
        .product(name: "txt", package: "image-codec"),
      ]
    )
  ]
)
```

## Building image-codec

### Build Requirements

#### All Systems

  - [Homebrew](https://brew.sh): The Missing Package Manager for macOS (or Linux)
  - Install `jpeg-turbo`, `libheif`, `webp` and `pkg-config`

```shell
brew install jpeg-turbo libheif webp pkg-config
```

#### macOS

  - Xcode 14.3

#### Linux

  - A Swift toolchain from [swift.org](https://swift.org) or install via [Homebrew](https://brew.sh):

```shell
brew install swift
```

### Build Procedure

```shell
cd image-codec
swift build
```

### Linux post-build

Fix the missing shared object (to be continued)
