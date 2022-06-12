//
//  ViewController.swift
//  MovieApp
//
//  Created by Elif Yalçın on 9.06.2022.
//

import UIKit
import FirebaseAuth

class TabBarViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let tabBar = UITabBarController()
        
        let search = UINavigationController(rootViewController: SearchViewController())
        search.title = AppConstants.searchTitle
        let searchBarItem = UITabBarItem(title: "Search", image: UIImage(named: "searchtab"), selectedImage: UIImage(named: "searchtab"))
        search.tabBarItem = searchBarItem
        
        let watchList = UINavigationController(rootViewController: WatchListViewController())
        watchList.title = AppConstants.watchListTitle
        let watchListBarItem = UITabBarItem(title: "WatchList", image: UIImage(named: "listtab"), selectedImage: UIImage(named: "listtab"))
        watchList.tabBarItem = watchListBarItem
        
        let favoriteList = UINavigationController(rootViewController: FavListViewController())
        favoriteList.title = AppConstants.favListTitle
        let favoriteListBarItem = UITabBarItem(title: "Favorites", image: UIImage(named: "fav"), selectedImage: UIImage(named: "fav"))
        favoriteList.tabBarItem = favoriteListBarItem
        
        tabBar.setViewControllers([search, watchList, favoriteList], animated: true)
        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: false, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

