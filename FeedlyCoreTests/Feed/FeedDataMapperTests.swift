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
        
        let json: [String: Any?] = [
            "id": model.id,
            "url": model.url.absoluteString,
            "width": model.width,
            "height": model.height,
            "creatorName": model.creatorName,
            "thumbnailUrl": model.thumbnailUrl?.absoluteString,
            "mediaType": mediaType.rawValue
        ]
        
        return (model, json)
    }
    
    func makeJSON(_ items: [[String: Any?]]) -> Data {
        let json = ["media": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}


