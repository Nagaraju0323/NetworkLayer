//
//  StorageContext.swift
//  NetWorkLayer
//
//  Created by Nagaraju on 14/08/23.
//

import Foundation

protocol Storable {}

// Storage abstraction layer
protocol StorageContext {
    /*
     Create a new object with default values
     return an object that is conformed to the `Storable` protocol
     */
    func create<T: Storable>(_ model: T.Type, completion: @escaping ((Any) -> Void)) throws
    /*
     Save an object that is conformed to the `Storable` protocol
     */
    func save(object: Storable) throws
    /*
     Save sequence of objects that are conformed to the `Storable` protocol
     */
    func save(object: [Storable]) throws
    /*
     Update an object that is conformed to the `Storable` protocol
     */
    func update(block: @escaping () -> ()) throws
    /*
     Delete an object that is conformed to the `Storable` protocol
     */
    func delete(object: Storable) throws
    /*
     Delete sequence of objects that are conformed to the `Storable` protocol
     */
    func delete(object: [Storable]) throws
    /*
     Delete all objects that are conformed to the `Storable` protocol
     */
    func deleteAll<T: Storable>(_ model: T.Type) throws
    /*
     Delete all objects from Database
     */
    func reset() throws
    /*
     Return a list of objects that are conformed to the `Storable` protocol
     */
    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: [Sorted]?) -> [T]
    /*
     Return a list of objects that are conformed to the `Storable` protocol
     */
    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?, completion: (([T]) -> ()))
}


extension StorageContext { // extension only for passing default values

    
    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate? = nil, sorted: Sorted? = nil, completion: (([T]) -> ()))
    {
        self.fetch(model, predicate: predicate, sorted: sorted, completion: completion)
    }
    
    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate? = nil, sorted: [Sorted]? = nil) -> [T]
    {
        return fetch(model, predicate: predicate, sorted: sorted)
    }
    
    func save(object: [Storable]) throws
    {
        try save(object: object)
    }
    
    func save(object: Storable) throws
    {
        try save(object: object)
    }
    
}
