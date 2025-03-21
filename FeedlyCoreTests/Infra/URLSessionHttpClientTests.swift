//
//  URLSessionHttpClientTests.swift
//  Feedly
//
//  Created by Taha Muneeb on 20/03/2025.
//

import XCTest
import FeedlyCore



final class URLSessionHttpClientTests: XCTestCase {
    
    func test_memoryLeak() {
        _ = makeSUT()
    }
    
    func test_clientGetFromURL_callsGETRequest() {
        let url = aURL()
        let sut = makeSUT()
        
        let exp = expectation(description: "Wait for request")

        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        sut.get(url, completion: { _ in})
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getURL_givesErrorOnRequestFailure() {
        let requestError = anError()
        let receivedError = resultErrorFor((data: nil, response: nil, error: requestError))
        XCTAssertNotNil(receivedError)
    }
    
    func test_cancelRequestTask_cancelsRequest() {
        var task: HttpClientTask?
        URLProtocolStub.onLoadingStart { task?.cancel() }
        let receivedError = resultErrorFor(taskHandler: { task = $0 }) as NSError?
        XCTAssertEqual(receivedError?.code, URLError.cancelled.rawValue)
    }
    
    func test_getURL_giveSuccessOnHttpData() {
        let data = aData()
        let response = aHTTPURLResponse()

        let receivedValues = resultFor((data: data, response: response, error: nil))
        switch receivedValues {
        case let .success((receievedData, receievedDataResponse)):
            XCTAssertEqual(receievedData, data)
            XCTAssertEqual(receievedDataResponse.url, response.url)
            XCTAssertEqual(receievedDataResponse.statusCode, response.statusCode)
        default:
            break
        }
    }

    func test_getUR_giveSuccessOnEmptyHttpData() {
        let response = aHTTPURLResponse()

        let receivedValues = resultFor((data: nil, response: response, error: nil))

        let emptyData = Data()
        switch receivedValues {
        case let .success((receievedData, receievedDataResponse)):
            XCTAssertEqual(receievedData, emptyData)
            XCTAssertEqual(receievedDataResponse.url, response.url)
            XCTAssertEqual(receievedDataResponse.statusCode, response.statusCode)
        default:
            break
        }
    }
        
    // MARK: - Helpers
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> HttpClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        
        let sut = URLSessionHttpClient(session: session)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func resultErrorFor(_ values: (data: Data?, response: URLResponse?, error: Error?)? = nil,
                                taskHandler: (HttpClientTask) -> Void = { _ in },
                                file: StaticString = #filePath,
                                line: UInt = #line
    ) -> Error? {
        let result = resultFor(values, taskHandler: taskHandler, file: file, line: line)

        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("Failure, got \(result)", file: file, line: line)
            return nil
        }
    }

    private func resultFor(_ values: (data: Data?, response: URLResponse?, error: Error?)?,
                           taskHandler: (HttpClientTask) -> Void = { _ in },
                           file: StaticString = #filePath,
                           line: UInt = #line
    ) -> HttpClient.Result {
        values.map { URLProtocolStub.stub(data: $0, response: $1, error: $2) }

        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for completion")

        var receivedResult: HttpClient.Result!
        taskHandler(sut.get(aURL()) { result in
            receivedResult = result
            exp.fulfill()
        })

        wait(for: [exp], timeout: 1.0)
        return receivedResult
    }

    private func aHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: aURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }

    private func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: aURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
}


