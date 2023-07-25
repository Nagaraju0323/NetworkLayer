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
    
    func test_ApiRequest_Load_IsNill() throws {
        let client = HTTPClient()
        XCTAssertTrue(client.urlRequest.isEmpty)
        
    }
    
    func test_ApiReuest_Load_IsNotNill() throws {
        let (sut,client) = MakeSUT()
        sut.load{ _ in }
        XCTAssertNotNil(client.urlRequest)
    }
    
    func test_APIRequest_Load_IsEqual() throws {
        let url:URL = URL(string: "https://sevenchats.com/auth/languages")!
        let (sut,client) = MakeSUT(url: url)
        sut.load{ _ in}
        XCTAssertEqual(client.urlRequest,[url])
    }
    
    func test_ApiRequestLoadingMultipletimes_validation() throws {
        let url:URL = URL(string: "https://sevenchats.com/auth/languages")!
        let (sut,client) = MakeSUT(url: url)
        sut.load{ _ in}
        sut.load{ _ in}
        XCTAssertEqual(client.urlRequest,[url,url])
        
    }
    
    func test_ApiRequestLodingConnectivityValidation() throws {
        let url:URL = URL(string: "https://sevenchats.com/auth/languages")!
        let (sut,client) = MakeSUT(url: url)
        let clientError = NSError(domain: "test", code: 0)
        expect(sut: sut, toCompleteWitherro: .failures(.Connectivity), when: {
            client.create(with: clientError)
        })
    }
    
    func test_ApiReuestLoadingMultipleErrorHandling() throws {
        let url:URL = URL(string: "https://sevenchats.com/auth/languages")!
        let (sut,client) = MakeSUT(url: url)
        let clientError = [201,300,400,401,500]
        clientError.enumerated().forEach{ index,code in
            expect(sut: sut, toCompleteWitherro: .failures(.InvalidData), when: {
                let json = makeItemsJSON([])
                client.createWithStatus(withStatus: code,data: json,at: index)
            })
        }
    }
    
    func test_ApiRequstLoading_200HttpResonseInvalid_ErrorHandling()throws {
        let url:URL = URL(string: "https://sevenchats.com/auth/languages")!
        let (sut,client) = MakeSUT(url: url)
        
        expect(sut: sut, toCompleteWitherro: .failures(.InvalidData), when: {
            let jsonData = Data(bytes:"JsonInvlid".utf8)
            client.createWithStatus(withStatus: 200,data: jsonData)
        })
    }
    
    func test_ApiRequestLoading_JSONEmptyValidation_ErrorHandling() throws {
        let url:URL = URL(string: "https://sevenchats.com/auth/languages")!
        let (sut,client) = MakeSUT(url: url)
        expect(sut: sut, toCompleteWitherro: .failures(.InvalidData), when: {
            let jsonData = Data(bytes:"{\"data\": []}".utf8)
            client.createWithStatus(withStatus: 200,data: jsonData)
        })
        
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClient()
        var sut: LanguagesViewModel? = LanguagesViewModel(apiRequest: client)
        var captureResult = [LanguagesViewModel.Result]()
        sut?.load { captureResult.append ($0) }
        sut = nil
        client.createWithStatus(withStatus: 200, data: makeItemsJSON([]))
        XCTAssertTrue(captureResult.isEmpty)
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJsonItems() throws {
        let url:URL = URL(string: "https://sevenchats.com/auth/languages")!
        let (sut,client) = MakeSUT(url: url)
        let item1 = makeItem(langID: "1489729", langName: "English", langCode: "en", orientation: "0", statusID: "1")
        
        let item2 = makeItem(langID: "6447288", langName: "Kannada", langCode: "kn", orientation: "0", statusID: "1")
        
        let items = [item1.model,item2.model]
        expect(sut: sut, toCompleteWitherro: .successMsg(items), when: {
            let jsonData = makeItemsLoadJSON([item1.json,item2.json])
            client.createWithStatus(withStatus: 200,data: jsonData)
        })
    }
    
    
    func makeItem(langID:String, langName:String, langCode :String, orientation: String,statusID: String) -> (model:Datum,json:[String:Any]){
        let item = Datum(langID: langID, langName: langName, langCode: langCode, orientation: orientation, statusID: statusID)
        let json = [ "lang_id":langID,
                     "lang_name":langName,
                     "lang_code":langCode,
                     "orientation":orientation,
                     "status_id":statusID
        ].reduce(into: [String:Any]()){ (acc,e) in
            let value = e.value
            acc[e.key] = value
          
        }
        return (item,json)
        
        
    }
    
    func makeItemsJSON(_ items:[[String:Any]]) -> Data{
        let json = ["data":items] as [String : Any]
        print("json Data",json)
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    func makeItemsLoadJSON(_ items:[[String:Any]]) -> Data{
        let json = ["data":items,
                    "meta": [
                            "status": "0",
                            "message": "Success"
                    ]] as [String : Any]
        print(json)
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    //MARK: create Helper
    private func MakeSUT(url:URL = URL(string:"https://sevenchats.com/auth/languages")!,file: StaticString = #file, line: UInt = #line) ->(sut:LanguagesViewModel,client:HTTPClient){
        let client = HTTPClient()
        let sut = LanguagesViewModel(apiRequest: client)
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)
        return (sut,client)
    }
    
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil (instance,"Instance should have been deallocated. Potential memory leak.", file: file,line: line)
        }
    }
    
   
    //MARK: Expect Helper
//    func expect(sut:LanguagesViewModel,toCompleteWitherro Result: LanguagesViewModel.Results, when action:() ->Void,file:StaticString = #file,line:Int=#line){
//        var captureError = [LanguagesViewModel.Results]()
//        sut.load{ captureError.append($0)}
//        action()
//        XCTAssertEqual(captureError, [Result])
//    }
//MARK: Modified the Helper
    
    func expect(sut:LanguagesViewModel,toCompleteWitherro expectedResult: LanguagesViewModel.Result, when action:() ->Void,file:StaticString = #file,line:Int=#line){
//        var captureError = [LanguagesViewModel.Results]()
        let exp = expectation (description: "Wait for load completion")
        
        sut.load{ receivedResult in
            switch (receivedResult,expectedResult) {
            case let (.successMsg(receivedItems),.successMsg(expectedItems)):
                XCTAssertEqual(receivedItems,expectedItems)
            case let (.failures(receivedError), .failures (expectedError)) :
                
                XCTAssertEqual(receivedError,expectedError)
            default:
                
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file,line:UInt(line))
                
            }
            exp.fulfill ()
            
        }
        action()
        wait(for: [exp], timeout: 1.0)
        
//        XCTAssertEqual(captureError, [Result])
    }
    
    
    private class HTTPClient:APIRequest {
        
        var error:Error?
        
        var message = [(url: URL, type: Languges.Type, method: HTTPMethod, completion: (Result<Languges, ErrorHandling>) -> Void)]()
     
        var urlRequest: [URL]{
            return message.map{$0.url }
        }

        func get(url: URL, type:Languges.Type, method: HTTPMethod, completion: @escaping (Result<Languges, ErrorHandling>) -> Void) {
            message.append((url,type,method,completion))
        }
        
        func create(with error:Error,at Index:Int = 0){
            message[Index].completion(.failure(.Connectivity))
        }
        
        func createWithStatus(withStatus code:Int,data :Data = Data(),at Index:Int = 0){
            let response = HTTPURLResponse(url: urlRequest[Index], statusCode: code, httpVersion: nil, headerFields: nil)!
            do{
                let jsonModel = try JSONDecoder().decode(Languges.self, from: data)
                print(jsonModel)
                message[Index].completion(.success(jsonModel))
            }catch(let error){
                message[Index].completion(.failure(.InvalidData))
            }
        }
    }
   
    
}
