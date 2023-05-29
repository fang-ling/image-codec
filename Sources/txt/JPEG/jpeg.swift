//
//  jpeg.swift
//
//
//  Created by Fang Ling on 2023/5/27.
//

import CJPEGTurbo
import Foundation

@usableFromInline
let swiftTjPixelSize = [tjPixelSize.0, tjPixelSize.1, tjPixelSize.2,
                        tjPixelSize.3, tjPixelSize.4, tjPixelSize.5,
                        tjPixelSize.6, tjPixelSize.7, tjPixelSize.8,
                        tjPixelSize.9, tjPixelSize.10, tjPixelSize.11]

extension Decoder {
    @inlinable public static func decode(from_jpeg jpeg : String) -> RGBA64 {
        /* Read the JPEG file into memory. */
        guard let jpeg_file = fopen(jpeg, "rb") else {
            fatalError("opening input file")
        }
        if fseek(jpeg_file, 0, SEEK_END) < 0 { /* seek to end */
            fatalError("determining input file size")
        }
        let jpeg_size = ftell(jpeg_file) /* get file size */
        if jpeg_size <= 0 {
            fatalError("determining input file size")
        }
        if fseek(jpeg_file, 0, SEEK_SET) < 0 { /* seek back */
            fatalError("determining input file size")
        }
        guard let jpeg_buf = tjAlloc(CInt(jpeg_size)) else {
            fatalError("allocating JPEG buffer")
        }
        if fread(jpeg_buf, jpeg_size, 1, jpeg_file) < 1 {
            fatalError("reading input file")
        }
        fclose(jpeg_file)
        /* Parse JPEG header */
        guard let tj_instance = tjInitDecompress() else {
            fatalError("initializing decompressor")
        }
        var width : CInt = 0
        var height : CInt = 0
        var jpeg_sub_samp : CInt = 0
        var jpeg_color_space : CInt = 0
        if tjDecompressHeader3(tj_instance,
                               jpeg_buf,
                               UInt(jpeg_size),
                               &width,
                               &height,
                               &jpeg_sub_samp,
                               &jpeg_color_space) < 0 {
            fatalError("reading JPEG header")
        }
        /* decompress the JPEG data */
        let pixel_format = Int(TJPF_RGBX.rawValue)
        let bytes = width * height * swiftTjPixelSize[pixel_format]
        guard let img_buf = tjAlloc(bytes) else {
            fatalError("allocating uncompressed image buffer")
        }
        if tjDecompress2(tj_instance,
                         jpeg_buf,
                         UInt(jpeg_size),
                         img_buf,
                         width,
                         0,
                         height,
                         CInt(pixel_format),
                         0) < 0 {
            fatalError("decompressing JPEG image")
        }
        /* Convert RGBX(32) to RGBA64 */
        let pixels = UnsafeBufferPointer(start: img_buf,
                                         count: Int(bytes)).map { $0 }
        let rgba64 = RGBA64(width: Int(width),
                            height: Int(height),
                            rgba32: pixels)
        /* Cleanup */
        tjFree(jpeg_buf)
        tjFree(img_buf)
        tjDestroy(tj_instance)

        return rgba64
    }
}
