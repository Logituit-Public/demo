//
//  ApiConfig.swift
//  Nimbus
//
//   Created by  Raj  on 16/05/20.
//  Copyright © 2020 Raj. All rights reserved.
//

import UIKit

struct API {
    

    static let ServerURL = "https://api.themoviedb.org/3/movie/"
    static let BaseUrl = "https://image.tmdb.org/t/p/w500"

}


// MARK: - HTTPHeaderFields
enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case xViaDevice = "x-via-device"
    case securityToken = "security_token"
}

enum ContentTypeHttp: String {
    case json = "application/json"
}

struct ResultCode {
    static let OK = "OK"
    static let KO = "KO"
}
