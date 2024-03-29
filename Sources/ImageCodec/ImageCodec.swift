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

/* 
 * Configuring parameters for standardizing images.
 *   four-channel
 *   8-bit-per-channel
 *   sRGB
 *   ARGB planar with A = 255
 */
let BITS_PER_COMPONENT = 8
let COMPONENT_COUNT = 4
let COLOR_SPACE = CGColorSpace(name: CGColorSpace.sRGB)!
let BITMAP_INFO=CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue)

public struct PixelBuffer {
  public var width : Int
  public var height : Int
  public var bits_per_component = BITS_PER_COMPONENT
  public var component_count = COMPONENT_COUNT
  public var color_space = COLOR_SPACE
  public var bitmap_info = BITMAP_INFO
  public var properties : CFDictionary?

  /*
   * Each component comprises a monochrome matrix consisting of `height`
   * multiplied by `width` pixels. The matrix is stored in row-major order.
   */
  public var components : [[UInt8]]

  public init(width: Int, height: Int, properties: CFDictionary?) {
    self.width = width
    self.height = height
    self.properties = properties
    
    components = [[UInt8]](repeating: [UInt8](), count: bits_per_component)
  }
}

/*
 * Reads image data from a file and convert it into a four-channel,
 * 8-bit-per-channel ARGB planar pixel buffer.
 *
 * Metadata are copied.
 */
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
    /* Create the Source and Destination Image Formats */
    let (src_buf, src_format) =
      try vImage.PixelBuffer.makeDynamicPixelBufferAndCGImageFormat(
        cgImage: cg_img
      )
    guard let dst_format = vImage_CGImageFormat(
      bitsPerComponent: BITS_PER_COMPONENT,
      bitsPerPixel: BITS_PER_COMPONENT * COMPONENT_COUNT,
      colorSpace: COLOR_SPACE,
      bitmapInfo: BITMAP_INFO
    ) else {
      print("unable to initialize cgImageformat")
      return nil
    }
    /* Create the Destination Buffers */
    let dst_buf = vImage.PixelBuffer<vImage.Interleaved8x4>(size: src_buf.size)
    /* Perform the conversion */
    let converter = try
      vImageConverter.make(
        sourceFormat: src_format,
        destinationFormat: dst_format
      )
    try converter.convert(from: src_buf, to: dst_buf)
    
    var pixel_buf =
      PixelBuffer.init(
        width: cg_img.width,
        height: cg_img.height,
        properties: properties
      )
    /* Split interleaved buffer */
    var planar_bufs = [vImage.PixelBuffer<vImage.Planar8>]()
    for _ in 0 ..< COMPONENT_COUNT {
      planar_bufs.append(
        vImage.PixelBuffer(
          size: dst_buf.size,
          pixelFormat: vImage.Planar8.self
        )
      )
    }
    dst_buf.deinterleave(planarDestinationBuffers: planar_bufs)
    for i in 0 ..< COMPONENT_COUNT {
      pixel_buf.components[i] = planar_bufs[i].array
    }
    return pixel_buf
  } catch {
    print(error)
    return nil
  }
}

/*
 * quality: A value of 1.0 specifies to use lossless compression if destination
 * format supports it. A value of 0.0 implies to use maximum compression.
 */
public func image_encode(
  file_path: String,
  pixel_buffer: PixelBuffer,
  quality: Float
) {
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
  /* Create interleaved buffer */
  let buf = vImage.PixelBuffer<vImage.Interleaved8x4>(
    width: pixel_buffer.width,
    height: pixel_buffer.height
  )
  var planar_bufs = [vImage.PixelBuffer<vImage.Planar8>]()
  for i in 0 ..< COMPONENT_COUNT {
    planar_bufs.append(
      vImage.PixelBuffer<vImage.Planar8>(
        pixelValues: pixel_buffer.components[i],
        size: buf.size
      )
    )
  }
  buf.interleave(planarSourceBuffers: planar_bufs)
  /* Create CGImage */
  guard let cg_img = buf.makeCGImage(cgImageFormat: format) else {
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

@inlinable
public func image_convert(
  from ipath : String,
  to opath : String,
  quality : Float
) {
  /* Create CGImageSource */
  guard let src = CGImageSourceCreateWithURL(
    URL(filePath: ipath) as CFURL,
    nil
  ) else {
    fatalError("unable to create CGImageSource")
  }
  /* Retrieve image metadata */
  let properties = CGImageSourceCopyPropertiesAtIndex(src, 0, nil)
  /* Create CGImage */
  guard let cg_img = CGImageSourceCreateImageAtIndex(src, 0, nil) else {
    fatalError("unable to create CGImage")
  }
  /* Create CGImageDestination */
  var o_properties : [CFString : Any] = [:]
  if properties != nil {
    o_properties = (properties as? [CFString : Any])!
  }
  let type =
    UTType(
      filenameExtension: opath.components(separatedBy: ".").last!
    )!
  o_properties[kCGImageDestinationLossyCompressionQuality] = quality
  guard let dst = CGImageDestinationCreateWithURL(
    URL(filePath: opath) as CFURL,
    type.identifier as CFString,
    1,
    nil
  ) else {
    print("unable to create CGImageDestination")
    return
  }
  CGImageDestinationAddImage(dst, cg_img, o_properties as CFDictionary)
  CGImageDestinationFinalize(dst)
}
