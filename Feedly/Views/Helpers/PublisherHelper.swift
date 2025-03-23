//
//  PublisherHelper.swift
//  Feedly
//
//  Created by Taha Muneeb on 23/03/2025.
//

import Foundation
import FeedlyCore
import Combine

public extension HttpClient {
    typealias Publisher = AnyPublisher<(Data, HTTPURLResponse), Error>

    func getPublisher(url: URL) -> Publisher {
        var task: HttpClientTask?

        return Deferred {
            Future { completion in
                task = self.get(url, completion: completion)
            }
        }
        .handleEvents(receiveCancel: { task?.cancel() })
        .eraseToAnyPublisher()
    }
}
