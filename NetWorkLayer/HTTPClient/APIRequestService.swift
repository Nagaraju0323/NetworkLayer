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
    
    func load(completion:@escaping() -> Void) {
        apiRequest.get(url: URL(string:"https://sevenchats.com/auth/languages")!, type:Languges.self, completion: { response in
            print(response)
            DispatchQueue.main.async {
                switch(response){
                case .success(let data):
                    self.language  = data.data
                    completion()
                case .failure(let error):
                    print(error)
                    
                }
            }
            
        })
        
    }
}

//https://sevenchats.com/admin/likes/v1/add
