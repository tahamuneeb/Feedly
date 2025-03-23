//
//  FeedDataMapperTests.swift
//  Feedly
//
//  Created by Taha Muneeb on 21/03/2025.
//

import XCTest
import FeedlyCore

final class FeedDataMapperTests: XCTestCase {
    
    func test_map_throwsErrorNon2xxStatusCodes() throws {
        let json = makeJSON([])
        let responseCodes = [199, 301, 404, 500]
        
        try responseCodes.forEach { code in
            XCTAssertThrowsError(
                try FeedDataMapper.map(json, response: HTTPURLResponse(statusCode: code))
            )
        }
        
    }
    
    func test_map_throwsErrorOnInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try FeedDataMapper.map(invalidJSON, response: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversEmptyOnEmptyJSONList() throws {
        let emptyListJSON = makeJSON([])
        
        let feeds = try FeedDataMapper.map(emptyListJSON, response: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(feeds, [])
    }
    
    func test_map_deliversItemsOnJSONList() throws {
        let feed1 = makeFeedModel(
            id: 1,
            url: URL(string: "https://a-url.com")!,
            width: 100,
            height: 100,
            creatorName: "a creator",
            thumbnailUrl: nil,
            mediaType: .image
        )
        
        let feed2 = makeFeedModel(
            id: 2,
            url: URL(string: "https://another-url.com")!,
            width: 200,
            height: 200,
            creatorName: "another creator",
            thumbnailUrl: URL(string: "https://another-url-thumb.com")!,
            mediaType: .video
        )
        
        let json = makeJSON([feed1.json, feed2.json])
        
        let statusCodes = [200, 201, 205, 299]

        try statusCodes.forEach { code in
            let result = try FeedDataMapper.map(json, response: HTTPURLResponse(statusCode: code))
            XCTAssertEqual(result, [feed1.model, feed2.model])
        }
    }
        
    
    // MARK: - Helpers
    func makeFeedModel(
        id: Int,
        url: URL,
        width: Int,
        height: Int,
        creatorName: String,
        thumbnailUrl: URL?,
        mediaType: FeedModel.MediaType
    ) -> (model: FeedModel, json: [String: Any?]) {
        let model = FeedModel(
            id: id,
            url: url,
            width: width,
            height: height,
            creatorName: creatorName,
            thumbnailUrl: thumbnailUrl,
            mediaType: mediaType
        )
        
        var json: [String: Any?] = [
            "id": model.id,
            "width": model.width,
            "height": model.height,
            "type": mediaType.rawValue
        ]
        
        if mediaType == .image {
            json["src"] = [
                "medium": model.url.absoluteString
            ]
            json["photographer"] = model.creatorName
        } else if mediaType == .video {
            json["video_files"] = [
                ["quality": "sd", "link": model.url.absoluteString]
            ]
            json["user"] = ["name": model.creatorName]
            json["image"] = model.thumbnailUrl?.absoluteString
        }
        
        return (model, json)
    }
    
    func makeJSON(_ items: [[String: Any?]]) -> Data {
        let json = ["media": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}


