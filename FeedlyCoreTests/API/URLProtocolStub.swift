//
//  URLProtocolStub.swift
//  Feedly
//
//  Created by Taha Muneeb on 20/03/2025.
//
import Foundation

class URLProtocolStub: URLProtocol {
    
    private struct Stub {
        let onLoadingStart: (URLProtocolStub) -> Void
    }
    
    private static let queue = DispatchQueue(label: "URLProtocolStub.queue")
    
    private static var _stub: Stub?
    private static var stub: Stub? {
        get { return queue.sync { _stub } }
        set { queue.sync { _stub = newValue } }
    }
    
    override func startLoading() {
        URLProtocolStub.stub?.onLoadingStart(self)
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func stopLoading() {
    }
}

extension URLProtocolStub {
    static func stub(data: Data?, response: URLResponse?, error: Error?) {
        stub = Stub(onLoadingStart: { urlProtocol in
            guard let client = urlProtocol.client else { return }
            
            if let data {
                client.urlProtocol(urlProtocol, didLoad: data)
            }
            
            if let response {
                client.urlProtocol(urlProtocol, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error {
                client.urlProtocol(urlProtocol, didFailWithError: error)
            } else {
                client.urlProtocolDidFinishLoading(urlProtocol)
            }
        })
    }
    
    static func observeRequests(observer: @escaping (URLRequest) -> Void) {
        stub = Stub(onLoadingStart: { urlProtocol in
            urlProtocol.client?.urlProtocolDidFinishLoading(urlProtocol)
            observer(urlProtocol.request)
        })
    }
    
    static func onLoadingStart(observer: @escaping () -> Void) {
        stub = Stub(onLoadingStart: { _ in observer() })
    }
    
    static func removeStub() {
        stub = nil
    }
}
