//
//  NSRegularExpression+SubstringsSpec.swift
//  DemoTests
//
//  Created by Scott Levie on 3/23/20.
//  Copyright © 2020 Scott Levie. All rights reserved.
//

import XCTest
@testable import Demo


class NSRegularExpression_SubstringsSpec: XCTestCase {

    override func setUp() {
        self.continueAfterFailure = false
    }

    func test_multipleMatches() {

        // Given
        let regex = try! NSRegularExpression(pattern: #"\d+"#, options: [])
        let string = "1234.5678"

        // When
        let matches = regex.substrings(in: string)

        // Expect: Pattern produced 2 matches
        XCTAssertEqual(matches.count, 2, "Expected pattern '\(regex.pattern)' to produce exactly 2 matches in string '\(string)'. Matches: \(matches)")
        // Expect: Each match produced 1 capture group
        XCTAssertEqual(matches.filter{ $0.count != 1 }.count, 0, "Expected each match to contain exactly 1 capture group. Matches: \(matches)")

        self.continueAfterFailure = true

        // Expect: Match values are correct
        XCTAssertEqual(matches[0][0], "1234")
        XCTAssertEqual(matches[1][0], "5678")
    }

    func test_multipleMatches_with_multipleCaptureGroups() {

        // Given
        let regex = try! NSRegularExpression(pattern: #"You're a (\wizard), (Harry|Ron|Hermione)\."#, options: [])
        let string = """
            You're a wizard, Harry.
            You're a dizard, Ron.
            You're a lizard, Hermione.
            """

        // When
        let matches = regex.substrings(in: string)

        // Expect: Pattern produced 3 matches
        XCTAssertEqual(matches.count, 3, "Expected pattern '\(regex.pattern)' to produce exactly 3 matches in string '\(string)'. Matches: \(matches)")
        // Expect: Each match produced 3 capture groups. (0: The whole capture, 1: The 'wizard' bit, 2: The name)
        XCTAssertEqual(matches.filter{ $0.count != 3 }.count, 0, "Expected each match to contain exactly 3 capture groups. Matches: \(matches)")

        self.continueAfterFailure = true

        // Expect: Harry is a wizard
        XCTAssertEqual(matches[0][0], "You're a wizard, Harry.")
        XCTAssertEqual(matches[0][1], "wizard")
        XCTAssertEqual(matches[0][2], "Harry")
        // Expect: Ron is a dizard
        XCTAssertEqual(matches[1][0], "You're a dizard, Ron.")
        XCTAssertEqual(matches[1][1], "dizard")
        XCTAssertEqual(matches[1][2], "Ron")
        // Expect: Hermione is a lizard
        XCTAssertEqual(matches[2][0], "You're a lizard, Hermione.")
        XCTAssertEqual(matches[2][1], "lizard")
        XCTAssertEqual(matches[2][2], "Hermione")
    }

    func test_emptyCaptureGroup() {

        // Given
        let regex = try! NSRegularExpression(pattern: #"We ate(,)? Grandma\."#, options: [])
        let string = """
            We ate, Grandma.
            We ate Grandma.
            """

        // When
        let matches = regex.substrings(in: string)

        // Expect: Pattern produced 2 matches
        XCTAssertEqual(matches.count, 2, "Expected pattern '\(regex.pattern)' to produce exactly 2 matches in string '\(string)'. Matches: \(matches)")
        // Expect: Each match produced 2 capture groups. (0: The whole capture, 1: The comma or nil)
        XCTAssertEqual(matches.filter{ $0.count != 2 }.count, 0, "Expected each match to contain exactly 2 capture groups. Matches: \(matches)")

        self.continueAfterFailure = true

        // Expect: We told our grand-mother that we ate something
        XCTAssertEqual(matches[0][0], "We ate, Grandma.")
        XCTAssertEqual(matches[0][1], ",")
        // Expect: We confessed to eating our grand-mother
        XCTAssertEqual(matches[1][0], "We ate Grandma.")
        XCTAssertNil(matches[1][1])
    }
}
