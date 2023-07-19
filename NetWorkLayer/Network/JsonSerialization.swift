//
//  JsonSerialization.swift
//  NetWorkLayer
//
//  Created by Nagaraju on 19/07/23.
//

import Foundation

 protocol DataRequest {
     func respHandler(completion:@escaping(Result<Data,ErrorHandling>) -> Void)
}




extension URLRequestConvertible {
    /// The URL request.
    ///
    
    func respHandler(completion:@escaping(Result<Data,ErrorHandling>) -> Void){
        
        URLSession.shared.dataTask(with: resultURLRequest!, completionHandler: { data,response,error in
            if let httpResponse = response as? HTTPURLResponse {
                print("error \(httpResponse.statusCode)")
            }
            if let data = data,error == nil{
                completion(.success(data))
            }else {
                completion(.failure(.NoDataFound))
            }
        }).resume()
        
    }
    
}
