//
//  URLSessionHttpClientTests.swift
//  Feedly
//
//  Created by Taha Muneeb on 20/03/2025.
//

import XCTest
import FeedlyCore

class URLProtocolStub: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        
    }
}

final class URLSessionHttpClientTests: XCTestCase {

    func test_memoryLeak() {
        _ = makeSUT()
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
}


