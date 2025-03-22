//
//  ImageLoaderClient.swift
//  Feedly
//
//  Created by Taha Muneeb on 21/03/2025.
//

import Foundation

public class ImageloaderClient: ImageLoader {
    private let client: HttpClient
    
    init(client: HttpClient) {
        self.client = client
    }
    
    @discardableResult
    public func loadImage(from url: URL, completion: @escaping (ImageLoader.Result) -> Void) -> HttpClientTask {
        let task = client.get(url) { result in
            switch result {
            case let .success((data, _)):
                completion(.success(data))
            case let .failure(error):
                completion(.failure(error))
            }
        }
        return task
    }
}
