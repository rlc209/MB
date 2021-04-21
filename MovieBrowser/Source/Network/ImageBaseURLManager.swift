//
//  ImageManager.swift
//  MovieBrowser
//
//  Created by Randy Crossley on 4/20/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation

protocol ImageBaseURLManagerDelegate {
    func didUpdateImageBaseURL(_ imageBaseURLManager: ImageBaseURLManager, imageBaseURL: String)
    func didFailImageBaseURLWithError(error: Error)
}

struct ImageBaseURLManager {
    
    var imageBaseURL = ""
    var delegate: ImageBaseURLManagerDelegate?
    
    func performRequest() {
        if let url = URL(string: "https://api.themoviedb.org/3/configuration?api_key=\(Network.apiKey)") {

            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    delegate?.didFailImageBaseURLWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let imageBaseURL = parseJSON(safeData) {
                        delegate?.didUpdateImageBaseURL(self, imageBaseURL: imageBaseURL)
                    }
                }
            }

            task.resume()
        }
    }
    
    func parseJSON(_ imageData: Data) -> String? {
        
        var secureBaseURL: String = ""
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(ImageBaseURLData.self, from: imageData)
            secureBaseURL = decodedData.images.secure_base_url
            return secureBaseURL
        } catch {
            
            delegate?.didFailImageBaseURLWithError(error: error)
            return nil
        }
    }
}
