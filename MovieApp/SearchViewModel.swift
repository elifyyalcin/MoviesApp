//
//  SearchViewModel.swift
//  MovieApp
//
//  Created by Elif Yalçın on 10.06.2022.
//

import UIKit
import Alamofire

protocol SearchViewModelProtocol : NSObject {
    func updateList()
    func pushDetail(data: Result)
}
class SearchViewModel: NSObject {
    weak var delegate : SearchViewModelProtocol?
    var movieList = [Result]()
    var movieListForSearch = [Result]()
    
    func getMovies() {
        
        let url = "https://api.themoviedb.org/3/discover/movie?api_key=4f5eec4665e6f25a93c80fdc6ab53a30&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
        
        AF.request(url, method: .get).responseJSON { (res) in
            
            if ( res.response?.statusCode == 200 ) {
                
                let response = try? JSONDecoder().decode(MovieModel.self, from: res.data!)
                
                if let movieList = response?.results {
                    self.movieList = movieList
                    self.movieListForSearch = movieList
                    DispatchQueue.main.async {
                        self.delegate?.updateList()
                    }
                }
            }
        }
    }
}
extension SearchViewModel: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = movieList[indexPath.row].originalTitle
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.pushDetail(data: movieList[indexPath.row])
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        
        movieList.removeAll()
        
        if searchText.count > 0 {
            for index in 0...movieListForSearch.count - 1 {
                if (movieListForSearch[index].originalTitle.contains(searchText)) {
                    movieList.append(movieListForSearch[index])
                }
            }
        } else {
            movieList = movieListForSearch
        }
        
        DispatchQueue.main.async {
            self.delegate?.updateList()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        movieList = movieListForSearch
        DispatchQueue.main.async {
            self.delegate?.updateList()
        }
        
    }
    
    
}
