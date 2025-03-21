//
//  TestHelpers.swift
//  Feedly
//
//  Created by Taha Muneeb on 20/03/2025.
//
import XCTest
import UIKit

func aURL() -> URL {
    URL(string: "https://example.com")!
}

func anError() -> NSError {
    return NSError(domain: "an error", code: 0)
}

func aData() -> Data {
    return Data("a data".utf8)
}

func aImageData() -> Data {
    return UIImage(color: .red)?.pngData() ?? Data()
}

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance was not deallocated, Memory leak found", file: file, line: line)
        }
    }
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: aURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}


public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
