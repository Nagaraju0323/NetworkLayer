//
//  NetWorkLayerTests.swift
//  NetWorkLayerTests
//
//  Created by Nagaraju on 03/07/23.
//

import XCTest
@testable import NetWorkLayer

final class NetWorkLayerTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_endToEndTestServerGETFeedResult_matchesFixedTestAccountData() throws {
        
        switch getResultLanguages() {
        case .successMsg(let items)?:
            XCTAssertEqual(items.count,2,"Expected 8 items in the test account feed")
            
            items.enumerated().forEach{(index,item) in
                XCTAssertEqual (item, expectedItem(at: index),"unexpected item value \(index)")
            }
        case .failures(let error):
            XCTFail("Exoected successf½ feed result, got \(error) instead")
        default:
            XCTFail("Expected successful feed result, got no result instead")
        }
        
    }
    
    func getResultLanguages(file: StaticString = #file, line: UInt = #line) -> Results? {
        
        let URL = URL(string: "https://sevenchats.com/auth/languages")!
        let client = HTTPClient()
        let loader = LanguagesViewModel(apiRequest: APIRequestService())
        let exp = expectation(description: "wait For load completion")
        var resciviedResult : Results?
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        
        loader.load{ result in
            resciviedResult = result
            exp.fulfill()
        }
        wait(for: [exp],timeout: 5.0)
        
        return resciviedResult
        
    }
    
    //HelperFuncation
    
    private func expectedItem(at index:Int) -> Datum{
        return Datum(langID: langID(at:index),
                     langName: langName(at: index),
                     langCode: langCode(at:index),
                     orientation:orientation(at:index) ,
                     statusID: statusID(at:index))
        
    }
    
    private func langID(at index: Int) -> String {
        return [
            "14897296",
            "6447288"][index]
    }
    private func langName(at index: Int) -> String {
        return [
            "English",
            "Kannada"][index]
    }
    private func langCode(at index: Int) -> String {
        return [
            "en",
            "kn"][index]
    }
    private func orientation(at index: Int) -> String {
        return [
            "0",
            "0"][index]
    }
    private func statusID(at index: Int) -> String {
        return [
            "1",
            "1"][index]
    }
    
    
    
    
}
