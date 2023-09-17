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

public struct PixelBuffer {
  public var width : Int
  public var height : Int
  public var bits_per_component : Int
  public var component_count : Int
  public var color_space : CGColorSpace
  public var bitmap_info : CGBitmapInfo
  public var properties : CFDictionary?

  public var array : [UInt8]
  public var array_16 : [UInt16]

  public init(
    width: Int,
    height: Int,
    bits_per_component: Int,
    component_count: Int,
    color_space: CGColorSpace,
    bitmap_info: CGBitmapInfo,
    properties: CFDictionary?
  ) {
    self.width = width
    self.height = height
    self.bits_per_component = bits_per_component
    self.component_count = component_count
    self.color_space = color_space
    self.bitmap_info = bitmap_info
    self.properties = properties
    
    array = []
    array_16 = []
  }
}

/// Reads image data from a file path into RGB(A) interleaved buffer.
@inlinable
public func image_decode(file_path: String) -> PixelBuffer? {
  /* Create CGImageSource */
  guard let src = CGImageSourceCreateWithURL(
    URL(filePath: file_path) as CFURL,
    nil
  ) else {
    print("unable to create CGImageSource")
    return nil
  }
  /* Retrieve image metadata */
  let properties = CGImageSourceCopyPropertiesAtIndex(src, 0, nil)
  /* Create CGImage */
  guard let cg_img = CGImageSourceCreateImageAtIndex(src, 0, nil) else {
    print("unable to create CGImage")
    return nil
  }
  /* Create vImage_PixelBuffer */
  do {
    let (buf, format) =
      try vImage.PixelBuffer.makeDynamicPixelBufferAndCGImageFormat(
        cgImage: cg_img
      )
    print(cg_img)
    var pixel_buf =
      PixelBuffer.init(
        width: cg_img.width,
        height: cg_img.height,
        bits_per_component: cg_img.bitsPerComponent,
        component_count: format.componentCount,
        color_space: cg_img.colorSpace!,
        bitmap_info: format.bitmapInfo,
        properties: properties
      )
    if cg_img.bitsPerComponent <= 8 {
      pixel_buf.array = buf.makeArray(
        of: UInt8.self,
        channelCount: format.componentCount
      )
    } else {
      pixel_buf.array_16 = buf.makeArray(
        of: UInt16.self,
        channelCount: format.componentCount
      )
    }
    return pixel_buf
  } catch {
    print(error)
    return nil
  }
}

/// quality: A value of 1.0 specifies to use lossless compression if destination
/// format supports it. A value of 0.0 implies to use maximum compression.
@inlinable
public func image_encode(
  file_path: String,
  pixel_buffer: PixelBuffer,
  quality: Float
) {
  var pixel_buffer = pixel_buffer
  let type =
    UTType(
      filenameExtension: file_path.components(separatedBy: ".").last!
    )!
  
  guard let format = vImage_CGImageFormat(
    bitsPerComponent: pixel_buffer.bits_per_component,
    bitsPerPixel: pixel_buffer.bits_per_component*pixel_buffer.component_count,
    colorSpace: pixel_buffer.color_space,
    bitmapInfo: pixel_buffer.bitmap_info
  ) else {
    print("unable to create vImage_CGImageFormat")
    return
  }
  /* Create CGImage */
  var cg_img : CGImage?
  if pixel_buffer.bits_per_component <= 8 { /* Create vImage_PixelBuffer */
    let buf = vImage.PixelBuffer<vImage.Interleaved8x4>(
      data: &pixel_buffer.array,
      width: pixel_buffer.width,
      height: pixel_buffer.height
    )
    cg_img = buf.makeCGImage(cgImageFormat: format)
  } else {
    let buf = vImage.PixelBuffer<vImage.Interleaved16Ux4>(
      data: &pixel_buffer.array_16,
      width: pixel_buffer.width,
      height: pixel_buffer.height
    )
    cg_img = buf.makeCGImage(cgImageFormat: format)
  }
  guard let cg_img else {
    print("unable to make CGImage from vImage_Buffer")
    return
  }
  /* Create CGImageDestination */
  var properties : [CFString : Any] = [:]
  if pixel_buffer.properties != nil {
    properties = (pixel_buffer.properties as? [CFString : Any])!
  }
  properties[kCGImageDestinationLossyCompressionQuality] = quality
  guard let dst = CGImageDestinationCreateWithURL(
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
