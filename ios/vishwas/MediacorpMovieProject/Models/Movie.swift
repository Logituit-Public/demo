//
//  Movie.swift
//  MediacorpMovieProject
//
//  Created by Vishwas Anandani on 11/04/22.
//

import Foundation

struct MovieResponse: Codable {
    let page: Int
    let results: [Results]
}

struct Results: Codable {
    
    let adult: Bool
    let id: Int
    let original_title: String
    let title: String
    let overview: String
    let backdrop_path: String?
    let poster_path: String?
    let release_date: String
    let vote_average: Double
    let vote_count: Int
    
    
}


