//
//  DocumentsCacheDirectoryClientTests.swift
//  Feedly
//
//  Created by Taha Muneeb on 21/03/2025.
//

import XCTest
import FeedlyCore

class DocumentsCacheDirectoryClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        let cacheDirectory = getCacheDirectory()
        try? FileManager.default.removeItem(at: cacheDirectory)
        try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    override func tearDown() {
        let cacheDirectory = getCacheDirectory()
        try? FileManager.default.removeItem(at: cacheDirectory)
        super.tearDown()
    }
    
    
    func test_imageSavingAndLoading() {
        let sut = makeSUT()
        
        let url = URL(string: "https://a-url/test-image.jpeg")!
        let data = aImageData()
        
        let saveResponse = sut.saveImage(data, for: url)
        
        let savedData = sut.loadImage(for: url)
        switch (savedData, saveResponse) {
        case let (.success(savedData), .success(_)):
            XCTAssertEqual(savedData, data)
        default:
            XCTFail("Expected to get data")
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> DocumentsCacheDirectoryClient {
        let sut = DocumentsCacheDirectoryClient()
        trackForMemoryLeaks(sut)
        return sut
    }
    
    func getCacheDirectory() -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("ImageCache")
    }
}
