//
//  png.swift
//
//
//  Created by Fang Ling on 2023/5/29.
//

import PNG
import Foundation
import ImageIntermedia

extension Decoder {
    @inlinable public static func decode(from_png png : String) -> RGBA64? {
        do {
            guard let image : PNG.Data.Rectangular = try .decompress(
                    path: png
                  ) else {
                fatalError("reading png file")
            }
            let _rgba32 : [PNG.RGBA<UInt8>] = image.unpack(
              as: PNG.RGBA<UInt8>.self
            )
            var rgba32 = [UInt8]()
            for pixel in _rgba32 {
                rgba32.append(pixel.r)
                rgba32.append(pixel.g)
                rgba32.append(pixel.b)
                rgba32.append(pixel.a)
            }
            let size = image.size
            return RGBA64(width: size.x, height: size.y, rgba32: rgba32)
        } catch {
            print("error decompress png file: \(png)")
            return nil
        }
    }
}
