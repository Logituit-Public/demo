//
//  MusicPlayerApis.swift
//  MusicPlayer
//
//   Created by  Raj  on 16/05/20.
//  Copyright © 2020. All rights reserved.
//

import UIKit
import Alamofire

enum User: String {
    case apiKey = "3ccaf9758a0a370710f84fa7a11d3e3d"
}

enum MusicPlayerAPI {
   
    
    case loadPopularList(apiKey: String,
                              lang: String,
                              pageNumber: Int)
    case loadUpcomingList(apiKey: String,
                              lang: String,
                              pageNumber: Int)
}

extension MusicPlayerAPI: URLRequestConvertible {
    
    
    var serverURL: URL {
        return URL(string: API.ServerURL)!
    }
    
    var apiKey: String {
        return ""
    }
    var path: String {
        let lang = "en"
        switch self {
        case .loadPopularList(let apiKey,let  lang,let pageNumber):
            return "popular?api_key=\(apiKey)&language=\(lang)&page=\(pageNumber)"
        case .loadUpcomingList(let apiKey,let  lang,let pageNumber):
            return "upcoming?api_key=\(apiKey)&language=\(lang)&page=\(pageNumber)"

        }
    }
    private var method: HTTPMethod {
        switch self {
        case  .loadPopularList :
            return .get
       
        default:
            return .get
        }
    }
    private var parameters: Parameters? {
        
        switch self {
        
        default:
            return nil
        }
    }
    
    var baseURL: String {
        
        switch self {
       
        default:
            return serverURL.absoluteString
        }
    }
    var queryItems: [URLQueryItem] {
        let path = self.path
        var queryItems: [URLQueryItem] = []
        if let url = URLComponents(string: path) {
            queryItems += url.queryItems ?? []
        }
        switch self {
        
        default :
            return []
        }
    }
    
    // MARK: - URLRequest for Alamofire
    /**
     Any changes to the request like headers and parameters to be done here as after this the request cannot be modified.
     */
    
    func asURLRequest() throws -> URLRequest {
        
        let urlString = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        var urlComponents = URLComponents(string: (baseURL + urlString))!
        if queryItems.count > 0 {
            urlComponents.queryItems = queryItems
        }
        let url = urlComponents.url!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 30.0
        urlRequest.httpMethod = method.rawValue
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        urlRequest.setValue(ContentTypeHttp.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.setValue("VI", forHTTPHeaderField: "PRODUCT")
        print("MovieListAPIS api request url",urlRequest.url)
        
       
        
        switch self {
        
        default:
            if let parameters = parameters {
                do {
                    print(parameters)
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                } catch {
                    throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
                }
            }
            
            debugPrint("request: \(urlRequest.url?.absoluteString ?? "")")
            debugPrint("request: \(String(describing: urlRequest.allHTTPHeaderFields))")
            debugPrint("request: \(String(describing: String(data: urlRequest.httpBody ?? Data(), encoding: .utf8)))")
            return urlRequest
        }
    }
    
}

