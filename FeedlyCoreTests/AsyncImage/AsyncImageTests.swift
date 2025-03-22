//
//  AsyncImageTests.swift
//  Feedly
//
//  Created by Taha Muneeb on 22/03/2025.
//
import XCTest
import FeedlyCore

class AsyncImageTests: XCTestCase {
    
    func test_loadingFirstTime_requestDataFromRemote() {
        let url = URL(string: "http://a-url.com")!
        let loader = MockImageLoader()
        let cache = MockImageCache()
        let sut = makeSUT(imageCache: cache, imageLoader: loader)
        
        let exp = expectation(description: "Wait for load completion")
        
        _ = sut.loadImage(from: url)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in
                    XCTAssertEqual(loader.loadedImages, [url])
                    XCTAssertEqual(cache.savedImages.count, 1)
                    exp.fulfill()
                }
            
            )
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_loadingSecondTime_requestDataFromCache() {
        let url = URL(string: "http://a-url.com")!
        let loader = MockImageLoader()
        let cache = MockImageCache()
        let sut = makeSUT(imageCache: cache, imageLoader: loader)
        
        let exp = expectation(description: "Wait for load completion")
        
        _ = sut.loadImage(from: url)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in
                    XCTAssertEqual(cache.loadedImages, [url])
                    XCTAssertEqual(cache.savedImages.count, 1)
                    XCTAssertEqual(loader.loadedImages.count, 1)
                    exp.fulfill()
                }
            
            )
        wait(for: [exp], timeout: 1.0)
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(imageCache: ImageCache, imageLoader: ImageLoader, file: StaticString = #file, line: UInt = #line) -> AsyncImage {
        let sut = AsyncImage(imageCache: imageCache, imageLoader: imageLoader)
        trackForMemoryLeaks(sut)
        return sut
    }
}

private class MockImageCache: ImageCache {
    var savedImages = [URL: Data]()
    var loadedImages = [URL]()
    
    func saveImage(_ data: Data, for url: URL) -> ImageCache.Result {
        savedImages[url] = data
        return .success(data)
    }
    
    func loadImage(for url: URL) -> ImageCache.Result {
        loadedImages.append(url)
        return .failure(anError())
    }
}

private class MockImageLoader: ImageLoader {
    var loadedImages = [URL]()
    
    func loadImage(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> HttpClientTask {
        loadedImages.append(url)
        completion(.success(aImageData()))
        return ClientTask()
    }
    
    class ClientTask: HttpClientTask {
        func cancel() {}
    }
}
