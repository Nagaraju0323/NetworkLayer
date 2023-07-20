//
//  JsonSerialization.swift
//  NetWorkLayer
//  Created by Nagaraju on 19/07/23.

/**
 * Used for Json Serilization
 * - parameter Data:Convert to Response to Data
 * - parameter ErrorHandling: Error handling
 */

import Foundation

// protocol DataRequest {
//     func respHandler(completion:@escaping(Result<Data,ErrorHandling>) -> Void)
//}

/**
 * Used for Json Serilization
 * - parameter Data:Convert to Response to Data
 * - parameter ErrorHandling: Error handling
 */

extension URLRequestConvertible {
    
    func responseJSON(completion:@escaping(Result<Data,ErrorHandling>) -> Void){
        guard let urlRequest = resultURLRequest else { return }
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { data,response,error in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200{
                    if let data = data,error == nil{
                        completion(.success(data))
                    }else {
                        completion(.failure(.noData))
                    }
                }else {
                    completion(.failure(.authenticationError))
                }
                
            }
        }).resume()
    }
}

