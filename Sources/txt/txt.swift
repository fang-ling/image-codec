//
//  txt.swift
//
//
//  Created by Fang Ling on 2023/6/1.
//

import Foundation

public struct Decoder {
    /*
     * This is a list of image file signatures, data used to identify or verify
     * the content of a file.
     */
    @usableFromInline
    static let SIG : [(Int, [UInt8])] = [
      /* JPEG: offset = 0, ascii signature = '....' */
      (0, [0xff, 0xd8, 0xff, 0xe0]),
      /* HEIC: offset = 4, ascii signature = 'ftypheic' */
      (4, [0x66, 0x74, 0x79, 0x70, 0x68, 0x65, 0x69, 0x63]),
      /* PNG:  offset = 0, ascii signature = '.PNG....' */
      (0, [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]),
      /* WEBP: offset = 0, ascii signature = 'RIFF????WEBP' */
      /* ALWAYS AT LAST POSITION */
      (0, [0x52, 0x49, 0x46, 0x46, 0, 0, 0, 0, 0x57, 0x45, 0x42, 0x50])
    ]

    @inlinable
    public static func decode(from file : String) -> RGBA64? {
        guard let fd = fopen(file, "rb") else {
            print("Cannot open file: \(file)")
            return nil
        }
        /* 12 bytes stands for the longest signature (webp) */
        let signature = UnsafeMutablePointer<UInt8>.allocate(capacity: 12)
        if fread(signature, 12, 1, fd) != 1 {
            print("fread: \(file)")
            return nil
        }
        fclose(fd)
        /* Try JPEG */
        if signature[0+SIG[0].0] == SIG[0].1[0] &&
             signature[1+SIG[0].0] == SIG[0].1[1] &&
             signature[2+SIG[0].0] == SIG[0].1[2] &&
             signature[3+SIG[0].0] == SIG[0].1[3] {
            return decode(from_jpeg: file)
        } else if signature[0+SIG[1].0] == SIG[1].1[0] && /* Try HEIC */
                    signature[1+SIG[1].0] == SIG[1].1[1] &&
                    signature[2+SIG[1].0] == SIG[1].1[2] &&
                    signature[3+SIG[1].0] == SIG[1].1[3] &&
                    signature[4+SIG[1].0] == SIG[1].1[4] &&
                    signature[5+SIG[1].0] == SIG[1].1[5] &&
                    signature[6+SIG[1].0] == SIG[1].1[6] &&
                    signature[7+SIG[1].0] == SIG[1].1[7] {
            return decode(from_heif: file)
        } else if signature[0+SIG[2].0] == SIG[2].1[0] && /* Try PNG */
                    signature[1+SIG[2].0] == SIG[2].1[1] &&
                    signature[2+SIG[2].0] == SIG[2].1[2] &&
                    signature[3+SIG[2].0] == SIG[2].1[3] &&
                    signature[4+SIG[2].0] == SIG[2].1[4] &&
                    signature[5+SIG[2].0] == SIG[2].1[5] &&
                    signature[6+SIG[2].0] == SIG[2].1[6] &&
                    signature[7+SIG[2].0] == SIG[2].1[7] {
            return decode(from_png: file)
        } else if signature[0+SIG[3].0] == SIG[3].1[0] && /* Try WebP */
                    signature[1+SIG[3].0] == SIG[3].1[1] &&
                    signature[2+SIG[3].0] == SIG[3].1[2] &&
                    signature[3+SIG[3].0] == SIG[3].1[3] &&
                    signature[4+SIG[3].0+4] == SIG[3].1[4+4] &&
                    signature[5+SIG[3].0+4] == SIG[3].1[5+4] &&
                    signature[6+SIG[3].0+4] == SIG[3].1[6+4] &&
                    signature[7+SIG[3].0+4] == SIG[3].1[7+4] {
            return decode(from_webp: file)
        } else {
            print("Warning: unsupport format detected")
            return nil
        }
    }
}

public struct Encoder { }
