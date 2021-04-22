//
//  SearchViewController.swift
//  SampleApp
//
//  Created by Struzinski, Mark on 2/19/21.
//  Modified by Crossley, Randy on 4/20/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var imageBaseURLManager = ImageBaseURLManager()
    var imageBaseURL = ""
    var searchManager = SearchManager()
    var searches: [SearchModel] = []
    var movieTitle: String = ""
    var releaseDate: String = ""
    var movieImage: String = ""
    var movieDescription: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        title = K.appName
        searchBar.delegate = self
        imageBaseURLManager.delegate = self
        searchManager.delegate = self
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        imageBaseURLManager.performRequest()
    }
    
}

//MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    @IBAction func goPressed(_ sender: UIButton) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if searchBar.text != "" {
            return true
        } else {
            
            // If user selected Search or Go while the search bar was empty, this will add a reminder as a placeholder to type something in.
            searchBar.placeholder = "Type in a movie to search."
            return false
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let movie = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            searchManager.fetchSearch(movieName: movie, imageBaseURL: imageBaseURL)
        }
        searchBar.text = ""
    }
}

//MARK: - SearchManagerDelegate

extension SearchViewController: SearchManagerDelegate {
    func didUpdateSearch(_ searchManager: SearchManager, search: [SearchModel]) {
        DispatchQueue.main.async {
            self.searches = search
            self.tableView.reloadData()
            
            // If user scrolled down the list, then searched for a new movie, this shows the top of the new list.
            if !search.isEmpty {
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let search = searches[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! SearchCell
        cell.titleLabel.text = search.movieTitle
        cell.dateLabel.text = search.searchDate
        cell.ratingLabel.text = String(search.voteAverage ?? 0)

        return cell
    }
}

//MARK: - ImageBaseURLManagerDelegate

extension SearchViewController: ImageBaseURLManagerDelegate {
    func didUpdateImageBaseURL(_ imageBaseURLManager: ImageBaseURLManager, imageBaseURL: String) {
        DispatchQueue.main.async {
            self.imageBaseURL = imageBaseURL
        }
    }
    
    func didFailImageBaseURLWithError(error: Error) {
        print("error")
    }
}

//MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let search = searches[indexPath.row]
        movieTitle = search.movieTitle ?? ""
        releaseDate = search.detailDate ?? ""
        movieImage = search.imageURL ?? ""
        movieDescription = search.movieDescription ?? ""

        performSegue(withIdentifier: K.searchSegue, sender: self)
    }
    
// MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destinationVC = segue.destination as! MovieDetailViewController
        destinationVC.movieTitle = movieTitle
        destinationVC.releaseDate = releaseDate
        destinationVC.movieImage = movieImage
        destinationVC.movieDescription = movieDescription
    }    
}
