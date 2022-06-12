//
//  AppConstants.swift
//  MovieApp
//
//  Created by Elif Yalçın on 13.06.2022.
//

import UIKit

struct AppConstants {
    static let appName = "The Movie Manager"
    static let loginTitleText = "Login with Email"
    static let emailPlaceholder = "Email"
    static let passwordPlaceholder = "Password"
    static let loginButtonTitle = "Login"
    static let loginWithGoogleTitle = "Login with Google"
    static let orText = "OR"
    static let emptyMessage = "Password and email fields can not be empty."
    static let wrongPasswordMessage = "Wrong password"
    static let createAccountText = "Would you like to create an account?"
    static let searchTitle = "Search"
    static let watchListTitle = "Watch List"
    static let favListTitle = "Favorite List"
    static let imagePath = "https://image.tmdb.org/t/p/w500"
    static let favButtonFilled = UIImage(named: "heartfilled")
    static let favButton = UIImage(named: "heart")
    static let watchListButtonFilled = UIImage(named: "listfilled")
    static let watchListButton = UIImage(named: "list")
    static let dateIcon = UIImage(named: "calendar")
    static let starIcon = UIImage(named: "star")
    static let textFieldBackgroundColor = UIColor(red: 0.80, green: 0.85, blue: 1.00, alpha: 1.00)
    static let buttonBackgroundColor = UIColor(red: 0.00, green: 0.18, blue: 0.70, alpha: 1.00)
    static let loginBackgroundColor = UIColor(red: 0.30, green: 0.47, blue: 1.00, alpha: 1.00)
    static let apiUrl = "https://api.themoviedb.org/3/discover/movie?api_key=4f5eec4665e6f25a93c80fdc6ab53a30&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
}
