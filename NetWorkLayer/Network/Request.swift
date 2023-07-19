//
//  Request.swift
//  NetWorkLayer
//
//  Created by Nagaraju on 16/07/23.
//

import Foundation
import Combine

/**
 * Used for Post & Get API
 *
 * - parameter url: complete api url
 * - parameter method: if method type can update as user selection
 * - parameter paramters : Enter`ed required parameter for API Call
 * - parameter encoding : it's a parameter encoding given type of parameters
 * - parameter completion : return the filled SuccessModel in complition closure at that place where you called this function. If responce is failure than it return the filled FailureModel in completion closure at that place where you called this function
 */


protocol Request{
     func request(_ url: URLConvertible,method: HTTPMethod,parameters: Parameters?,
        encoding: ParameterEncoder,
        headers: HTTPHeaders?)
        -> URLRequest
}

open class SessionManager:Request {
    
    @discardableResult
    open func request(_ url: URLConvertible,method: HTTPMethod = .get,parameters: Parameters? = nil,encoding: ParameterEncoder = URLEncoding.default,
                      headers: HTTPHeaders? = nil)
        -> URLRequest
    {
        var originalRequest: URLRequest?
        do {
            originalRequest = try? URLRequest(url: url, method: method, headers: headers)
            let encodedURLRequest = try encoding.encode(urlRequest: &originalRequest!, with:parameters)
            return try! encodedURLRequest.asURLRequest()
        } catch {
            return originalRequest!
        }
    }
}
