//
//  webp.swift
//
//
//  Created by Fang Ling on 2023/6/2.
//

import CWebP
import Foundation

extension Decoder {
    @inlinable public static func decode(from_webp webp : String) -> RGBA64 {
        /* Read the WebP file into memory. */
        guard let webp_file = fopen(webp, "rb") else {
            fatalError("opening input file")
        }
        if fseek(webp_file, 0, SEEK_END) < 0 { /* seek to end */
            fatalError("determining input file size")
        }
        let webp_size = ftell(webp_file) /* get file size */
        if webp_size <= 0 {
            fatalError("determining input file size")
        }
        if fseek(webp_file, 0, SEEK_SET) < 0 { /* seek back */
            fatalError("determining input file size")
        }
        let webp_buf = UnsafeMutablePointer<UInt8>.allocate(capacity: webp_size)
        if fread(webp_buf, webp_size, 1, webp_file) < 1 {
            fatalError("reading input file")
        }
        fclose(webp_file)

        var width : CInt = 0
        var height : CInt = 0
        if WebPGetInfo(webp_buf, webp_size, &width, &height) == 0 {
            fatalError("WebPGetInfo")
        }
        guard let _rgba32 =
                WebPDecodeRGBA(
                  webp_buf,
                  webp_size,
                  &width,
                  &height
                ) else {
            fatalError("WebPDecodeRGBA")
        }
        let rgba32 =
          UnsafeBufferPointer(
            start: _rgba32,
            count: Int(width * height * 4)
          ).map { $0 }

        let RGBA64 =
          RGBA64(
            width: Int(width),
            height: Int(height),
            rgba32: rgba32
          )

        webp_buf.deallocate()
        WebPFree(_rgba32)

        return RGBA64
    }
}
