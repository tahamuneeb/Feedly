//
//  URLSessionHttpClient.swift
//  Feedly
//
//  Created by Taha Muneeb on 20/03/2025.
//

import Foundation

public final class URLSessionHttpClient: HttpClient {
    
    private struct UnexpectedResults: Error {}

    private struct URLSessionTaskWrapper: HttpClientTask {
        let wrapped: URLSessionTask

        func cancel() {
            wrapped.cancel()
        }
    }
    
    private let session: URLSession
    private let header: [String: String]?
    
    public init(session: URLSession, header: [String: String]? = nil) {
        self.session = session
        self.header = header
    }
    
    public func get(_ url: URL, completion: @escaping (HttpClient.Result) -> Void) -> HttpClientTask {
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = header
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(UnexpectedResults()))
            }
        }
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }
}
