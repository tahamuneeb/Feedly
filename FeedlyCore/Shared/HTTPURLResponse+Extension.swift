//
//  URLSessionResponse.swift
//  Feedly
//
//  Created by Taha Muneeb on 20/03/2025.
//
import Foundation

extension HTTPURLResponse {
	var isOK: Bool {
        return statusCode >= 200 && statusCode <= 299
	}
}
