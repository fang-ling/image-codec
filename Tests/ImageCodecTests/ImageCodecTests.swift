//
//  ImageCodecTests.swift
//
//
//  Created by Fang Ling on 2023/6/21.
//

import XCTest
import ImageIO
import UniformTypeIdentifiers
@testable import ImageCodec

final class ImageCodecTests : XCTestCase {
  func test_example() {
    let pixel_buf = image_decode(file_path: "/tmp/1.cr2")
    guard let pixel_buf else {
      fatalError("unable to decode image")
    }
    image_encode(file_path: "/tmp/1.png", pixel_buffer: pixel_buf, quality: 1)
    image_encode(file_path: "/tmp/1.heic", pixel_buffer: pixel_buf, quality: 1)
  }
  
  func test_convert() {
    image_convert(from: "/tmp/1.dng", to: "2.heic", quality: 1)
  }
}
