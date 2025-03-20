//
//  HttpClient.swift
//  Feedly
//
//  Created by Taha Muneeb on 20/03/2025.
//

import Foundation

// A generic Protocol for HttpClient, this approach will allow to implement Client like URLSession or Alamofire. Domain logic will remain untouched.
public protocol HttpClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    @discardableResult
    func get(_ url: URL, completion: @escaping (Result) -> Void) -> HttpClientTask
}
