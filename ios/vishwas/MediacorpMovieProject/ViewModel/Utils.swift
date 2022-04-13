//
//  Utils.swift
//  MediacorpMovieProject
//
//  Created by Vishwas Anandani on 12/04/22.
//

import Foundation
let popularMovie = "Popular Movies"
let upcomingMovie = "Upcoming Movies"
let movieApp = "MovieDB App"
let releaseDate = "Release Date:"
let urlHeader = "https://image.tmdb.org/t/p/w500"
let apiKey = "1a5ac0e3d3792ed0a5f3b9293f104204"
let apiKeyFormat = "YOUR API KEY"
let get = "GET"

func performGetRequest(){
    let group = DispatchGroup()
    group.enter()
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
    
    let input_url_popular = "https://api.themoviedb.org/3/movie/popular?api_key=1a5ac0e3d3792ed0a5f3b9293f104204&language=en-US&page=1"
    let apiservice = APIService()
    apiservice.get_response(fromURLString:input_url_popular){ (result) in
    switch result {
    case .success(let data):
        movieDataPopular = data.results
        if (movieDataUpComing.count != 0){
            group.leave()}
    case .failure(let error):
        print(error)
    }}
    let input_url_upcoming = "https://api.themoviedb.org/3/movie/upcoming?api_key=1a5ac0e3d3792ed0a5f3b9293f104204&language=en-US&page=1"
    apiservice.get_response(fromURLString:input_url_upcoming){ (result) in
    switch result {
    case .success(let data):
        movieDataUpComing = data.results
        if (movieDataPopular.count != 0){
            group.leave()}
        
    case .failure(let error):
        print(error)
    }}
    }
    group.wait()
}

func image_processing(urlstring:String){
    let imageURL = URL(string:urlstring)
    do{
    imageData = try Data(contentsOf:imageURL!)}
    catch{print("error")}
}
