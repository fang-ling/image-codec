//
//  grayscale16.swift
//
//
//  Created by Fang Ling on 2023/6/12.
//

import Foundation

public struct Grayscale16 : Equatable {
    public var pixels : [Color]
    public var width : Int
    public var height : Int

    @inlinable
    public init(width : Int, height : Int) {
        self.width = width
        self.height = height
        pixels = [Color]()
    }

    /*
     * RGBA -> Grayscale conversion (luminosity method)
     * Notice that the alpha channel is ignored.
     */
    @inlinable
    public init(rgba64 : RGBA64) {
        self.init(width: rgba64.width, height : rgba64.height)
        for c in rgba64.pixels {
            pixels.append(
              Color(
                round(
                  0.299 * Double(c.red()) +
                    0.587 * Double(c.green()) +
                    0.114 * Double(c.blue())
                )
              )
            )
        }
    }
}
