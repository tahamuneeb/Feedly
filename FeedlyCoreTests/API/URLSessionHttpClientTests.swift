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
    
    // MARK: - Helpers
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> HttpClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        
        let sut = URLSessionHttpClient(session: session)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    func aURL() -> URL {
        URL(string: "https://example.com")!
    }
}


