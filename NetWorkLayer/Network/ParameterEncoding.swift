//
//  ParameterEncoding.swift
//  NetWorkLayer
//  Created by Nagaraju on 11/07/23.

/**
 * Used for ParameterEncoding
 * - parameter Parameters: Containes the Parameters to Encoding
 * - parameter urlRequest: used for URLRequest
 * - parameter `default`:  default URLEcoding
 * - parameter `JSONParameterEncoders`:  default  Json To parameter Encoding values
 * - parameter `ParameterEncoders`:  default  Json To parameter Encoding values
 */

import Foundation


public typealias Parameters = [String:Any]

enum EncodingMethods {
    case JSONParameterEncoder
    case URLEncoder
    var defaults: ParameterEncoders {
        self == EncodingMethods.JSONParameterEncoder ?
                JSONParameterEncoders.default:URLEncoding.default
    }
}

var JSONParameterEncoder: ParameterEncoders {
    get {
        return JSONParameterEncoders.default
    }
}

var URLEncoder: ParameterEncoders {
    get {
        return URLEncoding.default
    }
}

public protocol ParameterEncoders {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters?) throws -> URLRequest
}

public struct URLEncoding: ParameterEncoders {
    
    
    
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

public struct JSONParameterEncoders: ParameterEncoders {
    
    public static var `default`: JSONParameterEncoders { return JSONParameterEncoders() }
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters?) throws  -> URLRequest {
        guard let parameters = parameters else { return urlRequest }
        do {
            let jsonAsData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
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

/**
 * Used for NetworkError
 * - parameter Error: handling all Error Shwo Failiure cases
 */
public enum NetworkError : String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}
