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
    
    func load() {
        apiRequest.get(url: URL(string:"https://sevenchats.com/auth/languages")!, type:Languges.self, completion: { response in
            switch(response){
            case .success(let data):
                print(data.data)
                self.language  = data.data
            case .failure(let error):
                print(error)
                
            }
        })
        
    }
}
