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
    
    public init(session: URLSession) {
        self.session = session
    }
    
    public func get(_ url: URL, completion: @escaping (HttpClient.Result) -> Void) -> HttpClientTask {
        let task = session.dataTask(with: url) { data, response, error in
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
