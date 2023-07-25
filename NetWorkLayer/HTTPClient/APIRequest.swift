//
//  APIRequest.swift
//  NetWorkLayer
//
//  Created by Nagaraju on 03/07/23.
//

import Foundation

public enum ErrorHandling:Swift.Error{
    case success
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case unableToDecode
    case Connectivity
    case InvalidData
}

protocol APIRequest {
    func get(url: URL,type: Languges.Type,method:HTTPMethod,completion:@escaping(Result<Languges,ErrorHandling>) -> Void)
}


//MARK:- HTTPClient
class HTTPClient:APIRequest {
    
    var sessionManager = SessionManager()
    var responseHandlerDelegate : ResponseHandlerDelegate
    
    init(sessionManager:SessionManager = SessionManager(),responseHandlerDelegate:ResponseHandlerDelegate = ResponseHandler()) {
        self.sessionManager = sessionManager
        self.responseHandlerDelegate = responseHandlerDelegate
    }
    var urlRequest: URL?
    func get<T:Codable>(url: URL,type: T.Type,method:HTTPMethod,completion:@escaping(Result<T,ErrorHandling>) -> Void) {
        urlRequest = url
        let header = ["Authorization": "Bearer a57e4291e388d6c42cab70875b08750e6ec7755f", "language": "1", "Content-Type": "application/json", "Accept-Language": "en", "Accept": "application/json"]
        sessionManager.request(url,method: method,parameters: nil,encoding: JSONParameterEncoder.default, headers: header).responseJSON{ response in
            switch response{
            case .success(let data):
                self.responseHandlerDelegate.fetchModel(type: type, data: data){ response in
                    switch response{
                    case .success(let ModelData):
                        completion(.success(ModelData))
                    case .failure(_):
                        completion(.failure(.unableToDecode))
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
}


protocol ResponseHandlerDelegate {
    func fetchModel<T: Codable>(type: T.Type, data: Data, completion: (Result<T, ErrorHandling>) -> Void)
}

class ResponseHandler: ResponseHandlerDelegate {
    func fetchModel<T: Codable>(type: T.Type, data: Data, completion: (Result<T, ErrorHandling>) -> Void) {
        let commentResponse = try? JSONDecoder().decode(type.self, from: data)
        if let commentResponse = commentResponse {
            return completion(.success(commentResponse))
        } else {
            completion(.failure(.unableToDecode))
        }
    }
    
}

