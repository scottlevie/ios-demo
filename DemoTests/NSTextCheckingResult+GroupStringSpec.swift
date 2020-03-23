//
//  NSTextCheckingResult+GroupStringSpec.swift
//  DemoTests
//
//  Created by Scott Levie on 3/23/20.
//  Copyright © 2020 Scott Levie. All rights reserved.
//

import XCTest
@testable import Demo


class NSTextCheckingResult_GroupStringSpec: XCTestCase {

    func testThing() {

        let regex = try! NSRegularExpression(pattern: #"(\d+)\.(\d+)"#, options: [])
        let string = "1234.5678"
        let range = NSRange(location: 0, length: string.utf16.count)

        // When
        let match = regex.firstMatch(in: string, options: [], range: range)!

        // Expect: Three capture groups (0: Full string, 1: First number, 2: Second number
        XCTAssertEqual(match.substring(group: 0, in: string), "1234.5678")
        XCTAssertEqual(match.substring(group: 1, in: string), "1234")
        XCTAssertEqual(match.substring(group: 2, in: string), "5678")
    }
}

