//
//  ImageCacheClient.swift
//  Feedly
//
//  Created by Taha Muneeb on 21/03/2025.
//

import Foundation

public class ImageCacheClient: ImageCache {
    let cache: ImageCache
    
    private init(cache: ImageCache) {
        self.cache = cache
    }
    
    public func saveImage(_ data: Data, for url: URL) -> ImageCache.Result  {
        cache.saveImage(data, for: url)
    }
    
    public func loadImage(for url: URL) -> ImageCache.Result {
        return cache.loadImage(for: url)
    }
}

   
