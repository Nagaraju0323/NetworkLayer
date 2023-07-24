//
//  APIRequestService.swift
//  NetWorkLayer
//
//  Created by Nagaraju on 04/07/23.
//

import Foundation


class LanguagesViewModel {
    let apiRequest : APIRequest
    init(apiRequest: APIRequest = HTTPClient()) {
        self.apiRequest = apiRequest
    }
    var language = [Datum]()
    
    enum Results:Equatable{
       case successMsg([Datum])
       case failures(ErrorHandling)
    }
 
    func load(completion:@escaping(Results) -> Void) {
        apiRequest.get(url: URL(string:"https://sevenchats.com/auth/languages")!, type:Languges.self,method:.get, completion: {  [weak self] response in
            guard self != nil else { return}
                switch(response){
                case .success(let data):
                    self?.language  = data.data
                    completion(.successMsg(data.data))
                case .failure(let error):
                let result =  (error == ErrorHandling.InvalidData) ? completion(.failures(.InvalidData)) : completion(.failures(.Connectivity))
                }
        })
        
    }
}

