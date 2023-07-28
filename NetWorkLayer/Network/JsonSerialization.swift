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
                
                switch (httpResponse.statusCode){
                case 500..<600:
                    completion(.failure(.ServicerErrorBadGateway))
                case 200:
                    guard let data = data,error == nil  else { return completion(.failure(.noData)) }
                    completion(.success(data))
                case 401,400:
                    completion(.failure(.BadRequest))
                case 201:
                    do{
                        let jsonAsData = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                        print(jsonAsData)
                    }catch{
                        print("Errohadling")
                    }
                    
                    
                default: print("Error")
                }

            }
        }).resume()
    }
}

