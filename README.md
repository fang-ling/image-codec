## Building image-codec

### Build Requirements

#### All Systems

  - [Homebrew](https://brew.sh): The Missing Package Manager for macOS (or Linux)
  - Install `jpeg-turbo`, `libpng` and `pkg-config`

```shell
brew install jpeg-turbo libpng pkg-config
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
