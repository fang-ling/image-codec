//
//  pngTests.swift
//
//
//  Created by Fang Ling on 2023/5/31.
//

import Foundation
import XCTest
@testable import txt

final class pngTests: XCTestCase {
    /*
     * Base64 encoded png file of the flag of R.O.C. (1912-1928)
     * Width: 8
     * Height: 5
     */
    let img1 =
      """
      iVBORw0KGgoAAAANSUhEUgAAAAgAAAAFCAIAAAD38zoCAAAAumVYSWZNTQAqAAAACAAGARIA
      AwAAAAEAAQAAARoABQAAAAEAAABWARsABQAAAAEAAABeASgAAwAAAAEAAgAAATEAAgAAABUA
      AABmh2kABAAAAAEAAAB8AAAAAAAAAEgAAAABAAAASAAAAAFQaXhlbG1hdG9yIFBybyAzLjMu
      NQAAAAOQBAACAAAAFAAAAKagAgAEAAAAAQAAAAigAwAEAAAAAQAAAAUAAAAAMjAyMzowNToy
      OSAxMDozODo0OAAa/VfFAAAACXBIWXMAAAsTAAALEwEAmpwYAAADrmlUWHRYTUw6Y29tLmFk
      b2JlLnhtcAAAAAAAPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0
      az0iWE1QIENvcmUgNi4wLjAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cu
      dzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0
      aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRv
      YmUuY29tL3RpZmYvMS4wLyIKICAgICAgICAgICAgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRv
      YmUuY29tL3hhcC8xLjAvIgogICAgICAgICAgICB4bWxuczpleGlmPSJodHRwOi8vbnMuYWRv
      YmUuY29tL2V4aWYvMS4wLyI+CiAgICAgICAgIDx0aWZmOllSZXNvbHV0aW9uPjcyMDAwMC8x
      MDAwMDwvdGlmZjpZUmVzb2x1dGlvbj4KICAgICAgICAgPHRpZmY6WFJlc29sdXRpb24+NzIw
      MDAwLzEwMDAwPC90aWZmOlhSZXNvbHV0aW9uPgogICAgICAgICA8dGlmZjpSZXNvbHV0aW9u
      VW5pdD4yPC90aWZmOlJlc29sdXRpb25Vbml0PgogICAgICAgICA8dGlmZjpPcmllbnRhdGlv
      bj4xPC90aWZmOk9yaWVudGF0aW9uPgogICAgICAgICA8eG1wOkNyZWF0b3JUb29sPlBpeGVs
      bWF0b3IgUHJvIDMuMy41PC94bXA6Q3JlYXRvclRvb2w+CiAgICAgICAgIDx4bXA6Q3JlYXRl
      RGF0ZT4yMDIzLTA1LTI5VDEwOjM4OjQ4KzA4OjAwPC94bXA6Q3JlYXRlRGF0ZT4KICAgICAg
      ICAgPHhtcDpNZXRhZGF0YURhdGU+MjAyMy0wNS0zMVQxNzozODo1NCswODowMDwveG1wOk1l
      dGFkYXRhRGF0ZT4KICAgICAgICAgPGV4aWY6UGl4ZWxYRGltZW5zaW9uPjg8L2V4aWY6UGl4
      ZWxYRGltZW5zaW9uPgogICAgICAgICA8ZXhpZjpQaXhlbFlEaW1lbnNpb24+NTwvZXhpZjpQ
      aXhlbFlEaW1lbnNpb24+CiAgICAgIDwvcmRmOkRlc2NyaXB0aW9uPgogICA8L3JkZjpSREY+
      CjwveDp4bXBtZXRhPgqirpENAAAAIklEQVQImWO8Ly3EgA0w/j+GVZyBkSl5Lg4d//9j14IL
      AAAKWgbVpPdLggAAAABJRU5ErkJggg==
      """.components(separatedBy: .newlines).joined()

    func test_decode() throws {
        /* Write image to temp file */
        let file = fopen("img1.png", "wb")
        let data = Data(base64Encoded: img1)!
        data.withUnsafeBytes { ptr in
            let bytes = ptr.bindMemory(to: UInt8.self).baseAddress!
            fwrite(bytes, data.count, 1, file)
        }
        fclose(file)

        let result = Decoder.decode(from_png: "img1.png")
        var example = RGBA64(width: 8, height: 5)
        /* Red */
        for _ in 0 ..< 8 {
            example.pixels.append(
              RGBA64Pixel(red: 223, green: 27, blue: 18, alpha: 255)
            )
        }
        /* Yellow */
        for _ in 0 ..< 8 {
            example.pixels.append(
              RGBA64Pixel(red: 255, green: 198, blue: 0, alpha: 255)
            )
        }
        /* Blue */
        for _ in 0 ..< 8 {
            example.pixels.append(
              RGBA64Pixel(red: 2, green: 99, blue: 157, alpha: 255)
            )
        }
        /* White */
        for _ in 0 ..< 8 {
            example.pixels.append(
              RGBA64Pixel(red: 255, green: 255, blue: 255, alpha: 255)
            )
        }
        /* Black */
        for _ in 0 ..< 8 {
            example.pixels.append(
              RGBA64Pixel(red: 0, green: 0, blue: 0, alpha: 255)
            )
        }
        XCTAssertEqual(example, result)

        /* Remove temp file */
        try! FileManager.default.removeItem(atPath: "img1.png")
    }
}
