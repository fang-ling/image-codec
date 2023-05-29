//
//  png.swift
//
//
//  Created by Fang Ling on 2023/5/29.
//

import CPNG
import Foundation

extension Decoder {
    @inlinable public static func decode(from_png png : String) {
        //guard let png_file = fopen(png, "rb") else {
        //    fatalError("opening input file")
        //}
        //let png_check_bytes = 8
        var image = png_image()
        memset(&image, 0, MemoryLayout<png_image>.size)
        image.version = UInt32(PNG_IMAGE_VERSION)
    }
}
