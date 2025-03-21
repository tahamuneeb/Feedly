//
//  FeedModel.swift
//  Feedly
//
//  Created by Taha Muneeb on 20/03/2025.
//

import Foundation

public struct FeedModel: Hashable {
    
    public enum MediaType: String {
        case image = "Photo"
        case video = "Video"
    }
    
    public let id: Int
    public let url: URL
    public let width: Int
    public let height: Int
    public let creatorName: String
    public let thumbnailUrl: URL?
    public let mediaType: MediaType
    
    public init(
        id: Int,
        url: URL,
        width: Int,
        height: Int,
        creatorName: String,
        thumbnailUrl: URL?,
        mediaType: MediaType
    ) {
        self.id = id
        self.url = url
        self.width = width
        self.height = height
        self.creatorName = creatorName
        self.thumbnailUrl = thumbnailUrl
        self.mediaType = mediaType
    }
}
