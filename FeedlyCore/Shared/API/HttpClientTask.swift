//
//  HttpClientTask.swift
//  Feedly
//
//  Created by Taha Muneeb on 20/03/2025.
//
import Foundation

// Defining a cancelable task so that client can cancel on going request.
public protocol HttpClientTask {
    func cancel()
}
