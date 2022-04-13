//
//  UpcomingMovies.swift
//  MovieListing
//
//  Created by Rajasekaran Gopal on 11/04/22.
//

import Foundation


struct UpcomingMovies : Codable, Hashable {

    let page : Int?
    let results : [MovieList]?
    let totalPages : Int?
    let totalResults : Int?
}
