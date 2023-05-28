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
        /* Note that alpha = Int( * 0.8) = 52428 */
        let violet =
          RGBA64Pixel(
            red: 155,
            green: 38,
            blue: 182,
            alpha: Color(0.8 * 256)
          )
        XCTAssertEqual(violet.red(), 155)
        XCTAssertEqual(violet.green(), 38)
        XCTAssertEqual(violet.blue(), 182)
        XCTAssertEqual(violet.alpha(), 204)
    }
}
