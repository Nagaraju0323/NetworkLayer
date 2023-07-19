//
//  APIRequest.swift
//  NetWorkLayer
//
//  Created by Nagaraju on 03/07/23.
//

import Foundation

protocol APIRequest {
    func get(url: URL,type: Languges.Type,completion:@escaping(Result<Languges,ErrorHandling>) -> Void)
}
enum ErrorHandling:Error{
    case BadURL
    case NoDataFound
    case ModelFail
}
//MARK:- HTTPClient
class HTTPClient:APIRequest {
    
    var sessionManager = SessionManager()
    let responseHandlerDelegate:ResponseHandlerDelegate
    let dataResponseHandlerDelegate : DataResponseHandlerDelegate
    init(responseHandlerDelegate: ResponseHandlerDelegate = responseHandler(), dataResponseHandlerDelegate: DataResponseHandlerDelegate = dataResponseHandler(),sessionManager:SessionManager = SessionManager()) {
        self.responseHandlerDelegate = responseHandlerDelegate
        self.dataResponseHandlerDelegate = dataResponseHandlerDelegate
        self.sessionManager = sessionManager
    }
    
    var urlRequest: URL?
    func get<T:Codable>(url: URL,type: T.Type,completion:@escaping(Result<T,ErrorHandling>) -> Void) {
        urlRequest = url
        let header = ["Authorization": "Bearer 0606a2760d8f2edcc21b7ab570ed9d0f4bd923dc", "language": "1", "Content-Type": "application/json", "Accept-Language": "en", "Accept": "application/json"]
        let param = ["page":1,"limit":7]
       
        let reqesst = sessionManager.request(url,method: .get,parameters: param,headers: header)
   
        responseHandlerDelegate.respHandler(url: reqesst, completion: { response in
            switch(response){
            case .success(let responsData):
                self.dataResponseHandlerDelegate.dataHandler(type: type,data: responsData){ responseModel in
                    switch(responseModel){
                    case .success(let ModelData):
                        completion(.success(ModelData))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
                break
            }
        })
    }
}

////MARK: - ResponseHandlerDelegate
protocol ResponseHandlerDelegate{
    func respHandler(url: URLRequest,completion: @escaping(Result<Data,ErrorHandling>) -> Void)
}

class responseHandler :ResponseHandlerDelegate{
    //Apply to the utl to request
    func respHandler(url: URLRequest,completion: @escaping(Result<Data,ErrorHandling>) -> Void){
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data,response,error in
            if let httpResponse = response as? HTTPURLResponse {
                         print("error \(httpResponse.statusCode)")
                      }
            if let data = data,error == nil{
                completion(.success(data))
            }else {
                completion(.failure(.NoDataFound))
            }
        }).resume()
    }
}
////MARK: - DataResponseHandlerDelegate
protocol DataResponseHandlerDelegate {
    func dataHandler<T:Codable>(type:T.Type,data:Data,completion:@escaping(Result<T,ErrorHandling>) ->Void)
}

class dataResponseHandler:DataResponseHandlerDelegate {
    func dataHandler<T:Codable>(type:T.Type,data:Data,completion:@escaping(Result<T,ErrorHandling>) ->Void){
        let jsondata = try? JSONDecoder().decode(type.self, from: data)
        if let jsonRespons = jsondata{
            return completion(.success(jsonRespons))
        }else {
            completion(.failure(.NoDataFound))
        }

    }
}
