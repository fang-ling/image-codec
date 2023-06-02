//
//  webpTests.swift
//
//
//  Created by Fang Ling on 2023/6/1.
//

import Foundation
import XCTest
@testable import txt

final class webpTests: XCTestCase {
    /*
     * Base64 encoded webp file of the flag of R.O.C. (1912-1928)
     * Width: 16
     * Height: 10
     */
    let img1 =
      """
      UklGRkwQAABXRUJQVlA4WAoAAAAkAAAADwAACQAASUNDUEgMAAAAAAxITGlubwIQAABtbnRy
      UkdCIFhZWiAHzgACAAkABgAxAABhY3NwTVNGVAAAAABJRUMgc1JHQgAAAAAAAAAAAAAAAAAA
      9tYAAQAAAADTLUhQICAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAABFjcHJ0AAABUAAAADNkZXNjAAABhAAAAGx3dHB0AAAB8AAAABRia3B0AAACBAAA
      ABRyWFlaAAACGAAAABRnWFlaAAACLAAAABRiWFlaAAACQAAAABRkbW5kAAACVAAAAHBkbWRk
      AAACxAAAAIh2dWVkAAADTAAAAIZ2aWV3AAAD1AAAACRsdW1pAAAD+AAAABRtZWFzAAAEDAAA
      ACR0ZWNoAAAEMAAAAAxyVFJDAAAEPAAACAxnVFJDAAAEPAAACAxiVFJDAAAEPAAACAx0ZXh0
      AAAAAENvcHlyaWdodCAoYykgMTk5OCBIZXdsZXR0LVBhY2thcmQgQ29tcGFueQAAZGVzYwAA
      AAAAAAASc1JHQiBJRUM2MTk2Ni0yLjEAAAAAAAAAAAAAABJzUkdCIElFQzYxOTY2LTIuMQAA
      AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWFlaIAAA
      AAAAAPNRAAEAAAABFsxYWVogAAAAAAAAAAAAAAAAAAAAAFhZWiAAAAAAAABvogAAOPUAAAOQ
      WFlaIAAAAAAAAGKZAAC3hQAAGNpYWVogAAAAAAAAJKAAAA+EAAC2z2Rlc2MAAAAAAAAAFklF
      QyBodHRwOi8vd3d3LmllYy5jaAAAAAAAAAAAAAAAFklFQyBodHRwOi8vd3d3LmllYy5jaAAA
      AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABkZXNjAAAAAAAA
      AC5JRUMgNjE5NjYtMi4xIERlZmF1bHQgUkdCIGNvbG91ciBzcGFjZSAtIHNSR0IAAAAAAAAA
      AAAAAC5JRUMgNjE5NjYtMi4xIERlZmF1bHQgUkdCIGNvbG91ciBzcGFjZSAtIHNSR0IAAAAA
      AAAAAAAAAAAAAAAAAAAAAAAAZGVzYwAAAAAAAAAsUmVmZXJlbmNlIFZpZXdpbmcgQ29uZGl0
      aW9uIGluIElFQzYxOTY2LTIuMQAAAAAAAAAAAAAALFJlZmVyZW5jZSBWaWV3aW5nIENvbmRp
      dGlvbiBpbiBJRUM2MTk2Ni0yLjEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHZpZXcAAAAA
      ABOk/gAUXy4AEM8UAAPtzAAEEwsAA1yeAAAAAVhZWiAAAAAAAEwJVgBQAAAAVx/nbWVhcwAA
      AAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAo8AAAACc2lnIAAAAABDUlQgY3VydgAAAAAAAAQA
      AAAABQAKAA8AFAAZAB4AIwAoAC0AMgA3ADsAQABFAEoATwBUAFkAXgBjAGgAbQByAHcAfACB
      AIYAiwCQAJUAmgCfAKQAqQCuALIAtwC8AMEAxgDLANAA1QDbAOAA5QDrAPAA9gD7AQEBBwEN
      ARMBGQEfASUBKwEyATgBPgFFAUwBUgFZAWABZwFuAXUBfAGDAYsBkgGaAaEBqQGxAbkBwQHJ
      AdEB2QHhAekB8gH6AgMCDAIUAh0CJgIvAjgCQQJLAlQCXQJnAnECegKEAo4CmAKiAqwCtgLB
      AssC1QLgAusC9QMAAwsDFgMhAy0DOANDA08DWgNmA3IDfgOKA5YDogOuA7oDxwPTA+AD7AP5
      BAYEEwQgBC0EOwRIBFUEYwRxBH4EjASaBKgEtgTEBNME4QTwBP4FDQUcBSsFOgVJBVgFZwV3
      BYYFlgWmBbUFxQXVBeUF9gYGBhYGJwY3BkgGWQZqBnsGjAadBq8GwAbRBuMG9QcHBxkHKwc9
      B08HYQd0B4YHmQesB78H0gflB/gICwgfCDIIRghaCG4IggiWCKoIvgjSCOcI+wkQCSUJOglP
      CWQJeQmPCaQJugnPCeUJ+woRCicKPQpUCmoKgQqYCq4KxQrcCvMLCwsiCzkLUQtpC4ALmAuw
      C8gL4Qv5DBIMKgxDDFwMdQyODKcMwAzZDPMNDQ0mDUANWg10DY4NqQ3DDd4N+A4TDi4OSQ5k
      Dn8Omw62DtIO7g8JDyUPQQ9eD3oPlg+zD88P7BAJECYQQxBhEH4QmxC5ENcQ9RETETERTxFt
      EYwRqhHJEegSBxImEkUSZBKEEqMSwxLjEwMTIxNDE2MTgxOkE8UT5RQGFCcUSRRqFIsUrRTO
      FPAVEhU0FVYVeBWbFb0V4BYDFiYWSRZsFo8WshbWFvoXHRdBF2UXiReuF9IX9xgbGEAYZRiK
      GK8Y1Rj6GSAZRRlrGZEZtxndGgQaKhpRGncanhrFGuwbFBs7G2MbihuyG9ocAhwqHFIcexyj
      HMwc9R0eHUcdcB2ZHcMd7B4WHkAeah6UHr4e6R8THz4faR+UH78f6iAVIEEgbCCYIMQg8CEc
      IUghdSGhIc4h+yInIlUigiKvIt0jCiM4I2YjlCPCI/AkHyRNJHwkqyTaJQklOCVoJZclxyX3
      JicmVyaHJrcm6CcYJ0kneierJ9woDSg/KHEooijUKQYpOClrKZ0p0CoCKjUqaCqbKs8rAis2
      K2krnSvRLAUsOSxuLKIs1y0MLUEtdi2rLeEuFi5MLoIuty7uLyQvWi+RL8cv/jA1MGwwpDDb
      MRIxSjGCMbox8jIqMmMymzLUMw0zRjN/M7gz8TQrNGU0njTYNRM1TTWHNcI1/TY3NnI2rjbp
      NyQ3YDecN9c4FDhQOIw4yDkFOUI5fzm8Ofk6Njp0OrI67zstO2s7qjvoPCc8ZTykPOM9Ij1h
      PaE94D4gPmA+oD7gPyE/YT+iP+JAI0BkQKZA50EpQWpBrEHuQjBCckK1QvdDOkN9Q8BEA0RH
      RIpEzkUSRVVFmkXeRiJGZ0arRvBHNUd7R8BIBUhLSJFI10kdSWNJqUnwSjdKfUrESwxLU0ua
      S+JMKkxyTLpNAk1KTZNN3E4lTm5Ot08AT0lPk0/dUCdQcVC7UQZRUFGbUeZSMVJ8UsdTE1Nf
      U6pT9lRCVI9U21UoVXVVwlYPVlxWqVb3V0RXklfgWC9YfVjLWRpZaVm4WgdaVlqmWvVbRVuV
      W+VcNVyGXNZdJ114XcleGl5sXr1fD19hX7NgBWBXYKpg/GFPYaJh9WJJYpxi8GNDY5dj62RA
      ZJRk6WU9ZZJl52Y9ZpJm6Gc9Z5Nn6Wg/aJZo7GlDaZpp8WpIap9q92tPa6dr/2xXbK9tCG1g
      bbluEm5rbsRvHm94b9FwK3CGcOBxOnGVcfByS3KmcwFzXXO4dBR0cHTMdSh1hXXhdj52m3b4
      d1Z3s3gReG54zHkqeYl553pGeqV7BHtje8J8IXyBfOF9QX2hfgF+Yn7CfyN/hH/lgEeAqIEK
      gWuBzYIwgpKC9INXg7qEHYSAhOOFR4Wrhg6GcobXhzuHn4gEiGmIzokziZmJ/opkisqLMIuW
      i/yMY4zKjTGNmI3/jmaOzo82j56QBpBukNaRP5GokhGSepLjk02TtpQglIqU9JVflcmWNJaf
      lwqXdZfgmEyYuJkkmZCZ/JpomtWbQpuvnByciZz3nWSd0p5Anq6fHZ+Ln/qgaaDYoUehtqIm
      opajBqN2o+akVqTHpTilqaYapoum/adup+CoUqjEqTepqaocqo+rAqt1q+msXKzQrUStuK4t
      rqGvFq+LsACwdbDqsWCx1rJLssKzOLOutCW0nLUTtYq2AbZ5tvC3aLfguFm40blKucK6O7q1
      uy67p7whvJu9Fb2Pvgq+hL7/v3q/9cBwwOzBZ8Hjwl/C28NYw9TEUcTOxUvFyMZGxsPHQce/
      yD3IvMk6ybnKOMq3yzbLtsw1zLXNNc21zjbOts83z7jQOdC60TzRvtI/0sHTRNPG1EnUy9VO
      1dHWVdbY11zX4Nhk2OjZbNnx2nba+9uA3AXcit0Q3ZbeHN6i3ynfr+A24L3hROHM4lPi2+Nj
      4+vkc+T85YTmDeaW5x/nqegy6LzpRunQ6lvq5etw6/vshu0R7ZzuKO6070DvzPBY8OXxcvH/
      8ozzGfOn9DT0wvVQ9d72bfb794r4Gfio+Tj5x/pX+uf7d/wH/Jj9Kf26/kv+3P9t//9WUDhM
      OwAAAC8PQAIAJ0CQbTO8CYz5WNcQCBBe/D85QZBtsylM+9Cf/wD+G6rowCDbSKdwCqfwCu+v
      VYWI/udxfJYhAFhNUCCaAwAAPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIg
      eDp4bXB0az0iWE1QIENvcmUgNi4wLjAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6
      Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRl
      c2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczpleGlmPSJodHRwOi8v
      bnMuYWRvYmUuY29tL2V4aWYvMS4wLyIKICAgICAgICAgICAgeG1sbnM6dGlmZj0iaHR0cDov
      L25zLmFkb2JlLmNvbS90aWZmLzEuMC8iCiAgICAgICAgICAgIHhtbG5zOnhtcD0iaHR0cDov
      L25zLmFkb2JlLmNvbS94YXAvMS4wLyI+CiAgICAgICAgIDxleGlmOlBpeGVsWURpbWVuc2lv
      bj4xMDwvZXhpZjpQaXhlbFlEaW1lbnNpb24+CiAgICAgICAgIDxleGlmOlBpeGVsWERpbWVu
      c2lvbj4xNjwvZXhpZjpQaXhlbFhEaW1lbnNpb24+CiAgICAgICAgIDx0aWZmOllSZXNvbHV0
      aW9uPjcyMDAwMC8xMDAwMDwvdGlmZjpZUmVzb2x1dGlvbj4KICAgICAgICAgPHRpZmY6WFJl
      c29sdXRpb24+NzIwMDAwLzEwMDAwPC90aWZmOlhSZXNvbHV0aW9uPgogICAgICAgICA8dGlm
      ZjpSZXNvbHV0aW9uVW5pdD4yPC90aWZmOlJlc29sdXRpb25Vbml0PgogICAgICAgICA8dGlm
      ZjpPcmllbnRhdGlvbj4xPC90aWZmOk9yaWVudGF0aW9uPgogICAgICAgICA8eG1wOkNyZWF0
      b3JUb29sPlBpeGVsbWF0b3IgUHJvIDMuMy41PC94bXA6Q3JlYXRvclRvb2w+CiAgICAgICAg
      IDx4bXA6Q3JlYXRlRGF0ZT4yMDIzLTA1LTI5VDEwOjM4OjQ4KzA4OjAwPC94bXA6Q3JlYXRl
      RGF0ZT4KICAgICAgICAgPHhtcDpNZXRhZGF0YURhdGU+MjAyMy0wNi0wMlQwOTo1NDo1Nisw
      ODowMDwveG1wOk1ldGFkYXRhRGF0ZT4KICAgICAgPC9yZGY6RGVzY3JpcHRpb24+CiAgIDwv
      cmRmOlJERj4KPC94OnhtcG1ldGE+Cg==
      """.components(separatedBy: .newlines).joined()

    func test_decode() throws {
        /* Write image to temp file */
        let file = fopen("img1.webp", "wb")
        let data = Data(base64Encoded: img1)!
        data.withUnsafeBytes { ptr in
            let bytes = ptr.bindMemory(to: UInt8.self).baseAddress!
            fwrite(bytes, data.count, 1, file)
        }
        fclose(file)

        let result = Decoder.decode(from_webp: "img1.webp")
        var example = RGBA64(width: 16, height: 10)
        let colors : [(UInt16, UInt16, UInt16)] =
          [
            (223, 27, 18),
            (255, 198, 0),
            (2, 99, 157),
            (255, 255, 255),
            (0, 0, 0)
          ]

        for color in colors {
            for _ in 0 ..< 16 * 2 {
                example.pixels.append(
                  RGBA64Pixel(
                    red: color.0,
                    green: color.1,
                    blue: color.2,
                    alpha: 255
                  )
                )
            }
        }
        XCTAssertEqual(example, result)

        /* Remove temp file */
        try FileManager.default.removeItem(atPath: "img1.webp")
    }

    func test_encode() throws {
        var example = RGBA64(width: 16, height: 10)
        let colors : [(UInt16, UInt16, UInt16)] =
          [
            (223, 27, 18),
            (255, 198, 0),
            (2, 99, 157),
            (255, 255, 255),
            (0, 0, 0)
          ]

        for color in colors {
            for _ in 0 ..< 16 * 2 {
                example.pixels.append(
                  RGBA64Pixel(
                    red: color.0,
                    green: color.1,
                    blue: color.2,
                    alpha: 255
                  )
                )
            }
        }
        Encoder.encode(to_webp: "img1.webp", raw: example, quality: 100)
        Encoder.encode(
          to_webp: "img2.webp",
          raw: example,
          quality: 19358,
          is_lossless: true
        )
        try FileManager.default.removeItem(atPath: "img1.webp")
        try FileManager.default.removeItem(atPath: "img2.webp")
    }
}
