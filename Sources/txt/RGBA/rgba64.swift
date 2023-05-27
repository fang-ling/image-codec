//
//  rgba64.swift
//
//
//  Created by Fang Ling on 2023/5/27.
//

/*
 * RGBA64 is an RGBA video format where each pixel of the image contains two
 * bytes for each of the R (red), G (green), B (blue) and A (alpha) components
 * in successive places of memory.
 * An alpha value of zero represents full transparency, and a value of
 * `(2**16)-1=65535` represents a fully opaque pixel.
 *
 *    low memory address    ---->      high memory address
 *    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1    (bits)
 *  0 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+ -\
 *    |            Red                |          Green                |   \
 *    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+  pixel
 *    |            Blue               |          Alpha                |   /
 *  8 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+ -/
 *    |            Red                |          Green                |
 *    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *    |            Blue               |          Alpha                |
 * 16 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *  ↑ |                             ......                            |
 *  |
 *  \- (bytes)
 *
 *   That is: RGBA64 = [UInt64] and each pixel has type UInt64 with 16-bit
 *   groups representing R, G, B, A from the least significant bit to the most
 *   significant bit, respectively.
 */

public typealias Color = UInt16
public typealias RGBA64Pixel = UInt64
public typealias RGBA64 = [RGBA64Pixel]

extension RGBA64Pixel {
    @inlinable public func red() -> Color {
        return UInt16(truncatingIfNeeded: self & 0xFFFF)
    }

    @inlinable public func green() -> Color {
        return UInt16(truncatingIfNeeded: (self >> 16) & 0xFFFF)
    }

    @inlinable public func blue() -> Color {
        return UInt16(truncatingIfNeeded: (self >> 32) & 0xFFFF)
    }

    @inlinable public func alpha() -> Color {
        return UInt16(truncatingIfNeeded: (self >> 48) & 0xFFFF)
    }
}
