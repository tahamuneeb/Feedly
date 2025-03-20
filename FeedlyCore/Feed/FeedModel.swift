//
//  FeedModel.swift
//  Feedly
//
//  Created by Taha Muneeb on 20/03/2025.
//

import Foundation

public struct FeedModel: Hashable {
    
    public enum MediaType {
        case image
        case video
    }
    
    public let id: Int
    public let url: URL
    public let width: Int
    public let height: Int
    public let creatorName: String
    public let thumbnailUrl: URL?
    public let mediaType: MediaType
}
