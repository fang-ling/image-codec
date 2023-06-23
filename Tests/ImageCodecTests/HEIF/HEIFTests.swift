//
//  HEIFTests.swift
//
//
//  Created by Fang Ling on 2023/6/2.
//

import Foundation
import ImageIntermedia
import XCTest
@testable import ImageCodec

final class HEIFTests : XCTestCase {
    func test_decode() throws {
        Encoder.encode(
          to_webp: "heic.heic",
          raw: Decoder.decode(
            from_heif: "Images/heic_without_ext_name"
          )
        )
    }

    func test_decode_depth() throws {
        guard let depth = Decoder.decode_depth(
                from_heif: "Images/test-object-capture.HEIC"
              ) else {
            fatalError("The image contains no depth map data.")
        }
        Encoder.encode(
          to_webp: "depth_map.webp",
          raw: depth,
          is_lossless: true
        )
        guard let rgb = Decoder.decode(
                from: "Images/test-object-capture.HEIC"
              ) else {
            fatalError()
        }
        Encoder.encode(
          to_webp: "1.webp",
          raw: rgb,
          is_lossless: true
        )
    }
}
