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
    let pixel_buf = image_decode(file_path: "Images/1.dng")
    guard let pixel_buf else {
      fatalError("unable to decode image")
    }
    image_encode(file_path: "output.png", pixel_buffer: pixel_buf, quality: 1)
  }
  
  func test_convert() {
    image_convert(from: "Images/1.dng", to: "2.heic", quality: 1)
  }
}
