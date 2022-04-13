//
//  NetworkManager.swift
//  Nimbus
//
//   Created by  Raj  on 16/05/20.
//  Copyright © 2020 Raj. All rights reserved.
//

import UIKit
import Alamofire

//ErrorHandler with returns AFError
typealias ErrorHandler = (AFError) -> Void

//SuccessHanlder of type codable
typealias SuccessHandler<T: Codable> = (T) -> Void

//Dictionary successHandler
typealias SuccessHandlerDict = ([String: Any]?) -> Void
enum ApiResponse<T> {
    case success(value: T)
    case failure(error: AFError)
}
// MARK: - NetworkManager
class NetworkManager: NSObject, NetworkManagerProtocol {
    
    var sessionManager: SessionManagerProtocol?
    
    
    /// Default session configuration
    private var configuration: URLSessionConfiguration {
        get {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30.0
            configuration.timeoutIntervalForResource = 30.0
            return configuration
        }
    }
    
    private override init() {
        super.init()
        sessionManager = Session(configuration: configuration)
    }
    
    static let sharedInstance = NetworkManager()
    
    /// API response for any api request
    /// - Parameters:
    ///   - api: Returns the live endPoint. Ex: serverUrl,...
    ///   - errorHandler: Corresponding error response from api
    ///   - type: Class/Struct type to  be decoded
    ///   - successHandler: Success Response
    fileprivate func getResponseForApi<T: Codable>(_ api: MusicPlayerAPI,
                                                   _ errorHandler: @escaping ErrorHandler,
                                                   _ type: T.Type,
                                                   _ successHandler: @escaping SuccessHandler<T>) {
        print(api)
        sessionManager?.sendRequest(api).response { apiResponse in
            if let error = apiResponse.error {
                errorHandler(error)
                //                self.checkAPI(api)
                return
            }
            let res = apiResponse.result
            switch res {
            case .success(_):
                if let statusCode  = apiResponse.response?.statusCode {
                    if statusCode != 200 {
                        
                        guard let data = apiResponse.data else {
                            errorHandler(AFError.responseValidationFailed(reason: .dataFileNil))
                            return
                        }
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
            guard let data = apiResponse.data else {
                errorHandler(AFError.responseValidationFailed(reason: .dataFileNil))
                //                self.checkAPI(api)
                return
            }
            let response = NetworkResponse(data: data)
            guard let decoded = response.decode(type) else { 
                print("API response: \(String(data: data, encoding: .utf8) ?? "")")
                errorHandler(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
                //                self.checkAPI(api)
                return
            }
            print("API response: \(String(data: data, encoding: .utf8) ?? "")")

            successHandler(decoded)
        }
    }
    
    /// API response for any api request
    /// - Parameters:
    ///   - api: Returns the live endPoint. Ex: serverUrl,...
    ///   - errorHandler: Corresponding error response from api
    ///   - type: Class/Struct type to  be decoded
    ///   - successHandler: Success Response
    func performRequest<T: Codable>(forAPI api: MusicPlayerAPI,
                                    responseType type: T.Type,
                                    successHandler: @escaping SuccessHandler<T>,
                                    errorHandler: @escaping ErrorHandler) {
        
        //        switch api {
        //        case .getToken:
        //            getResponseForApi(api, errorHandler, type, successHandler)
        //        default:
        //            if let _ = UserDefaults.standard.string(forKey: "apiToken"){
        //                if checkIfTokenValid() {
        //                    getResponseForApi(api, errorHandler, type, successHandler)
        //                } else {
        //                    getToken(appLaunch: UserDefaults.standard.bool(forKey: "IsFirstLaunch"), completion: {
        //                        self.getResponseForApi(api, errorHandler, type, successHandler)
        //                    })
        //                }
        //            } else {
        //                getResponseForApi(api, errorHandler, type, successHandler)
        //            }
        //        }
        getResponseForApi(api, errorHandler, type, successHandler)
        
    }
    
    /// Returns the dictionary of the corresponding api response
    /// - Parameters:
    ///   - api: Returns the live endPoint. Ex: serverUrl,...
    ///   - errorHandler: Corresponding error response from api
    ///   - successHandler: Corresponding success response from api. In dictionary
    func performRequestWithoutModel(forAPI api: MusicPlayerAPI,
                                    successHandler: @escaping SuccessHandlerDict,
                                    errorHandler: @escaping ErrorHandler) {
        
        sessionManager?.sendRequest(api).responseJSON { apiResponse in
            if let error = apiResponse.error {
                errorHandler(error)
                return
            }
            do {
                let data = try apiResponse.result.get() as? [String: Any]
                successHandler(data?["resultObj"] as? [String: Any])
            } catch let error {
                errorHandler(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
                print(error.localizedDescription)
            }
        }
    }
    func requestObject<T: Codable>(forAPI api: MusicPlayerAPI, completionHandler: @escaping(ApiResponse<T>)->()) {
        sessionManager?.sendRequest(api).response { apiResponse in
            switch apiResponse.result {
            case .success(let data):
                guard let responseData = data else {
                    completionHandler(.failure(error: AFError.responseValidationFailed(reason: .dataFileNil)))
                    return
                }
                do {
                    print(responseData)
                    let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                    print(jsonData)
                    let model = try JSONDecoder().decode(T.self, from: responseData)
                    completionHandler(.success(value: model))
                }catch {
                    completionHandler(.failure(error:AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error))))
                }
            case .failure(let networkFailureError):
                completionHandler(.failure(error: AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: networkFailureError))))
            }
        }
    }
    /// Stop any and every ongoing session
    func stopAllSessions() {
        sessionManager?.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
    }
    
    func checkAPI(_ api: MusicPlayerAPI) {
        ReachabilityHandler.shared.listenForReachability()
        if ReachabilityHandler.shared.isConnected {
            switch api {
            //            case .page, .getProducts, .uld, .getToken, .initialConfig, .getDetails, .getAssetSpecificProducts :
            //                self.showErrorScreen(errorScreenType: .errorSomethingWentWrong)
            default:
                print("Error screen")
            }
        }
    }
}
