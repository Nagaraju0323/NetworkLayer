//
//  URLConvertibles.swift
//  NetWorkLayer
//
//  Created by Nagaraju on 11/07/23.
//

import Foundation

/**
 * Used for URLConvertibles
 * - parameter URL:Convert to Response to URL
 * - parameter ErrorHandling: Error handling
 */

public protocol URLConvertibles {
    func asURL() throws -> URL
}

extension String: URLConvertibles {
    public func asURL() throws -> URL {
        guard let url = URL(string: self) else { throw URLRequestErrorHandling.invalidURL(url: self) }
        return url
    }
}

extension URL: URLConvertibles {
    public func asURL() throws -> URL { return self }
}

extension URLComponents: URLConvertibles {
    public func asURL() throws -> URL {
        guard let url = url else { throw URLRequestErrorHandling.invalidURL(url: self) }
        return url
    }
}

// MARK: - URLRequestConvertible
/**
 * Used for URLRequestConvertible
 * - parameter asURLRequest:Convert  URL to URLRequest
 * - parameter Error: Error To Handling 
 */

public protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

extension URLRequestConvertible {
    /// The URL request.
    public var urlRequest: URLRequest? { return try? asURLRequest() }
}

extension URLRequest: URLRequestConvertible {
    /// Returns a URL request or throws if an `Error` was encountered.
    public func asURLRequest() throws -> URLRequest { return self }
}

// MARK: - HTTPHeaders
/**
 * Used for HTTPHeaders
 * - parameter URLConvertibles:Convert to Response to URLReuest
 * - parameter HTTPMethod: handling the HTTPMethods
 * - parameter HTTPHeaders: conveted Header
 */


public typealias HTTPHeaders = [String: String]

extension URLRequest {
    public init(url: URLConvertibles, method: HTTPMethods, headers: HTTPHeaders? = nil) throws {
        let url = try url.asURL()

        self.init(url: url)
        httpMethod = method.rawValue
        if let headers = headers {
            for (headerField, headerValue) in headers {
                setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
    }

    func adapt(using adapter: RequestAdapter?) throws -> URLRequest {
        guard let adapter = adapter else { return self }
        return try adapter.adapt(self)
    }
}


/// A type that can inspect and optionally adapt a `URLRequest` in some manner if necessary.
public protocol RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest
}

    
