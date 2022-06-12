//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Elif Yalçın on 9.06.2022.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {

    private let searchBar = UISearchBar()
    private var movieTableView = UITableView()
    private let label = UILabel()
    private let searchViewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchViewModel.getMovies()
        setViews()
        customizeviews()
    }
    
    func setViews() {
        view.addSubview(searchBar)
        view.addSubview(movieTableView)
  
        
        searchBar.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(90)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        movieTableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom).offset(5)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func customizeviews() {
        self.title = "Search"
        view.backgroundColor = .white
        
        movieTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        searchBar.delegate = (searchViewModel as UISearchBarDelegate)
        movieTableView.delegate = searchViewModel
        movieTableView.dataSource = searchViewModel
        searchViewModel.delegate = self
        
        //searchBar.backgroundColor = .darkGray
        searchBar.barTintColor = .systemGray3
        searchBar.searchTextField.backgroundColor = .white
        
        
    }
}

extension SearchViewController : SearchViewModelProtocol {
    func updateList() {
        movieTableView.reloadData()
    }
    func pushDetail(data: Result) {
        let vc = MovieDetailViewController()
     //  testVC.movieData = data
        vc.imdb = data.voteAverage
        vc.name = data.originalTitle
        vc.overview = data.overview
        vc.relese = data.releaseDate
        vc.imageUrl = data.posterPath
        vc.id = data.id
                
        vc.modalPresentationStyle = .fullScreen
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
