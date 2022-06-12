//
//  TestVC.swift
//  MovieApp
//
//  Created by Elif Yalçın on 9.06.2022.
//

import UIKit
import SQLite

class MovieDetailViewController: UIViewController {
    
    private let db = DB()
    private var dbFavArray : [Movie] = []
    private var dbWatchListArray : [Movie] = []
    
    var id = Int()
    var imageUrl = String()
    var overview = String()
    var imdb = Double()
    var relese = String()
    var name = String()
    
    private let tabView = UIView()
    private let watchListButton = UIButton()
    private let favButton = UIButton()
    let movieImage = UIImageView()
    private let starIcon = UIImageView()
    private let dateIcon = UIImageView()
    let detailTextView = UITextView()
    let movieNameLabel = UILabel()
    let imdbLabel = UILabel()
    let dateLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = name
        db.connectionFavTable()
        db.connectionWatchListTable()
        dbFavArray.append(contentsOf: db.returnFavList())
        dbWatchListArray.append(contentsOf: db.returnWatchList())
        setViews()
        customizeViews()
    }
    
    func setViews() {
        view.addSubview(tabView)
        tabView.addSubview(watchListButton)
        tabView.addSubview(favButton)
        view.addSubview(movieImage)
        movieImage.addSubview(starIcon)
        movieImage.addSubview(dateIcon)
        movieImage.addSubview(movieNameLabel)
        movieImage.addSubview(imdbLabel)
        movieImage.addSubview(dateLabel)
        view.addSubview(detailTextView)
        
        tabView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(view.snp.height).dividedBy(10)
        }
        watchListButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
        }
        favButton.snp.makeConstraints { (make) in
            make.left.equalTo(watchListButton.snp.right).offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
        }
        movieImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(view.snp.height).dividedBy(3)
        }
        starIcon.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(20)
        }
        dateIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(starIcon.snp.centerY)
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(20)
        }
        movieNameLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(starIcon.snp.top).offset(-10)
            make.left.equalToSuperview().offset(10)
        }
        imdbLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(starIcon.snp.centerY)
            make.left.equalTo(starIcon.snp.right).offset(5)
            make.width.height.equalTo(10)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(imdbLabel.snp.centerY)
            make.right.equalTo(dateIcon.snp.left).offset(-3)
        }
        detailTextView.snp.makeConstraints { (make) in
            make.top.equalTo(movieImage.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalTo(tabView.snp.top).offset(5)
        }
        
    }
    
    func customizeViews() {

        
        dateLabel.textColor = .white
        dateLabel.font = .systemFont(ofSize: 16, weight: .bold)
        dateLabel.text = relese
        
        detailTextView.font = .systemFont(ofSize: 16, weight: .medium)
        detailTextView.text = overview
        movieNameLabel.textColor = .white
        movieNameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        movieNameLabel.text = name
        
        
        imdbLabel.textColor = .white
        imdbLabel.font = .systemFont(ofSize: 16, weight: .bold)
        imdbLabel.text = String(imdb)
        
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(imageUrl)")
        let data = try! Data(contentsOf: url!)
        movieImage.image = UIImage(data: data)
        
        dateIcon.image = UIImage(named: "calendar")
        starIcon.image = UIImage(named: "star")
        
        if !dbFavArray.isEmpty {
            var idArray = [Int]()
            for index in 0...dbFavArray.count - 1 {
                idArray.append(dbFavArray[index].id)
            }

            if idArray.contains(id) {
                favButton.setBackgroundImage(UIImage(named: "heartfilled"), for: .normal)
            } else {
                favButton.setBackgroundImage(UIImage(named: "heart"), for: .normal)
            }
        } else {
            favButton.setBackgroundImage(UIImage(named: "heart"), for: .normal)
        }
        
        if !dbWatchListArray.isEmpty {
            for index in 0...dbWatchListArray.count - 1 {
                if(dbWatchListArray[index].id == id) {
                    watchListButton.setBackgroundImage(UIImage(named: "listfilled"), for: .normal)
                } else {
                    watchListButton.setBackgroundImage(UIImage(named: "list"), for: .normal)
                }
            }
        } else {
            watchListButton.setBackgroundImage(UIImage(named: "list"), for: .normal)
        }
        
        tabView.backgroundColor = .systemGray6
        
        favButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        watchListButton.addTarget(self, action: #selector(addToWatchList), for: .touchUpInside)
    }
    
    @objc func addToFavorites() {
        let isExist = db.insertMovieToFavorites(id: id, imgUrl: imageUrl, name: name, rating: imdb , release: relese, overview: overview)
        if isExist == -1 {
            db.deleteFromFavorites(movieId: id)
            favButton.setBackgroundImage(UIImage(named: "heart"), for: .normal)
        } else {
            favButton.setBackgroundImage(UIImage(named: "heartfilled"), for: .normal)
        }
    }
    
    @objc func addToWatchList() {
        let isExist = db.insertMovieToWatchList(id: id, imgUrl: imageUrl, name: name, rating: imdb , release: relese, overview: overview)
        if isExist == -1 {
            db.deleteFromWatchList(movieId: id)
            favButton.setBackgroundImage(UIImage(named: "list"), for: .normal)
        } else {
            favButton.setBackgroundImage(UIImage(named: "listfilled"), for: .normal)
        }
    }
}
