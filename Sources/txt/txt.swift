//
//  txt.swift
//
//
//  Created by Fang Ling on 2023/6/1.
//

import Foundation

public struct Decoder {
    @inlinable public static func decode(from file : String) -> RGBA64? {
        let lc = file.lowercased()
        if lc.hasSuffix(".jpeg") || lc.hasSuffix(".jpg") {
            return decode(from_jpeg: file)
        } else if lc.hasSuffix(".png") {
            return decode(from_png: file)
        } else if lc.hasSuffix(".heif") || lc.hasSuffix(".heic") {
            return decode(from_heif: file)
        } else if lc.hasSuffix(".webp") {
            return decode(from_webp: file)
        } else { /* Currently unsupported */
            return nil
        }
    }
}

public struct Encoder { }
