//
//  SearchData.swift
//  MovieBrowser
//
//  Created by Randy Crossley on 4/20/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation

struct SearchData: Decodable {
    let results: [Result?]
}

struct Result: Decodable {
    let overview: String?
    let poster_path: String?
    let release_date: String?
    let title: String?
    let vote_average: Double?
}
