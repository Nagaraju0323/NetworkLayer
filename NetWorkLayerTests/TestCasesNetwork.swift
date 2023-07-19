//
//  TestCasesNetwork.swift
//  NetWorkLayerTests
//
//  Created by Nagaraju on 04/07/23.
//

import XCTest
@testable import NetWorkLayer

final class TestCasesNetwork: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    //MARK: -
    
    func test_ApiRequest_Load_IsNill() throws{
        let client = HTTPClient()
        XCTAssertNil(client.urlRequest)
        
    }
    
    func test_ApiReuest_Load_IsNotNill() throws{
        let client = HTTPClient()
        let sut = LanguagesViewModel(apiRequest:client)
        sut.load()
        XCTAssertNotNil(client.urlRequest)
    }
    
    func test_APIRequest_Load_IsEqual() throws{
        let url:URL = URL(string: "https://sevenchats.com/auth/languages")!
        let client = HTTPClient()
        let sut = LanguagesViewModel(apiRequest:client)
        sut.load()
        XCTAssertEqual(client.urlRequest,url)
        
    }
    
    
    
    //MARK: create Helper
   
    

   
   
}
