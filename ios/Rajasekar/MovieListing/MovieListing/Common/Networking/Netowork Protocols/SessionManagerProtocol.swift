//
//  SessionManagerProtocol.swift
//  Nimbus
//
//   Created by  Raj  on 16/05/20.
//  Copyright © 2020 Raj. All rights reserved.
//

import UIKit
import Alamofire

/// Manages the corresponding Request calls.
protocol SessionManagerProtocol {
    /// Creates a `DataRequest` from a `URLRequestConvertible`.
    ///
    /// - Parameters:
    ///   - convertible: `URLRequestConvertible` value to be used to create the `URLRequest`.
    ///
    /// - Returns: The created `DataRequest`.
    func sendRequest(_ convertible: URLRequestConvertible) -> DataRequest

    /// Underlying `URLSession` used to create `URLSessionTasks` for this instance, and for which this instance's
    /// `delegate` handles `URLSessionDelegate` callbacks.
    var session: URLSession { get }
}

/*
  Session Extension for dependecy Injection.
  Note: If any requirement for `RequestInterceptor`. Add a protocol for requestInterceptor in `SessionManager`.
  Usage:
 `protocol SessionManager {
   func sendRequest(_ convertible: URLRequestConvertible, interceptor: RequestInterceptor) -> DataRequest }`
  extension Session: SessionManager {
    func sendRequest(_ convertible: URLRequestConvertible,
                     interceptor: RequestInterceptor) -> DataRequest}
  }`
*/
extension Session: SessionManagerProtocol {
    func sendRequest(_ convertible: URLRequestConvertible) -> DataRequest {
        return self.request(convertible)
    }
}
