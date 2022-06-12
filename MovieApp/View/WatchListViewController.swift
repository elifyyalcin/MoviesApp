//
//  WatchListViewController.swift
//  MovieApp
//
//  Created by Elif Yalçın on 9.06.2022.
//

import UIKit
import SQLite

class WatchListViewController: UIViewController {
    
    private let watchListTableView = UITableView()
    private var watchList:[Movie] = []
    private let db = DB()
    private var userEmail = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = AppConstants.watchListTitle
        userEmail = UserDefaults.standard.string(forKey: "userEmail")!
        setupViews()
        customizeViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        db.connectionWatchListTable()
        watchList = db.returnWatchList(user: userEmail)
        watchListTableView.reloadData()
    }
    
    func setupViews() {
        view.addSubview(watchListTableView)
        
        watchListTableView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    func customizeViews() {
        watchListTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "cell")
        watchListTableView.delegate = self
        watchListTableView.dataSource = self
        watchListTableView.rowHeight = 120
    }
}

extension WatchListViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = watchListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
        cell.movieNameLabel.text = watchList[indexPath.row].name
        let url = URL(string: "\(AppConstants.imagePath)\(watchList[indexPath.row].imgUrl)")
        let data = try! Data(contentsOf: url!)
        cell.movieImg.image = UIImage(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MovieDetailViewController()
        vc.relese = watchList[indexPath.row].release
        vc.overview = watchList[indexPath.row].overview
        vc.imdb = watchList[indexPath.row].rating
        vc.name = watchList[indexPath.row].name
        vc.imageUrl = watchList[indexPath.row].imgUrl
        vc.id = watchList[indexPath.row].id
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

