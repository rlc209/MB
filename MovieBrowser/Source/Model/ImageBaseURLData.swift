//
//  ImageData.swift
//  MovieBrowser
//
//  Created by Randy Crossley on 4/20/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation

struct ImageBaseURLData: Decodable {
    let images: Image
}

struct Image: Decodable {
    let secure_base_url: String
}
