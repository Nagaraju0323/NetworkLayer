//
//  Endpoint.swift
//  NetWorkLayer
//
//  Created by Nagaraju on 08/07/23.
//

import Foundation
import Combine

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: SessionManager { get }
    var headers: HTTPHeaders? { get }
}

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
