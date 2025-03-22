//
//  ImageCache.swift
//  Feedly
//
//  Created by Taha Muneeb on 21/03/2025.
//

import Foundation

public protocol ImageCache {
    typealias Result = Swift.Result<Data, Error>
    
    @discardableResult
    func saveImage(_ data: Data, for url: URL) -> ImageCache.Result
    func loadImage(for url: URL) -> ImageCache.Result
}
