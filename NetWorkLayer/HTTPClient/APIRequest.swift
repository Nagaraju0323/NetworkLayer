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
    func get(url: URL,type: Languges.Type,method:HTTPMethods,encoding:EncodingMethods,completion:@escaping(Result<Languges,ErrorHandling>) -> Void)
}

class APIRequestService:APIRequest{

    func get(url: URL,type: Languges.Type,method:HTTPMethods,encoding:EncodingMethods,completion:@escaping(Result<Languges,ErrorHandling>) -> Void){
        HTTPClient().get(url: url, type: type.self, method: method, encoding: encoding, completion: completion)
    }
    
}

//MARK:- HTTPClient
class HTTPClient {
    
    var sessionManager = SessionManager()
    var responseHandlerDelegate : ResponseHandler_Delegate
    
    init(sessionManager:SessionManager = SessionManager(),responseHandlerDelegate:ResponseHandler_Delegate = Response_Handler()) {
        self.sessionManager = sessionManager
        self.responseHandlerDelegate = responseHandlerDelegate
    }
    var urlRequest: URL?
    func get<T:Codable>(url: URL,type: T.Type,param:[String:Any] = [:],method:HTTPMethods,encoding:EncodingMethods,completion:@escaping(Result<T,ErrorHandling>) -> Void) {
     
        urlRequest = url

        let header =  ["Authorization" : "Bearer 8ef277524a20db15131494936c2fdd0fb6c41e5a","Content-Type" : "application/json", "Accept-Language" :"en", "language":"14897296","Accept" : "application/json"]
        let param = [String:Any]()
            

        let encodingMethod = EncodingMethods.URLEncoder == encoding ? EncodingMethods.URLEncoder.defaults : EncodingMethods.JSONParameterEncoder.defaults

        sessionManager.request(url,method: .get,parameters: param.isEmpty ? nil : param,encoding:encodingMethod, headers: header).responseJSON{ response in
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
               
                print("response Error\(error)")
            }
        }
        
    }
}

protocol ResponseHandler_Delegate {
    func fetchModel<T: Codable>(type: T.Type, data: Data, completion: (Result<T, ErrorHandling>) -> Void)
}

class Response_Handler: ResponseHandler_Delegate {
    func fetchModel<T: Codable>(type: T.Type, data: Data, completion: (Result<T, ErrorHandling>) -> Void) {
        let commentResponse = try? JSONDecoder().decode(type.self, from: data)
        if let commentResponse = commentResponse {
            return completion(.success(commentResponse))
        } else {
            completion(.failure(.unableToDecode))
        }
    }
    
}

