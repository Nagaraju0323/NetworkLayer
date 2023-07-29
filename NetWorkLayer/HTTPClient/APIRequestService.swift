//
//  APIRequestService.swift
//  NetWorkLayer
//
//  Created by Nagaraju on 04/07/23.
//

import Foundation


enum Results {
    case successMsg([Languges])
    case failures(ErrorHandling)
}

//extension Results: Equatable where Error: Equatable {}

class LanguagesViewModel {
    
    let apiRequest : APIRequest
    init(apiRequest: APIRequest = APIRequestService()) {
        self.apiRequest = apiRequest
    }
    
    var language = [Quote]()
    
    public typealias Result = Results
    
    func load(completion:@escaping(Result) -> Void) {
        apiRequest.get(url: URL(string:"https://sevenchats.com/admin/quotes/all")!, type:Languges.self,method:.get, encoding: EncodingMethods.URLEncoder, completion: {  [weak self] response in
            guard self != nil else { return}
            DispatchQueue.main.async {
                switch(response){
                case .success(let data):
                    self?.language  = data.quotes.quotes
                    completion(.successMsg([data]))
                case .failure(let error):
                    let result =  (error == ErrorHandling.InvalidData) ? completion(.failures(.InvalidData)) : completion(.failures(.Connectivity))
                }
                
            }
            
        })
        
    }
}

