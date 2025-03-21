//
//  CacheDirectoryClient.swift
//  Feedly
//
//  Created by Taha Muneeb on 21/03/2025.
//

import Foundation

public class DocumentsCacheDirectoryClient: ImageCache {
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    public init() {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("ImageCache")
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    public func saveImage(_ data: Data, for url: URL) -> ImageCache.Result {
        let path = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        do {
            try data.write(to: path)
            return .success(data)
        } catch let error {
            return .failure(error)
        }
    }
    
    public func loadImage(for url: URL) -> ImageCache.Result {
        let path = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        do {
            let data = try Data(contentsOf: path)
            return .success(data)
        } catch let error {
            return .failure(error)
        }
    }
}
