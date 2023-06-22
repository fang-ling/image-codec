//
//  heif.swift
//
//
//  Created by Fang Ling on 2023/6/1.
//

import CHEIF
import Foundation
import ImageIntermedia

extension Decoder {
    @inlinable
    public static func decode(from_heif heif : String) -> RGBA64 {
        guard let ctx = heif_context_alloc() else {
            fatalError("Could not create context object.")
        }
        var err = heif_context_read_from_file(ctx, heif, nil)
        if err.code != heif_error_code(0) {
            fatalError("Could not read HEIF/AVIF file: \(err.message!)")
        }

        /* TODO: Note that num_of_images > 1 is currently not handled */
        let num_of_images = heif_context_get_number_of_top_level_images(ctx)
        if num_of_images == 0 {
            fatalError("File doesn't contain any images")
        }

        /* Get a handle to the primary image */
        var handle : OpaquePointer?
        err = heif_context_get_primary_image_handle(ctx, &handle)
        if err.code != heif_error_code(0) {
            fatalError("Could not read HEIF/AVIF image \(err.message!)")
        }

        /*
         * Decode the image and convert colorspace to RGBA, saved as 32bit
         * interleaved.
         */
        var img : OpaquePointer?
        err = heif_decode_image(
          handle,
          &img,
          heif_colorspace_RGB,
          heif_chroma_interleaved_RGBA,
          nil
        )
        if err.code != heif_error_code(0) {
            fatalError("Could not decode image \(err.message!)")
        }

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

    @inlinable
    public static func decode_depth(from_heif heif : String) -> Grayscale16? {
        guard let ctx = heif_context_alloc() else {
            fatalError("Could not create context object.")
        }
        var err = heif_context_read_from_file(ctx, heif, nil)
        if err.code != heif_error_code(0) {
            fatalError("Could not read HEIF/AVIF file: \(err.message!)")
        }

        /* TODO: Note that num_of_images > 1 is currently not handled */
        let num_of_images = heif_context_get_number_of_top_level_images(ctx)
        if num_of_images == 0 {
            fatalError("File doesn't contain any images")
        }

        /* Get a handle to the primary image */
        var handle : OpaquePointer?
        err = heif_context_get_primary_image_handle(ctx, &handle)
        if err.code != heif_error_code(0) {
            fatalError("Could not read HEIF/AVIF image \(err.message!)")
        }

        if heif_image_handle_has_depth_image(handle) != 0 {
            var depth_id = heif_item_id()
            let n_depth_images = heif_image_handle_get_list_of_depth_image_IDs(
              handle,
              &depth_id,
              1
            )
            assert(n_depth_images == 1)

            var depth_handle : OpaquePointer?
            err = heif_image_handle_get_depth_image_handle(
              handle,
              depth_id,
              &depth_handle
            )
            if err.code != heif_error_Ok {
                fatalError("Could not read depth channel: \(err.message!)")
            }

            var depth_image : OpaquePointer?
            err = heif_decode_image(
              depth_handle,
              &depth_image,
              heif_colorspace_monochrome,
              heif_chroma_monochrome,
              nil
            )
            if err.code != heif_error_Ok {
                fatalError("Could not decode depth image: \(err.message!)")
            }

            let width = Int(heif_image_handle_get_width(handle))
            let height = Int(heif_image_handle_get_height(handle))

            var stride : CInt = 0
            guard let row_grayscale16 =
                    heif_image_get_plane_readonly(
                      depth_image,
                      heif_channel_interleaved,
                      &stride
                    ) else {
                fatalError("heif_image_get_plane_readonly")
            }

            var grayscale8 = [UInt8]()
            for y in 0 ..< height {
                grayscale8 +=
                  UnsafeBufferPointer(
                    start: row_grayscale16.advanced(by: y * Int(stride)),
                    count: Int(stride / 8)
                  ).map { $0 }
            }

            var grayscale16 = Grayscale16(width: width, height: height)
            grayscale16.pixels = grayscale8.map { Color($0) }

            return grayscale16
            /* clean up resources */
            //heif_image_release(img)
            //heif_image_handle_release(handle)
            //heif_context_free(ctx)
        } else { /* Image does not have depth map */
            return nil
        }
    }
}
