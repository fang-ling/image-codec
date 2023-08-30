//
//  ImageCodec.swift
//
//
//  Created by Fang Ling on 2023/6/1.
//

import Accelerate
import Foundation
import ImageIO
import UniformTypeIdentifiers

@usableFromInline
let MAXIMUM_BPC = 16

public struct ImageFormat {
    public var color_space: CGColorSpace
    public var width : Int
    public var height : Int

    public init(color_space : CGColorSpace, width : Int, height : Int) {
        self.color_space = color_space
        self.width = width
        self.height = height
    }
}

/// Reads image data from a file path into a four-channel, 16-bit-per-channel
/// RGBA interleaved buffer.
@inlinable
public func image_decode(file_path: String) -> ([UInt16]?, ImageFormat?) {
    /* Create CGImageSource */
    guard
      let src = CGImageSourceCreateWithURL(
        URL(filePath: file_path) as CFURL,
        nil
      ) else {
        print("unable to create CGImageSource")
        return (nil, nil)
    }
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
          ImageFormat(
            color_space: color_space,
            width: cg_img.width,
            height: cg_img.height
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
  format: ImageFormat,
  type: UTType,
  quality: Float
) {
    /* Create vImage_PixelBuffer */
    var pixels = pixels
    let buf = vImage.PixelBuffer<vImage.Interleaved16Ux4>(
      data: &pixels,
      width: format.width,
      height: format.height
    )
    /* Set output format */
    guard
      let vformat = vImage_CGImageFormat(
        bitsPerComponent: MAXIMUM_BPC,
        bitsPerPixel: MAXIMUM_BPC * 4,
        colorSpace: format.color_space,
        bitmapInfo: .init(rawValue: CGImageAlphaInfo.last.rawValue)
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
    let prop = [
      kCGImageDestinationLossyCompressionQuality : quality
    ] as CFDictionary
    guard
      let dst =
        CGImageDestinationCreateWithURL(
          URL(filePath: file_path) as CFURL,
          type.identifier as CFString,
          1,
          prop
      ) else {
        print("unable to create CGImageDestination")
        return
    }
    CGImageDestinationAddImage(dst, cg_img, nil)
    CGImageDestinationFinalize(dst)
}
