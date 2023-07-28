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
    case ServicerErrorBadGateway
    case BadRequest
}

protocol APIRequest {
    
    func get(url: URL,type: Languges.Type,method:HTTPMethods,completion:@escaping(Result<Languges,ErrorHandling>) -> Void)
    
    
    
}


class APIRequestService:APIRequest{
    
    func get(url: URL,type: Languges.Type,method:HTTPMethods,completion:@escaping(Result<Languges,ErrorHandling>) -> Void){
        HTTPClient().get(url: url, type: type.self, method: method, completion: completion)
    }
    
}







//MARK:- HTTPClient
class HTTPClient {
    
    var sessionManager = SessionManager()
    var responseHandlerDelegate : ResponseHandlerDelegate
    
    init(sessionManager:SessionManager = SessionManager(),responseHandlerDelegate:ResponseHandlerDelegate = ResponseHandler()) {
        self.sessionManager = sessionManager
        self.responseHandlerDelegate = responseHandlerDelegate
    }
    var urlRequest: URL?
    func get<T:Codable>(url: URL,type: T.Type,method:HTTPMethods,completion:@escaping(Result<T,ErrorHandling>) -> Void) {
        urlRequest = url
        let header = ["Content-Type": "application/json"]
        
       let url = URL(string:"https://ed40-2406-7400-63-33d0-1c59-753c-e183-52c4.ngrok.io/users/1")!
        
        let param = [
            "first name": "nagarjuna",
            "last name": "kmj",
            "subjectId": 2,
            "id": 1

        ] as [String:Any]
       sessionManager.request(url,method: .put,parameters: param,encoding: JSONParameterEncoders.default, headers: header).responseJSON{ response in
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

