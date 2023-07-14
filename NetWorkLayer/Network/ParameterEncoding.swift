//
//  ParameterEncoding.swift
//  NetWorkLayer
//
//  Created by Nagaraju on 11/07/23.
//

import Foundation


public typealias Parameters = [String:Any]

public protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters?) throws -> URLRequest
}

public struct URLEncoding: ParameterEncoder {
    
    public static var `default`: URLEncoding { return URLEncoding() }
    
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters?) throws -> URLRequest {
        
        
        guard let parameters = parameters else { return urlRequest }
        
        guard let url = urlRequest.url else { throw NetworkError.missingURL }
        
        if var urlComponents = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false), !parameters.isEmpty {
            
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key,value) in parameters {
                let queryItem = URLQueryItem(name: key,
                                             value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        return urlRequest
        
    }
    
    
}

public struct JSONParameterEncoder: ParameterEncoder {
    
    public static var `default`: JSONParameterEncoder { return JSONParameterEncoder() }
    
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters?) throws  -> URLRequest {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            return urlRequest
        }catch {
            throw NetworkError.encodingFailed
        }
        
    }
}



public enum NetworkError : String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}
