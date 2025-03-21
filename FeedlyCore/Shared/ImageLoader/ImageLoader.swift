//
//  ImageLoader.swift
//  Feedly
//
//  Created by Taha Muneeb on 21/03/2025.
//

import Foundation

protocol ImageLoader {
    typealias Result = Swift.Result<Data, Error>
    
    @discardableResult
    func loadImage(from url: URL, completion: @escaping (Result) -> Void) -> HttpClientTask
}
