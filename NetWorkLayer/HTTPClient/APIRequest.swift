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
//        let header = ["Content-Type": "application/json"]
        
        let header =  ["Authorization" : "Bearer 8ef277524a20db15131494936c2fdd0fb6c41e5a","Content-Type" : "application/json", "Accept-Language" :"en", "language":"14897296","Accept" : "application/json"]
        
       let url = URL(string:"https://sevenchats.com/admin/quotes/all")!
        
        let param = [
            "limit":7,
            "page":1
        
        ] as? [String:Any]
            
//            let url = URL(string:"https://sevenchats.com/admin/likes/v1/add")!
//
//             let param = [
//                 "user_id":"6e6c656a646e6a6b","element_id":"27279568","like_status":"2","post_user":"31879376","type":"post","postType":"shout","post":["post_id":"27279568","type":"shout","user_email":"","user_id":"31879376","first_name":"Naga","last_name":"Raju","profile_image":"","post_detail":"drgfdgf","targeted_audience":"2","selected_persons":"[]","is_liked":"No","likes":"1","comments":"0","shared_count":"0","shared_type":"N/A","shared_message":"N/A","shared_id":"N/A","shared_first_name":"No User Details","shared_last_name":"No User Details","shared_profile_image":"No User Details","shared_post_date":"N/A","created_at":"Wed Jan 11 2023 07:09:49 GMT+0000 (Coordinated Universal Time)","updated_at":"Wed Jan 11 2023 07:09:49 GMT+0000 (Coordinated Universal Time)","status_id":"1"]
            

//        ] as [String:Any]
        
        let encoding = EncodingMethods.URLEncoder.defaults
        
        
        sessionManager.request(url,method: .get,parameters: param,encoding:encoding, headers: header).responseJSON{ response in
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

