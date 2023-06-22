//
//  BMP.swift
//
//
//  Created by Fang Ling on 2023/6/20.
//

/*
 * The BMP File Format
 */
struct BMPHeader { /* 14 bytes */
    var signature : UInt16   /* 'BM' (=0x424D) */
    var file_size : UInt32   /* File size in bytes */
    var reserved : UInt32    /* unused (=0) */
    /* Offset from beginning of the file to the beginning of the bitmap data */
    var data_offset : UInt32
}

struct BMPInfoHeader { /* 40 bytes */
    var size : UInt32           /* Size of InfoHeader (=40) */
    var width : UInt32          /* Horizontal width of bitmap in pixels */
    var height : UInt32         /* Vertical height of bitmap in pixels */
    var planes : UInt16         /* Number of Planes (=1) */
    /*
     * Bits per Pixel used to store palette entry information. This also
     * identifies in an indirect way the number of possible colors.
     * Possible values are:
     *    1 = monochrome palette. NumColors = 1
     *    4 = 4bit palletized. NumColors = 16
     *    8 = 8bit palletized. NumColors = 256
     *   16 = 16bit RGB. NumColors = 65536
     *   24 = 24bit RGB. NumColors = 16M
     */
    var bits_per_pixel : UInt16
    /*
     * Type of Compression
     *   0 = BI_RGB   no compression
     *   1 = BI_RLE8 8bit RLE encoding
     *   2 = BI_RLE4 4bit RLE encoding
     */
    var compression : UInt32
    /*
     * (compressed) Size of Image
     * It is valid to set this = 0 if Compression = 0
     */
    var image_size : UInt32
    var x_pixels_per_m : UInt32   /* horizontal resolution: Pixels/meter */
    var y_pixels_per_m : UInt32   /* vertical resolution: Pixels/meter */
    /*
     * Number of actually used colors.
     * For a 8-bit / pixel bitmap this will be 0x100 or 256.
     */
    var colors_used : UInt32
    var important_colors : UInt32 /* Number of important colors (0 = all) */
}
