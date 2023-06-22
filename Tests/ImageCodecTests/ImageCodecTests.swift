//
//  ImageCodecTests.swift
//
//
//  Created by Fang Ling on 2023/6/21.
//

import XCTest
@testable import ImageCodec

final class txtTests: XCTestCase {
    func test_general_decode() {
        XCTAssertNotNil(Decoder.decode(from: "Images/heic_without_ext_name"))
        XCTAssertNotNil(Decoder.decode(from: "Images/webp_without_ext_name"))
        XCTAssertNotNil(Decoder.decode(from: "Images/jpg_without_ext_name"))
        XCTAssertNotNil(Decoder.decode(from: "Images/png_without_ext_name"))
    }
}
