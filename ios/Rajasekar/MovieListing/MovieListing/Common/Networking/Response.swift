//
//  Response.swift
//  Nimbus
//
//   Created by  Raj  on 16/05/20.
//  Copyright © 2020 Raj. All rights reserved.
//

import UIKit


struct NetworkResponse {
    fileprivate var data: Data
    init(data: Data) {
        self.data = data
    }
}

struct APIResponse: Codable {
    var resultCode, message, errorDescription: String?
}

extension NetworkResponse {
    public func decode<T: Codable>(_ type: T.Type) -> T? {
        let jsonDecoder = JSONDecoder()
        /*Converting the snakecase to camelCase inorder to match with out model -
         The following examples show the result of applying this strategy:
         fee_fi_fo_fum
         Converts to: feeFiFoFum */
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        var response: T?
        do {
            response = try jsonDecoder.decode(T.self, from: data)
            return response
        } catch let error as DecodingError {
            switch error {
            case .typeMismatch(let key, let value):
                print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
            case .valueNotFound(let key, let value):
                print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
            case .keyNotFound(let key, let value):
                print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
            case .dataCorrupted(let key):
                print("error \(key), and ERROR: \(error.localizedDescription)")
            default:
                print("ERROR: \(error.localizedDescription)")
            }
            return nil
        }catch let error {
            print(error)
            return nil
        }
    }
    
    public func decodeCustomData<T: Codable>(_ type: T.Type) -> T? {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let result = try jsonDecoder.decode(T.self, from: data)
            return result
        } catch let error {
            print(error)
            return nil
        }
    }
    
    
}

