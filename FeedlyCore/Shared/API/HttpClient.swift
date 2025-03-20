//
//  HttpClient.swift
//  Feedly
//
//  Created by Taha Muneeb on 20/03/2025.
//

import Foundation

public protocol HttpClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(_ url: URL, completion: @escaping (Result) -> Void) -> HttpClientTask
}
