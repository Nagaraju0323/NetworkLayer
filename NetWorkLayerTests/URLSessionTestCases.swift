//
//  URLSessionTestCases.swift
//  NetWorkLayerTests
//
//  Created by Nagaraju on 09/08/23.
//

import XCTest
import NetWorkLayer


//URL session HttpClient

public final class URLSessionHTTPClient : HTTPClients {
    let session : URLSession
    init(session: URLSession) {
        self.session = session
    }
    private struct UnexpectedValuesRepresentation : Error { }
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapper : URLSessionTask
        func cancel() {
            wrapper.cancel()
        }
        
        
    }
    
    public func get(url: URL, completion: @escaping (HTTPClients.Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
        task.resume()
        return URLSessionTaskWrapper(wrapper: task)
    }
    
}

//MARK: - urlprocolStub

class URLProtocolStub: URLProtocol {
    
    private struct Stub {
        let data:Data?
        let error:Error?
        let reponse:URLResponse?
        let requestObserver:((URLRequest) -> Void)?
    }
    
    private static let queue = DispatchQueue(label: "URLProtocolStub.queue")
    private static var _stub : Stub?
    private static var stub:Stub? {
        get {return queue.sync {_stub}}
        set {return queue.sync {_stub = newValue}
        }
    }
    
    static func stub(data:Data?,response:URLResponse?,error:Error?) {
        
        stub = Stub(data: data, error: error, reponse: response, requestObserver: nil)
    }
    
    static func observeRequests(observer: @escaping (URLRequest) -> Void) {
        
        stub = Stub(data: nil, error: nil, reponse: nil, requestObserver: observer)
    }
    
    static func removeStub() {
        stub = nil
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        
        
        guard let stub = URLProtocolStub.stub else { return }
        
        if let data = stub.data {
            client?.urlProtocol(self, didLoad: data)
        }
        if let resposne = stub.reponse {
            client?.urlProtocol(self, didReceive: resposne, cacheStoragePolicy: .notAllowed)
        }
        
        if let error = stub.error {
            client?.urlProtocol(self, didFailWithError: error)
        }else {
            client?.urlProtocolDidFinishLoading(self)
        }
        stub.requestObserver?(request)
    }
    override func stopLoading() {}
}



func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyData() -> Data {
    return Data("any data".utf8)
}



final class URLSessionTestCases: XCTestCase {
    
    
    override func tearDown() {
        super.tearDown()
        
        URLProtocolStub.removeStub()
    }
    
    func test_getFromURL_performsGETRequestWithURL() throws {
        
        let url = anyURL()
        let exp = expectation(description: "wait for loading .......")
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        MakeSUT().get(url: url){ _ in }
        wait(for: [exp], timeout: 1)
    }
    
    func test_cancelGetFromURLTask_cancelsURLRequest() throws {
        
        let reciviedError = resultForError(taskHandler: {$0.cancel() }) as? NSError
        XCTAssertEqual(reciviedError?.code, URLError.cancelled.rawValue)
        
    }
    
    func test_getFromURL_failsOnRequestError() throws {
        
        let requestError = anyNSError()
        
        let receivedError = resultForError((data: nil, response: nil, error: requestError))
        
        XCTAssertNotNil(receivedError)
        
        
    }
    
    func test_getFromURL_failsOnAllInvalidRepresentationCases() throws {
        
        XCTAssertNotNil(resultForError((data: nil, response: nil, error: nil)))
        XCTAssertNotNil(resultForError((data: nil, response: nil, error: nil)))
        XCTAssertNotNil(resultForError((data: nil, response: nonHTTPURLResponse(), error: nil)))
        XCTAssertNotNil(resultForError((data: anyData(), response: nil, error: nil)))
        XCTAssertNotNil(resultForError((data: anyData(), response: nil, error: anyNSError())))
        XCTAssertNotNil(resultForError((data: nil, response: nonHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultForError((data: nil, response: anyHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultForError((data: anyData(), response: nonHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultForError((data: anyData(), response: anyHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultForError((data: anyData(), response: nonHTTPURLResponse(), error: nil)))
    }
    
    func test_getFromURL_succeedsOnHTTPURLResponseWithData() {
        let data = anyData()
        let response = anyHTTPURLResponse()
        
        let receivedValues = resultValuesFor((data: data, response: response, error: nil))
        
        XCTAssertEqual(receivedValues?.data, data)
        XCTAssertEqual(receivedValues?.response.url, response.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
    }
    
    func test_getFromURL_succeedsWithEmptyDataOnHTTPURLResponseWithNilData() {
        let response = anyHTTPURLResponse()
        
        let receivedValues = resultValuesFor((data: nil, response: response, error: nil))
        
        let emptyData = Data()
        XCTAssertEqual(receivedValues?.data, emptyData)
        XCTAssertEqual(receivedValues?.response.url, response.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
    }
    
    func MakeSUT(file: StaticString = #filePath , line: UInt = #line) -> HTTPClients {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let sut = URLSessionHTTPClient(session: session)
        trackForMemoryLeaks(sut, file:file,line: line)
        return sut
    }
    
    
    
    //resutl
    
    private func resultFor(_ value: (data:Data?,response:URLResponse?,error:Error?)? = nil, taskHandler : (HTTPClientTask) -> Void = { _ in }, file : StaticString = #filePath,line: UInt = #line) -> HTTPClients.Result {
        
        value.map{ URLProtocolStub.stub(data: $0, response: $1, error: $2) }
        
        let sut = MakeSUT(file:file,line: line)
        let exp = expectation(description: "Wait for completion")
        var reciedHandler : HTTPClients.Result!
        
        taskHandler(sut.get(url:anyURL()) { result in
            reciedHandler  = result
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 1.0)
        return reciedHandler
        
    }
    
    
    private func resultForError(_ value: (data:Data?,response:URLResponse?,error:Error?)? = nil, taskHandler : (HTTPClientTask) -> Void = { _ in }, file : StaticString = #filePath,line: UInt = #line) -> Error? {
        let result = resultFor(value, taskHandler: taskHandler, file: file, line: line)
        switch result {
        case let .failure(error) :
            return error
        default:
            XCTFail("Expected failure, got \(result) instead", file: file, line: line)
            return nil
        }
    }
    
    
    private func resultValuesFor(_ value: (data:Data?,response:URLResponse?,error:Error?)? = nil, taskHandler : (HTTPClientTask) -> Void = { _ in }, file : StaticString = #filePath,line: UInt = #line) -> (data: Data, response: HTTPURLResponse)? {
        let result = resultFor(value, file: file, line: line)
        switch result {
        case let .success(resultdata) :
            return resultdata
        default:
            XCTFail("Expected success, got \(result) instead", file: file, line: line)
            return nil
        }
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
    
}



