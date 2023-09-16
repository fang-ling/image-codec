//
//  ImageCodec.swift
//
//
//  Created by Fang Ling on 2023/6/1.
//

import Accelerate
//import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

@usableFromInline
let MAXIMUM_BPC = 16

public struct ImageMetadata {
    public var color_space: CGColorSpace
    public var width : Int
    public var height : Int
    public var properties : CFDictionary?

    public init(
      color_space : CGColorSpace,
      width : Int,
      height : Int,
      properties : CFDictionary? = nil
    ) {
        self.color_space = color_space
        self.width = width
        self.height = height
        self.properties = properties
    }
}

/// Reads image data from a file path into a four-channel, 16-bit-per-channel
/// RGBA interleaved buffer.
@inlinable
public func image_decode(file_path: String) -> ([UInt16]?, ImageMetadata?) {
    /* Create CGImageSource */
    guard
      let src = CGImageSourceCreateWithURL(
        URL(filePath: file_path) as CFURL,
        nil
      ) else {
        print("unable to create CGImageSource")
        return (nil, nil)
    }
    /* Retrieve image metadata */
    let properties = CGImageSourceCopyPropertiesAtIndex(src, 0, nil)
    /* Create CGImage */
    guard
      let cg_img = CGImageSourceCreateImageAtIndex(
        src,
        0,
        nil
      ) else {
        print("unable to create CGImage")
        return (nil, nil)
    }
    /* Set output format */
    var color_space : CGColorSpace
    if let cs = cg_img.colorSpace {
        color_space = cs
    } else {
        print("Warning: No color space found. Callback to Display P3.")
        color_space = CGColorSpace(name: CGColorSpace.displayP3)!
    }
    guard
      var format = vImage_CGImageFormat(
        bitsPerComponent: MAXIMUM_BPC,
        bitsPerPixel: MAXIMUM_BPC * 4,
        colorSpace: color_space,
        bitmapInfo: .init(rawValue: CGImageAlphaInfo.last.rawValue)
      ) else {
        print("unable to create vImage_CGImageFormat")
        return (nil, nil)
    }
    /* Create vImage_PixelBuffer */
    do {
        let buf = try vImage.PixelBuffer(
          cgImage: cg_img,
          cgImageFormat: &format,
          pixelFormat: vImage.Interleaved16Ux4.self
        )
        return (
          buf.array,
          ImageMetadata(
            color_space: color_space,
            width: cg_img.width,
            height: cg_img.height,
            properties: properties
          )
        )
    } catch {
        print(error.localizedDescription)
        return (nil, nil)
    }
}

/// quality: A value of 1.0 specifies to use lossless compression if destination
/// format supports it. A value of 0.0 implies to use maximum compression.
@inlinable
public func image_encode(
  file_path: String,
  pixels: [UInt16],
  metadata: ImageMetadata,
  type: UTType,
  quality: Float
) {
    /* Create vImage_PixelBuffer */
    var pixels = pixels
    let buf = vImage.PixelBuffer<vImage.Interleaved16Ux4>(
      data: &pixels,
      width: metadata.width,
      height: metadata.height
    )
    /* Set output format */
    let bitmap_info = CGBitmapInfo(
      rawValue:
        CGBitmapInfo.byteOrderDefault.rawValue |
        CGImageAlphaInfo.last.rawValue
    )
    guard
      let vformat = vImage_CGImageFormat(
        bitsPerComponent: MAXIMUM_BPC,
        bitsPerPixel: MAXIMUM_BPC * 4,
        colorSpace: metadata.color_space,
        bitmapInfo: bitmap_info
      ) else {
        print("unable to create vImage_CGImageFormat")
        return
    }
    /* Create CGImage */
    guard let cg_img = buf.makeCGImage(cgImageFormat: vformat) else {
        print("unable to make CGImage from vImage_Buffer")
        return
    }
    /* Create CGImageDestination */
    var properties : [CFString : Any] = [:]
    if metadata.properties != nil {
        properties = (metadata.properties as? [CFString : Any])!
    }
    properties[kCGImageDestinationLossyCompressionQuality] = quality
    guard
      let dst =
        CGImageDestinationCreateWithURL(
          URL(filePath: file_path) as CFURL,
          type.identifier as CFString,
          1,
          nil
      ) else {
        print("unable to create CGImageDestination")
        return
    }
    CGImageDestinationAddImage(dst, cg_img, properties as CFDictionary)
    CGImageDestinationFinalize(dst)
}

@inlinable
public func image_encode_8bit(
  file_path: String,
  pixels: [UInt8],
  metadata: ImageMetadata,
  type: UTType,
  quality: Float
) {
    /* Create vImage_PixelBuffer */
    var pixels = pixels
    let buf = vImage.PixelBuffer<vImage.Interleaved8x4>(
      data: &pixels,
      width: metadata.width,
      height: metadata.height
    )
    /* Set output format */
    let bitmap_info = CGBitmapInfo(
      rawValue:
        CGBitmapInfo.byteOrderDefault.rawValue |
        CGImageAlphaInfo.last.rawValue
    )
    guard
      let vformat = vImage_CGImageFormat(
        bitsPerComponent: MAXIMUM_BPC/2,
        bitsPerPixel: MAXIMUM_BPC * 4/2,
        colorSpace: metadata.color_space,
        bitmapInfo: bitmap_info
      ) else {
        print("unable to create vImage_CGImageFormat")
        return
    }
    /* Create CGImage */
    guard let cg_img = buf.makeCGImage(cgImageFormat: vformat) else {
        print("unable to make CGImage from vImage_Buffer")
        return
    }
    /* Create CGImageDestination */
    var properties : [CFString : Any] = [:]
    if metadata.properties != nil {
        properties = (metadata.properties as? [CFString : Any])!
    }
    properties[kCGImageDestinationLossyCompressionQuality] = quality
    guard
      let dst =
        CGImageDestinationCreateWithURL(
          URL(filePath: file_path) as CFURL,
          type.identifier as CFString,
          1,
          nil
      ) else {
        print("unable to create CGImageDestination")
        return
    }
    CGImageDestinationAddImage(dst, cg_img, properties as CFDictionary)
    CGImageDestinationFinalize(dst)
}
