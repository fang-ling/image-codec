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
        let format = ["dng", "png"]
        for i in format {
            let (pixels, metadata) = image_decode(file_path: "Images/input.\(i)")
            if pixels == nil || metadata == nil {
                fatalError("unable to decode image")
            }
            /* Get supported output format */
            let array = CGImageDestinationCopyTypeIdentifiers() as! [String]
            for type_str in array {
                if let type = UTType(type_str) {
                    image_encode(
                      file_path: "output-\(i).\(type.preferredFilenameExtension!)",
                      pixels: pixels!,
                      metadata: metadata!,
                      type: type,
                      quality: 1
                    )
                } else {
                    print("convert \(type_str) to UTType is not supported.")
                }
            }
        }
    }
}
