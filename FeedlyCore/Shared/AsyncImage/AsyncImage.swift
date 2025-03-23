//
//  AsyncImage.swift
//  Feedly
//
//  Created by Taha Muneeb on 22/03/2025.
//

import Foundation
import Combine

public class AsyncImage {
    private let imageCache: ImageCache
    private let imageLoader: ImageLoader
    
    public init(
        imageCache: ImageCache = ImageCacheClient(cache: DocumentsCacheDirectoryClient()),
        imageLoader: ImageLoader = ImageloaderClient(client: URLSessionHttpClient(session: URLSession.shared))
    ) {
        self.imageCache = imageCache
        self.imageLoader = imageLoader
    }
    
    public func loadImage(from url: URL) -> AnyPublisher<Data, Error> {
        let image = imageCache.loadImage(for: url)
        switch image {
        case .success:
            return imageCache.loadImagePublisher(for: url)
                .subscribe(on: DispatchQueue.global())
                .eraseToAnyPublisher()
        default:
            break
        }
        
        return imageLoader.loadImageDataPublisher(from: url)
            .handleEvents(receiveOutput: { [weak self] data in
                self?.imageCache.saveImage(data, for: url)
            })
            .eraseToAnyPublisher()
    }
}

extension ImageLoader {
    typealias Publisher = AnyPublisher<Data, Error>
    
    func loadImageDataPublisher(from url: URL) -> Publisher {
        var task: HttpClientTask?
        
        return Deferred {
            Future { completion in
                task = self.loadImage(from: url, completion: completion)
            }
        }
        .handleEvents(receiveCancel: { task?.cancel() })
        .eraseToAnyPublisher()
    }
}

extension ImageCache {
    typealias Publisher = AnyPublisher<Data, Error>
    
    func loadImagePublisher(for url: URL) -> Publisher {
        Deferred {
            Future { completion in
                completion(self.loadImage(for: url))
            }
        }
        .eraseToAnyPublisher()
    }
}





