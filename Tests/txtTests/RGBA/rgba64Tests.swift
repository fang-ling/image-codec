//
//  rgba64Tests.swift
//
//
//  Created by Fang Ling on 2023/5/27.
//

import XCTest
@testable import txt

final class rgba64Tests: XCTestCase {
    func testRGBA64() {
        /* Violet with opacity 0.8: rgba(155, 38, 182, 0.8) */
        /* Note that alpha = Int(65536 * 0.8) = 52428 */
        let violet : RGBA64Pixel =
        /* |      alpha     |      blue      |      green     |      red      */
          0b1100110011001100_0000000010110110_0000000000100110_0000000010011011
        XCTAssertEqual(violet.red(), 155)
        XCTAssertEqual(violet.green(), 38)
        XCTAssertEqual(violet.blue(), 182)
        XCTAssertEqual(violet.alpha(), 52428)
    }
}
