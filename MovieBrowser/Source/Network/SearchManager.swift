//
//  SearchManager.swift
//  MovieBrowser
//
//  Created by Randy Crossley on 4/20/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation

protocol SearchManagerDelegate {
    func didUpdateSearch(_ searchManager: SearchManager, search: [SearchModel])
    func didFailWithError(error: Error)
}

struct SearchManager {
    
    let searchURL = "https://api.themoviedb.org/3/search/movie?api_key=\(Network.apiKey)&language=en-US"
    var delegate: SearchManagerDelegate?
    var imageBaseURL: String = ""
    
    enum Errors: Error {
        case errorDecodingString
    }
    
    mutating func fetchSearch(movieName: String, imageBaseURL: String) {

        self.imageBaseURL = imageBaseURL
        let urlString = "\(searchURL)&query=\(movieName)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {

            let session = URLSession(configuration: .default)

            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let search = parseJSON(safeData) {
                        delegate?.didUpdateSearch(self, search: search)
                    }
                }
            }

            task.resume()
        }
    }
    
    func parseJSON(_ searchData: Data) -> [SearchModel]? {
        var decodedMovies:[SearchModel] = []
        let decoder = JSONDecoder()

        do {
            let decodedData = try decoder.decode(SearchData.self, from: searchData)
            
            let movies = decodedData.results
            
            for movie in movies {
                
                var imageURL: String? = nil
                if let posterPath = movie?.poster_path {
                    imageURL = "\(imageBaseURL)w780\(posterPath)"
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let searchDateFormatter = DateFormatter()
                searchDateFormatter.dateFormat = "MMMM d, yyyy"
                let detailDateFormatter = DateFormatter()
                detailDateFormatter.dateFormat = "M/d/yy"

                if let releaseDate = movie?.release_date, let date = dateFormatter.date(from: releaseDate) {
                    let searchDate = searchDateFormatter.string(from: date)
                    let detailDate = detailDateFormatter.string(from: date)
                    
                    let createSearchModel = SearchModel(movieDescription: movie?.overview, imageURL: imageURL, searchDate: searchDate, detailDate: detailDate, movieTitle: movie?.title, voteAverage: movie?.vote_average)
                    decodedMovies.append(createSearchModel)
                    
                } else {
                    delegate?.didFailWithError(error: Errors.errorDecodingString)
                }
            }
            return decodedMovies
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
