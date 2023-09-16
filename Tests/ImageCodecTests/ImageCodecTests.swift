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
        let (pixels, metadata) = image_decode(file_path: "Images/bi-0-1.png")
        if pixels == nil || metadata == nil {
            fatalError("unable to decode image")
        }
        print(pixels!)
        image_encode_8bit(
          file_path: "output.png",
          pixels: pixels!.map{ UInt8($0>>8)},
          metadata: metadata!,
          type: UTType.png,
          quality: 1
        )
    }
}
