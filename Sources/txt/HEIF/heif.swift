//
//  heif.swift
//
//
//  Created by Fang Ling on 2023/6/1.
//

import CHEIF
import Foundation

extension Decoder {
    @inlinable public static func decode(from_heif heif : String) -> RGBA64 {
        let ctx = heif_context_alloc()
        heif_context_read_from_file(ctx, heif, nil)

        /* Get a handle to the primary image */
        var handle : OpaquePointer?
        heif_context_get_primary_image_handle(ctx, &handle)

        /*
         * Decode the image and convert colorspace to RGBA, saved as 32bit
         * interleaved.
         */
        var img : OpaquePointer?
        heif_decode_image(
          handle,
          &img,
          heif_colorspace_RGB,
          heif_chroma_interleaved_RGBA,
          nil
        )

        let width = Int(heif_image_handle_get_width(handle))
        let height = Int(heif_image_handle_get_height(handle))

        var stride : CInt = 0
        guard let row_rgba32 =
                heif_image_get_plane_readonly(
                  img,
                  heif_channel_interleaved,
                  &stride
                ) else {
            fatalError("heif_image_get_plane_readonly")
        }

        var rgba32 = [UInt8]()
        for y in 0 ..< height {
            rgba32 +=
              UnsafeBufferPointer(
                start: row_rgba32.advanced(by: y * Int(stride)),
                count: Int(stride / 8)
              ).map { $0 }
        }

        /* clean up resources */
        heif_image_release(img)
        heif_image_handle_release(handle)
        heif_context_free(ctx)

        return RGBA64(width: width, height: height, rgba32: rgba32)
    }
}
