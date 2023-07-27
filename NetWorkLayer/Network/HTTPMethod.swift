//
//  HTTPMethod.swift
//  NetWorkLayer
//
//  Created by Nagaraju on 09/07/23.
//

import Foundation

/**
 * Used for HTTPMethod
 *
 * - parameter POST:GET: DELTE:PUT Methods
 * - parameter isPost: if api is post than enter true
 */
public enum HTTPMethods: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}


public enum URLRequestErrorHandling:Error{
    case invalidURL(url: URLConvertibles)
    case badRequest
}
