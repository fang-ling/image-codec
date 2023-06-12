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
 * An alpha value of zero represents full transparency.
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
 *
 * NOTICE: RGBA64 is a pure storage type. Just leave the color data as is. i.e.
 * 8, 10, 12, 16-bits store in the portion of UInt64 without remapping.
 */

public typealias Color = UInt16
public typealias RGBA64Pixel = UInt64

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

    @inlinable public init(
      red : Color,
      green : Color,
      blue : Color,
      alpha : Color
    ) {
        let r = UInt64(red)
        let g = UInt64(green)
        let b = UInt64(blue)
        let α = UInt64(alpha)
        self = (α << 48) + (b << 32) + (g << 16) + r
    }
}

public struct RGBA64 : Equatable {
    public var pixels : [RGBA64Pixel]
    public var width : Int
    public var height : Int

    @inlinable
    public init(width : Int, height : Int) {
        self.width = width
        self.height = height
        pixels = [RGBA64Pixel]()
    }

    /* RGBA32 -> RGBA64 */
    @inlinable
    public init(
      width : Int,
      height : Int,
      rgba32 : [UInt8]
    ) {
        self.init(
          width: width,
          height: height
        )
        /* In the order R, G, B, A */
        for i in stride(from: 0, to: rgba32.count, by: 4) {
            pixels.append(
              RGBA64Pixel(
                red: Color(rgba32[i]),
                green: Color(rgba32[i + 1]),
                blue: Color(rgba32[i + 2]),
                alpha: Color(rgba32[i + 3])
              )
            )
        }
    }

    /*
     * Grayscale16 -> RGBA64
     * R = G = B = gray value
     */
    @inlinable
    public init(grayscale16 : Grayscale16) {
        width = grayscale16.width
        height = grayscale16.height
        pixels = grayscale16.pixels.map {
            RGBA64Pixel(red: $0, green: $0, blue: $0, alpha: 0xFFFF)
        }
    }

    /*
     * Returns RGBA image samples in [r0, g0, b0, a0, r1, g1, b1, a1, ...]
     * order.
     */
    public func to_rgba32() -> [UInt8] {
        var result = [UInt8]()
        for pixel in pixels {
            result.append(UInt8(truncatingIfNeeded: pixel.red()))
            result.append(UInt8(truncatingIfNeeded: pixel.green()))
            result.append(UInt8(truncatingIfNeeded: pixel.blue()))
            result.append(UInt8(truncatingIfNeeded: pixel.alpha()))
        }
        return result
    }
}
