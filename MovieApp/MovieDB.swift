//
//  MovieDB.swift
//  MovieApp
//
//  Created by Elif Yalçın on 12.06.2022.
//

import Foundation
import SQLite

struct Movie {
    var id: Int = 0
    var imgUrl:String = ""
    var name:String = ""
    var rating:Double = 0.0
    var release: String = ""
    var overview: String = ""
}

class DB {
    
    var db:Connection!
    var favTable = Table("fList")
    var watchListTable = Table("wList")
    
    let id = Expression<Int>("id")
    let imgUrl = Expression<String>("imgUrl")
    let name = Expression<String>("name")
    let rating = Expression<Double>("rating")
    let release = Expression<String>("release")
    let overview = Expression<String>("overview")
    
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    func connectionFavTable() {
        
        let  dbPath = path + "/db.sqlite3"
        db = try! Connection(dbPath)
        print(dbPath)
        
        do {
            try db.scalar(favTable.exists)
        } catch  {
            try! db.run(favTable.create { t in
                t.column(id, primaryKey: true)
                t.column(imgUrl)
                t.column(name)
                t.column(rating)
                t.column(release)
                t.column(overview)
            })
        }
    }
    
    func connectionWatchListTable() {
        
        let  dbPath = path + "/db.sqlite3"
        db = try! Connection(dbPath)
        
        do {
            try db.scalar(watchListTable.exists)
        } catch  {
            try! db.run(watchListTable.create { t in
                t.column(id, primaryKey: true)
                t.column(imgUrl)
                t.column(name)
                t.column(rating)
                t.column(release)
                t.column(overview)
            })
        }
    }
    
    func insertMovieToFavorites(id: Int,imgUrl: String, name: String, rating: Double, release: String, overview: String) -> Int64 {
        
        do {
            let insert = favTable.insert( self.id <- id, self.imgUrl <- imgUrl, self.rating <- rating, self.name <- name, self.release <- release , self.overview <- overview)
            return try db.run(insert)
        } catch  {
            return -1
        }
    }
    
    func returnFavList() -> [Movie] {
        var arr:[Movie] = []
        let movies = try! db.prepare(favTable)
        for item in movies {
            let movie = Movie(id: item[id], imgUrl: item[imgUrl], name: item[name], rating: item[rating],release: item[release], overview: item[overview] )
            arr.append(movie)
        }
        return arr
    }
    
    func deleteFromFavorites( movieId: Int ) -> Int {
        let movie = favTable.filter(Expression<Bool>(id==movieId))
        return try! db.run( movie.delete() )
    }
    
    
    func insertMovieToWatchList(id: Int,imgUrl: String, name: String, rating: Double, release: String, overview: String) -> Int64 {
        
        do {
            let insert = watchListTable.insert( self.id <- id, self.imgUrl <- imgUrl, self.rating <- rating, self.name <- name, self.release <- release , self.overview <- overview)
            return try db.run(insert)
        } catch  {
            return -1
        }
    }
    
    func returnWatchList() -> [Movie] {
        var arr:[Movie] = []
        let movies = try! db.prepare(watchListTable)
        for item in movies {
            let movie = Movie(id: item[id], imgUrl: item[imgUrl], name: item[name], rating: item[rating],release: item[release], overview: item[overview] )
            arr.append(movie)
        }
        return arr
    }
    
    func deleteFromWatchList( movieId: Int ) -> Int {
        let movie = watchListTable.filter(Expression<Bool>(id==movieId))
        return try! db.run( movie.delete() )
    }
    
}
