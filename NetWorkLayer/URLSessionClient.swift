//
//  URLSessionClient.swift
//  NetWorkLayer
//
//  Created by Nagaraju on 09/08/23.
//

import Foundation


public protocol HTTPClientTask {
    func cancel()
}
    

public protocol HTTPClients {

    typealias Result = Swift.Result<(Data,HTTPURLResponse),Error>
    @discardableResult
    func get(url:URL,completion:@escaping(Result) -> Void) -> HTTPClientTask
    
}


