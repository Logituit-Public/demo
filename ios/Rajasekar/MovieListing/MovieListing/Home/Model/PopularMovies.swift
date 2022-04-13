//
//  PopularMovies.swift
//  MovieListing
//
//  Created by Rajasekaran Gopal on 11/04/22.
//

import Foundation

struct PopularMovies : Codable, Hashable {

    let page : Int?
    let results : [MovieList]?
    let totalPages : Int?
    let totalResults : Int?

}

struct MovieList : Codable, Hashable {

    let adult : Bool?
    let backdropPath : String?
    let genreIds : [Int]?
    let id : Int?
    let originalLanguage : String?
    let originalTitle : String?
    let overview : String?
    let popularity : Float?
    let posterPath : String?
    let releaseDate : String?
    let title : String?
    let video : Bool?
    let voteAverage : Float?
    let voteCount : Int?

}
