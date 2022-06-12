//
//  TestVC.swift
//  MovieApp
//
//  Created by Elif Yalçın on 9.06.2022.
//

import UIKit
import SQLite
import FirebaseAuth

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
    var userEmail = String()
    
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
    let signOutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = name
        userEmail = UserDefaults.standard.string(forKey: "userEmail")!
        db.connectionFavTable()
        db.connectionWatchListTable()
        dbFavArray.append(contentsOf: db.returnFavList(user: userEmail))
        dbWatchListArray.append(contentsOf: db.returnWatchList(user: userEmail))
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
        view.addSubview(signOutButton)
        
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
            make.bottom.equalTo(signOutButton.snp.top).offset(-5)
        }
        signOutButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(tabView.snp.top).offset(-5)
            make.right.equalToSuperview().offset(-5)
            make.width.height.equalTo(20)
        }
    }
    
    func customizeViews() {
        tabView.backgroundColor = .systemGray6
        
        dateLabel.textColor = .white
        dateLabel.font = .systemFont(ofSize: 16, weight: .bold)
        dateLabel.text = relese
        
        detailTextView.font = .systemFont(ofSize: 16, weight: .medium)
        detailTextView.text = overview
        detailTextView.isUserInteractionEnabled = false
        detailTextView.showsVerticalScrollIndicator = false
        
        movieNameLabel.textColor = .white
        movieNameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        movieNameLabel.text = name
        
        imdbLabel.textColor = .white
        imdbLabel.font = .systemFont(ofSize: 16, weight: .bold)
        imdbLabel.text = String(imdb)
        
        signOutButton.setBackgroundImage(UIImage(named: "signOut"), for: .normal)
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        
        let url = URL(string: "\(AppConstants.imagePath)\(imageUrl)")
        let data = try! Data(contentsOf: url!)
        movieImage.image = UIImage(data: data)
        
        dateIcon.image = AppConstants.dateIcon
        starIcon.image = AppConstants.starIcon
        
        if !dbFavArray.isEmpty {
            var idArray = [Int]()
            for index in 0...dbFavArray.count - 1 {
                idArray.append(dbFavArray[index].id)
            }
            
            if idArray.contains(id) {
                favButton.setBackgroundImage(AppConstants.favButtonFilled, for: .normal)
            } else {
                favButton.setBackgroundImage(AppConstants.favButton, for: .normal)
            }
        } else {
            favButton.setBackgroundImage(AppConstants.favButton, for: .normal)
        }
        
        if !dbWatchListArray.isEmpty {
            var idArray = [Int]()
            for index in 0...dbWatchListArray.count - 1 {
                idArray.append(dbWatchListArray[index].id)
            }
            
            if idArray.contains(id) {
                watchListButton.setBackgroundImage(AppConstants.watchListButtonFilled, for: .normal)
            } else {
                watchListButton.setBackgroundImage(AppConstants.watchListButton, for: .normal)
            }
        } else {
            watchListButton.setBackgroundImage(AppConstants.watchListButton, for: .normal)
        }
        
        favButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        watchListButton.addTarget(self, action: #selector(addToWatchList), for: .touchUpInside)
    }
    
    @objc func addToFavorites() {
        let isExist = db.insertMovieToFavorites(id: id, imgUrl: imageUrl, name: name, rating: imdb , release: relese, overview: overview, userEmail: userEmail)
        if isExist == -1 {
            db.deleteFromFavorites(movieId: id)
            favButton.setBackgroundImage(AppConstants.favButton, for: .normal)
        } else {
            favButton.setBackgroundImage(AppConstants.favButtonFilled, for: .normal)
        }
    }
    
    @objc func addToWatchList() {
        let isExist = db.insertMovieToWatchList(id: id, imgUrl: imageUrl, name: name, rating: imdb , release: relese, overview: overview, userEmail: userEmail)
        if isExist == -1 {
            db.deleteFromWatchList(movieId: id)
            watchListButton.setBackgroundImage(AppConstants.watchListButton, for: .normal)
        } else {
            watchListButton.setBackgroundImage(AppConstants.watchListButtonFilled, for: .normal)
        }
    }
    
    @objc func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let rootVC = LoginViewController()
            rootVC.modalPresentationStyle = .fullScreen
            self.present(rootVC, animated: true)
        } catch let signOutError as NSError {
            print(signOutError)
        }
    }
}
