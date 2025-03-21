//
//  FeedDataMapper.swift
//  Feedly
//
//  Created by Taha Muneeb on 20/03/2025.
//
import Foundation

public final class FeedDataMapper {
    
    public enum Error: Swift.Error {
        case invalidData
    }

    public static func map(_ data: Data, response: HTTPURLResponse) throws -> [FeedModel] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidData
        }

        return root.getFeeds()
    }
}

// MARK: - Root
fileprivate struct Root: Decodable {
    let media: [Media]?
    
    func getFeeds() -> [FeedModel] {
        return media?.compactMap { media in
            var resourceURL = URL(filePath: "")
            var thumnailURL: URL?
            var creatorName: String = ""
            switch media.type {
            case .photo:
                if let url = media.src?.large {
                    resourceURL = url
                }
                
                creatorName = media.photographer ?? ""
            case .video:
                if let url = media.videoFiles?.first(where: { $0.quality == "sd"})?.link {
                    resourceURL = url
                }
                creatorName = media.user?.name ?? ""
                if let url = media.image {
                    thumnailURL = url
                }
            }
            return FeedModel(
                id: media.id,
                url: resourceURL,
                width: media.width,
                height: media.height,
                creatorName: creatorName,
                thumbnailUrl: thumnailURL,
                mediaType: FeedModel.MediaType(rawValue: media.type.rawValue) ?? .image
            )
        } ?? []
    }
}

// MARK: - MediaType
fileprivate enum MediaType: String, Decodable {
    case photo = "Photo"
    case video = "Video"
}

// MARK: - Media
fileprivate struct Media: Decodable {
    let type: MediaType
    let id, width, height: Int
    let photographer: String?
    let src: Src?
    let duration: Int?
    let user: User?
    let image: URL?
    let videoFiles: [VideoFile]?
    let videoPictures: [VideoPicture]?

    enum CodingKeys: String, CodingKey {
        case type, id, width, height, photographer, src, duration, user, image
        case videoFiles = "video_files"
        case videoPictures = "video_pictures"
    }
}

// MARK: - Src
fileprivate struct Src: Decodable {
    let large: URL?
}

// MARK: - User
fileprivate struct User: Decodable {
    let name: String?
}

// MARK: - VideoFile
fileprivate struct VideoFile: Decodable {
    let id: Int?
    let quality, fileType: String?
    let width, height: Int?
    let fps: Double?
    let link: URL?
    let size: Int?

    enum CodingKeys: String, CodingKey {
        case id, quality
        case fileType = "file_type"
        case width, height, fps, link, size
    }
}

// MARK: - VideoPicture
fileprivate struct VideoPicture: Decodable {
    let id, nr: Int?
    let picture: URL?
}
