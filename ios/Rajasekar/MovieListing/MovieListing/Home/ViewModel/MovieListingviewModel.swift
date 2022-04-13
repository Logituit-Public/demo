//
//  MovieListingviewModel.swift
//  MovieListing
//
//  Created by Rajasekaran Gopal on 11/04/22.
//

import Foundation


class MovieListviewModel {
    
    //MARK: - API CALLS
    func callPopularMovieListAPI(with pageNo: Int,
                                successHandler: @escaping (_ content: PopularMovies) -> (),
                                failureHandler: @escaping (_ error: Error) -> ()) {
        NetworkManager.sharedInstance.performRequest(forAPI: .loadPopularList(apiKey: User.apiKey.rawValue, lang: "en-US", pageNumber: pageNo), responseType: PopularMovies.self)
        { (homeResponse) in
            successHandler(homeResponse)
        } errorHandler: { (error) in
            //FIXME: - Show proper error screen
            print("~~~~IN API ERROR => \(error)~~~");
            
        }
    }
    
    func callUpcomingMovieListAPI(with pageNo: Int,
                                successHandler: @escaping (_ content: UpcomingMovies) -> (),
                                failureHandler: @escaping (_ error: Error) -> ()) {
        NetworkManager.sharedInstance.performRequest(forAPI: .loadUpcomingList(apiKey: User.apiKey.rawValue, lang: "en-US", pageNumber: pageNo), responseType: UpcomingMovies.self)
        { (homeResponse) in
            successHandler(homeResponse)
        } errorHandler: { (error) in
            //FIXME: - Show proper error screen
            print("~~~~IN API ERROR => \(error)~~~");
            
        }
    }
}
