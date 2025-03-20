//
//  TestHelpers.swift
//  Feedly
//
//  Created by Taha Muneeb on 20/03/2025.
//
import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance was not deallocated, Memory leak found", file: file, line: line)
        }
    }
}
