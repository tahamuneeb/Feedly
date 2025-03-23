//
//  FeedEndpoint.swift
//  Feedly
//
//  Created by Taha Muneeb on 23/03/2025.
//

import Foundation

public enum FeedEndpoint {
    case get(String)

    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(collectionId):
            return baseURL.appendingPathComponent("collections/\(collectionId)")
        }
    }
}
