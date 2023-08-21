//
//  CacheLanguageUseCaseTests.swift
//  NetWorkLayerTests
//
//  Created by Nagaraju on 17/08/23.
//

import XCTest
@testable import NetWorkLayer


//
//class LocalLanguages {
//    private let store:LangugesStore
//
//    private let currentDate : () -> Date
//
//    init(store : LangugesStore,currentDate: @escaping () -> Date){
//        self.store = store
//        self.currentDate = currentDate
//    }
//
//    func save(_ items: [Datum]) {
//        store.deleteCachedFeed { [unowned self] error in
//            if error == nil {
//                self.store.insert(items, timestamp: self.currentDate())
//            }
//        }
//    }
//
//}
//
//class LangugesStore {
//
//    typealias DeletionCompletion = (Error?) -> Void
//    var deleteCachedFeedCallCount = 0
////    var insertCallCount = 0
//    var insertions = [ (items: [Datum],timestamp:Date)]()
//    private var deletionCompletions = [DeletionCompletion]()
//
//    func deleteCachedFeed(completon:@escaping(DeletionCompletion)) {
//        deleteCachedFeedCallCount += 1
//        deletionCompletions.append(completon)
//    }
//
//    func completeDeletion(with error: Error, at index : Int = 0 ) {
//        deletionCompletions[index](error)
//    }
//    func completeDeletionSuccessfully(at index : Int = 0 ) {
//        deletionCompletions[index](nil)
//    }
//    func insert(_ items: [Datum],timestamp: Date) {
////        insertCallCount += 1
//        insertions.append((items,timestamp))
//    }
//}
//
//final class CacheLanguageUseCaseTests: XCTestCase {
//
//    func test_doesNotDeleteCacheUponCreation() throws {
//
//        let(_,store) = MakeSUT()
//        XCTAssertEqual(store.deleteCachedFeedCallCount,0)
//    }
//
//    func test_save_requestsCacheDeletion() throws {
//
//        let(sut,store) = MakeSUT()
//        let items = [uniqueltem(),uniqueltem()]
//        sut.save(items)
//        XCTAssertEqual(store.deleteCachedFeedCallCount,1)
//    }
//
//
//    func test_save_doesNotRequestCacheInsertion0nDeletionError() throws {
//
//        let(sut,store) = MakeSUT()
//        let items = [uniqueltem(),uniqueltem()]
//        sut.save(items)
//        let deletionError = anyNSError()
//        store.completeDeletion(with: deletionError)
////        XCTAssertEqual(store.insertCallCount,0)
//        XCTAssertEqual(store.insertions.count,0)
//    }
//
////    func test_save_requestsNewCacheInsertion0nSuccessfulDeletion() throws {
////        let(sut,store) = MakeSUT()
////        let items = [uniqueltem(),uniqueltem()]
////        sut.save(items)
////
////        store.completeDeletionSuccessfully()
////        XCTAssertEqual(store.insertCallCount,1)
////    }
//
//    //TimeStamp
//    func test_save_requestsNewCacheInsertionWithTimeStampOnSuccessfulDeletion() throws {
//
//        let timestamp = Date()
//        let(sut,store) = MakeSUT(currentDate:{timestamp})
//        let items = [uniqueltem(),uniqueltem()]
//        sut.save(items)
//        store.completeDeletionSuccessfully()
//        XCTAssertEqual(store.insertions.count,1)
//        XCTAssertEqual(store.insertions.first?.items,items)
//        XCTAssertEqual(store.insertions.first?.timestamp,timestamp)
//    }
//
//    func MakeSUT(currentDate:@escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) ->(sut:LocalLanguages,store:LangugesStore){
//        let store = LangugesStore()
//        let sut  = LocalLanguages(store: store,currentDate:currentDate)
//        trackForMemoryLeaks(store,file: file, line: line)
//        trackForMemoryLeaks(sut,file: file, line: line)
//        return(sut,store)
//    }
//
//    func uniqueltem() -> Datum{
//        return Datum(langID: "1489729", langName: "English", langCode: "en", orientation: "0", statusID: "1")
//    }
//
//    private func anyNSError() -> NSError {
//    return NSError(domain:"any error", code: 0)
//
//    }
//
//
//}


//MARK: Day2


//class LocalLanguages {
//    private let store:LangugesStore
//
//    private let currentDate : () -> Date
//
//    init(store : LangugesStore,currentDate: @escaping () -> Date){
//        self.store = store
//        self.currentDate = currentDate
//    }
//
//    func save(_ items: [Datum],completoin:@escaping (Error?) -> Void) {
//        store.deleteCachedFeed { [unowned self] error in
//
//            if error == nil {
//                self.store.insert(items, timestamp: self.currentDate(), completon:completoin)
//            }else {
//                completoin(error)
//            }
//        }
//    }
//
//}
//
//class LangugesStore {
//
//    typealias DeletionCompletion = (Error?) -> Void
//    typealias InsertionCompletion = (Error?) -> Void
////    var deleteCachedFeedCallCount = 0
////    var insertCallCount = 0
////    var insertions = [ (items: [Datum],timestamp:Date)]()
//    enum recievedMessage:Equatable {
//        case deleteCachedLangauges
//        case insert([Datum],Date)
//    }
//
//    private(set) var recievedMessages = [recievedMessage]()
//    private var deletionCompletions = [DeletionCompletion]()
//    private var insertionCompletions = [InsertionCompletion]()
//
//    func deleteCachedFeed(completon:@escaping(DeletionCompletion)) {
////        deleteCachedFeedCallCount += 1
//        deletionCompletions.append(completon)
//        recievedMessages.append(.deleteCachedLangauges)
//    }
//
//    func completeDeletion(with error: Error, at index : Int = 0 ) {
//        deletionCompletions[index](error)
//    }
//    func completeDeletionSuccessfully(at index : Int = 0 ) {
//        deletionCompletions[index](nil)
//    }
//    func insert(_ items: [Datum],timestamp: Date,completon:@escaping(InsertionCompletion)) {
////        insertCallCount += 1
////        insertions.append((items,timestamp))
//        insertionCompletions.append(completon)
//        recievedMessages.append(.insert(items, timestamp))
//    }
//
//    func completeInsertion(with error: Error, at index : Int = 0 ) {
//        insertionCompletions[index](error)
//    }
//    func completeInsertionSuccessfully(at index :Int = 0) {
//        insertionCompletions[index](nil)
//    }
//}
//
//final class CacheLanguageUseCaseTests: XCTestCase {
//
//    func test_doesNotDeleteMessageToStoreUponCreation() throws {
//
//        let(_,store) = MakeSUT()
////        XCTAssertEqual(store.deleteCachedFeedCallCount,0)
//        XCTAssertEqual(store.recievedMessages,[])
//    }
//
//    func test_save_requestsCacheDeletion() throws {
//
//        let(sut,store) = MakeSUT()
//        let items = [uniqueltem(),uniqueltem()]
//        sut.save(items){ _ in }
////        XCTAssertEqual(store.deleteCachedFeedCallCount,1)
//        XCTAssertEqual(store.recievedMessages,[.deleteCachedLangauges])
//    }
//
//
//    func test_save_doesNotRequestCacheInsertion0nDeletionError() throws {
//
//        let(sut,store) = MakeSUT()
//        let items = [uniqueltem(),uniqueltem()]
//        sut.save(items){ _ in }
//        let deletionError = anyNSError()
//        store.completeDeletion(with: deletionError)
////        XCTAssertEqual(store.insertCallCount,0)
////        XCTAssertEqual(store.insertions.count,0)
//        XCTAssertEqual(store.recievedMessages,[.deleteCachedLangauges])
//    }
//
//    func test_save_failsOnDeletionError() throws {
//
//        let(sut,store) = MakeSUT()
//        let items = [uniqueltem(),uniqueltem()]
//        let deletionError = anyNSError()
//        let exp = expectation(description: "Wait for loading ")
//        var recievedError: Error?
//        sut.save(items){ error in
//            recievedError = error
//            exp.fulfill()
//        }
//        store.completeDeletion(with:deletionError)
//
//        wait(for: [exp], timeout: 1.0)
//        XCTAssertEqual(recievedError as? NSError,deletionError)
//   }
//
//
//    func test_save_failsOnInsertionError() throws {
//
//        let(sut,store) = MakeSUT()
//        let items = [uniqueltem(),uniqueltem()]
//        let insertionError = anyNSError()
//        let exp = expectation(description: "Wait for loading ")
//        var recievedError: Error?
//        sut.save(items){ error in
//            recievedError = error
//            exp.fulfill()
//        }
//        store.completeDeletionSuccessfully()
//        store.completeInsertion(with: insertionError)
//
//        wait(for: [exp], timeout: 1.0)
//        XCTAssertEqual(recievedError as? NSError,insertionError)
//   }
//
//
//    func test_save_succeedsOnSuccessfulCacheInsertion() throws {
//
//        let(sut,store) = MakeSUT()
//        let items = [uniqueltem(),uniqueltem()]
//
//        let exp = expectation(description: "Wait for loading ")
//        var recievedError: Error?
//        sut.save(items){ error in
//            recievedError = error
//            exp.fulfill()
//        }
//        store.completeDeletionSuccessfully()
//        store.completeInsertionSuccessfully()
//
//        wait(for: [exp], timeout: 1.0)
//        XCTAssertNil(recievedError)
//   }
//
//
//
////    func test_save_requestsNewCacheInsertion0nSuccessfulDeletion() throws {
////        let(sut,store) = MakeSUT()
////        let items = [uniqueltem(),uniqueltem()]
////        sut.save(items)
////
////        store.completeDeletionSuccessfully()
////        XCTAssertEqual(store.insertCallCount,1)
////    }
//
//    //TimeStamp
//    func test_save_requestsNewCacheInsertionWithTimeStampOnSuccessfulDeletion() throws {
//
//        let timestamp = Date()
//        let(sut,store) = MakeSUT(currentDate:{timestamp})
//        let items = [uniqueltem(),uniqueltem()]
//        sut.save(items){ _ in }
//        store.completeDeletionSuccessfully()
//        XCTAssertEqual(store.recievedMessages,[.deleteCachedLangauges,.insert(items, timestamp)])
////        XCTAssertEqual(store.insertions.count,1)
////        XCTAssertEqual(store.insertions.first?.items,items)
////        XCTAssertEqual(store.insertions.first?.timestamp,timestamp)
//    }
//
//    func MakeSUT(currentDate:@escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) ->(sut:LocalLanguages,store:LangugesStore){
//        let store = LangugesStore()
//        let sut  = LocalLanguages(store: store,currentDate:currentDate)
//        trackForMemoryLeaks(store,file: file, line: line)
//        trackForMemoryLeaks(sut,file: file, line: line)
//        return(sut,store)
//    }
//
//    func uniqueltem() -> Datum{
//        return Datum(langID: "1489729", langName: "English", langCode: "en", orientation: "0", statusID: "1")
//    }
//
//    private func anyNSError() -> NSError {
//    return NSError(domain:"any error", code: 0)
//
//    }
//
//
//}
//


//MARK: expect
class LocalLanguages {
    private let store:LangugesStore
    private let currentDate : () -> Date
    init(store : LangugesStore,currentDate: @escaping () -> Date){
        self.store = store
        self.currentDate = currentDate
    }
    
    func save(_ items: [Datum],completoin:@escaping (Error?) -> Void) {
        store.deleteCachedFeed { [unowned self] error in
            
            if error == nil {
                self.store.insert(items, timestamp: self.currentDate(), completon:completoin)
            }else {
                completoin(error)
            }
        }
    }
    
}

protocol LangugesStore {
    
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    func deleteCachedFeed(completon:@escaping(DeletionCompletion))
    func insert(_ items: [Datum],timestamp: Date,completon:@escaping(InsertionCompletion))
    
}


final class CacheLanguageUseCaseTests: XCTestCase {
    
    func test_doesNotDeleteMessageToStoreUponCreation() throws {
        
        let(_,store) = MakeSUT()
        XCTAssertEqual(store.recievedMessages,[])
    }
    
    func test_save_requestsCacheDeletion() throws {
       
        let(sut,store) = MakeSUT()
        let items = [uniqueltem(),uniqueltem()]
        sut.save(items){ _ in }
        XCTAssertEqual(store.recievedMessages,[.deleteCachedLangauges])
    }
    
    
    func test_save_doesNotRequestCacheInsertion0nDeletionError() throws {
        
        let(sut,store) = MakeSUT()
        let items = [uniqueltem(),uniqueltem()]
        sut.save(items){ _ in }
        let deletionError = anyNSError()
        store.completeDeletion(with: deletionError)
        XCTAssertEqual(store.recievedMessages,[.deleteCachedLangauges])
    }
    
    func test_save_failsOnDeletionError() throws {
        
        let(sut,store) = MakeSUT()
        let deletionError = anyNSError()
        expect(sut: sut, toCompleteWithError: deletionError, when: {
            store.completeDeletion(with:deletionError)
        })
   }

    func test_save_failsOnInsertionError() throws {
        
        let(sut,store) = MakeSUT()
        let insertionError = anyNSError()
        
        expect(sut: sut, toCompleteWithError: insertionError, when: {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        })
   }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() throws {
        let(sut,store) = MakeSUT()
        expect(sut: sut, toCompleteWithError: nil, when: {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        })
        
   }

    //TimeStamp
    func test_save_requestsNewCacheInsertionWithTimeStampOnSuccessfulDeletion() throws {

        let timestamp = Date()
        let(sut,store) = MakeSUT(currentDate:{timestamp})
        let items = [uniqueltem(),uniqueltem()]
        sut.save(items){ _ in }
        store.completeDeletionSuccessfully()
        XCTAssertEqual(store.recievedMessages,[.deleteCachedLangauges,.insert(items, timestamp)])
    }
    
    private func MakeSUT(currentDate:@escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) ->(sut:LocalLanguages,store:LangugesStoreSPY){
        let store = LangugesStoreSPY()
        let sut  = LocalLanguages(store: store,currentDate:currentDate)
        trackForMemoryLeaks(store,file: file, line: line)
        trackForMemoryLeaks(sut,file: file, line: line)
        return(sut,store)
    }
    
    func uniqueltem() -> Datum{
        return Datum(langID: "1489729", langName: "English", langCode: "en", orientation: "0", statusID: "1")
    }
    
    private func anyNSError() -> NSError {
    return NSError(domain:"any error", code: 0)
    
    }
    
    private func expect(sut:LocalLanguages,toCompleteWithError expectedError: NSError?, when action:() ->Void ,file: StaticString = #file, line: UInt = #line){
       
        let exp = expectation(description: "Wait for loading ")
        var recievedError: Error?
        sut.save([uniqueltem()]){ error in
            recievedError = error
            exp.fulfill()
        }
        action()
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(recievedError as? NSError,expectedError,file: file,line: line)
        
        
    }
    
    private class LangugesStoreSPY: LangugesStore {
        
        typealias DeletionCompletion = (Error?) -> Void
        typealias InsertionCompletion = (Error?) -> Void
       enum recievedMessage:Equatable {
            case deleteCachedLangauges
            case insert([Datum],Date)
        }
        
        private(set) var recievedMessages = [recievedMessage]()
        private var deletionCompletions = [DeletionCompletion]()
        private var insertionCompletions = [InsertionCompletion]()
        
        func deleteCachedFeed(completon:@escaping(DeletionCompletion)) {
            deletionCompletions.append(completon)
            recievedMessages.append(.deleteCachedLangauges)
        }
        
        func completeDeletion(with error: Error, at index : Int = 0 ) {
            deletionCompletions[index](error)
        }
        func completeDeletionSuccessfully(at index : Int = 0 ) {
            deletionCompletions[index](nil)
        }
        func insert(_ items: [Datum],timestamp: Date,completon:@escaping(InsertionCompletion)) {
            insertionCompletions.append(completon)
            recievedMessages.append(.insert(items, timestamp))
        }
        
        func completeInsertion(with error: Error, at index : Int = 0 ) {
            insertionCompletions[index](error)
        }
        func completeInsertionSuccessfully(at index :Int = 0) {
            insertionCompletions[index](nil)
        }
    }
    

}


