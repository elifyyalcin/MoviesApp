//
//  FavListViewController.swift
//  MovieApp
//
//  Created by Elif Yalçın on 9.06.2022.
//

import UIKit
import SQLite

class FavListViewController: UIViewController {
    
    private let favListTableView = UITableView()
    private var favMovieList:[Movie] = []
    private let db = DB()
    private var userEmail = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = AppConstants.favListTitle
        userEmail = UserDefaults.standard.string(forKey: "userEmail")!
        setupViews()
        customizeViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        db.connectionFavTable()
        favMovieList = db.returnFavList(user: userEmail)
        favListTableView.reloadData()
    }
    
    func setupViews() {
        view.addSubview(favListTableView)
        
        favListTableView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    func customizeViews() {
        favListTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "cell")
        favListTableView.delegate = self
        favListTableView.dataSource = self
        favListTableView.rowHeight = 120
    }
    
}

extension FavListViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favMovieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
        cell.movieNameLabel.text = favMovieList[indexPath.row].name
        let url = URL(string: "\(AppConstants.imagePath)\(favMovieList[indexPath.row].imgUrl)")
        let data = try! Data(contentsOf: url!)
        cell.movieImg.image = UIImage(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MovieDetailViewController()
        vc.relese = favMovieList[indexPath.row].release
        vc.overview = favMovieList[indexPath.row].overview
        vc.imdb = favMovieList[indexPath.row].rating
        vc.name = favMovieList[indexPath.row].name
        vc.imageUrl = favMovieList[indexPath.row].imgUrl
        vc.id = favMovieList[indexPath.row].id
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
