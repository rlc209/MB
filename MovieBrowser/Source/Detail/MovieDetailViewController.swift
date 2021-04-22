//
//  MovieDetailViewController.swift
//  SampleApp
//
//  Created by Struzinski, Mark on 2/26/21.
//  Modified by Crossley, Randy on 4/20/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    var movieTitle: String = ""
    var releaseDate: String = ""
    var movieImage: String = ""
    var movieDescription: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movieTitle
        releaseDateLabel.text = "Release Date: \(releaseDate)"
        movieDescriptionLabel.text = movieDescription
        movieImageView.downloaded(from: "\(movieImage)")
    }    
}
