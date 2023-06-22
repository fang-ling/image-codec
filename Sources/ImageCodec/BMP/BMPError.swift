//
//  BMPError.swift
//
//
//  Created by Fang Ling on 2023/6/20.
//

public enum BMPError : Error {
    /* File signature not match (0x42 0x4D) */
    case bad_signature
}
