//
//  NetworkManagerProtocol.swift
//  Nimbus
//
//   Created by  Raj  on 16/05/20.
//  Copyright © 2020 Raj. All rights reserved.
//

import Alamofire

protocol NetworkManagerProtocol {
    
    /// Response for any api request
    /// - Parameters:
    ///   - api: Returns the live endPoint. Ex: serverUrl,...
    ///   - errorHandler: Corresponding error response from api
    ///   - type: Class/Struct type to  be decoded
    ///   - successHandler: Success Response
    func performRequest<T: Codable>(forAPI api: MusicPlayerAPI,
                                    responseType type: T.Type,
                                    successHandler: @escaping (T) -> Void,
                                    errorHandler: @escaping (AFError) -> Void)
    
    /// Returns the dictionary of the corresponding api response
    /// - Parameters:
    ///   - api: Returns the live endPoint. Ex: serverUrl,...
    ///   - errorHandler: Corresponding error response from api
    ///   - successHandler: Corresponding success response from api. In dictionary
    func performRequestWithoutModel(forAPI api: MusicPlayerAPI,
                                    successHandler: @escaping ([String: Any]?) -> Void, errorHandler: @escaping (AFError) -> Void)
    /// Stop any and every ongoing session
    func stopAllSessions()
}

extension NetworkManagerProtocol {
    /// Stop any and every ongoing session
    func stopAllSessions() {}
    
    func performRequestWithoutModel(forAPI api: MusicPlayerAPI,
                                    successHandler: @escaping ([String: Any]?) -> Void, errorHandler: @escaping (AFError) -> Void) {}
}
