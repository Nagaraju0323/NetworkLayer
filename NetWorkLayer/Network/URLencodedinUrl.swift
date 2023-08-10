//
//  URLencodedinUrl.swift
//  NetWorkLayer
//
//  Created by Nagaraju on 10/08/23.
//

import Foundation
import UIKit

public enum Destination {
    case methodDependent, queryString, httpBody
}

public enum ArrayEncoding {
    case brackets, noBrackets

    func encode(key: String) -> String {
        switch self {
        case .brackets:
            return "\(key)[]"
        case .noBrackets:
            return key
        }
    }
}

public enum BoolEncoding {
    case numeric, literal

    func encode(value: Bool) -> String {
        switch self {
        case .numeric:
            return value ? "1" : "0"
        case .literal:
            return value ? "true" : "false"
        }
    }
}

public struct URLencodedinUrl: ParameterEncoders {

    
    public let destination: Destination

    /// The encoding to use for `Array` parameters.
    public let arrayEncoding: ArrayEncoding

    /// The encoding to use for `Bool` parameters.
    public let boolEncoding: BoolEncoding
    
    public init(destination: Destination = .methodDependent, arrayEncoding: ArrayEncoding = .brackets, boolEncoding: BoolEncoding = .numeric) {
        self.destination = destination
        self.arrayEncoding = arrayEncoding
        self.boolEncoding = boolEncoding
    }
    
    public static var `default`: URLencodedinUrl { return URLencodedinUrl() }
    
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters?) throws -> URLRequest {
        guard let parameters = parameters else { return urlRequest }
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
        urlRequest.setValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language");
        urlRequest.httpBody = query(parameters).data(using: .utf8, allowLossyConversion: false)
     return urlRequest
    }
    
    
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []

        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []

        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: arrayEncoding.encode(key: key), value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((escape(key), escape(boolEncoding.encode(value: value.boolValue))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape(boolEncoding.encode(value: bool))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }

        return components
    }
    
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        var escaped = ""

        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex

            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex

                let substring = string[range]

                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? String(substring)

                index = endIndex
            }
        }

        return escaped
    }
    
   
}

extension NSNumber {
    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}



 protocol selectURLEncodingDelegate {
    func encodingType(encodingMethod: EncodingMethods) -> ParameterEncoders
}

 class URLEncodingType: selectURLEncodingDelegate {
    public func encodingType(encodingMethod encodingMethodType: EncodingMethods) -> ParameterEncoders{
        let encodingMethod : ParameterEncoders
        switch encodingMethodType{
        case EncodingMethods.URLEncoder :
            encodingMethod = EncodingMethods.URLEncoder.defaults
        case EncodingMethods.JSONParameterEncoder:
            encodingMethod = EncodingMethods.JSONParameterEncoder.defaults
        case EncodingMethods.URLEncodedFormEncoder:
            encodingMethod = EncodingMethods.URLEncodedFormEncoder.defaults
        }
        return encodingMethod
    }
    
}
