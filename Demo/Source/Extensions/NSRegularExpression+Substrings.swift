//
//  NSRegularExpression+Substrings.swift
//  Demo
//
//  Created by Scott Levie on 9/12/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation


extension NSRegularExpression {

    func substrings(in string: String, options: MatchingOptions = [], range rangeOrNil: NSRange? = nil) -> [[Substring?]]? {

        // search the full range of the string by default
        let range = rangeOrNil ?? NSRange(location: 0, length: string.utf16.count)
        let matches = self.matches(in: string, options: options, range: range)

        // Parse all the match's ranges into substrings
        let strings = matches.map{ match -> [Substring?] in
            return (0..<match.numberOfRanges).map{ rangeIndex -> Substring? in
                // Get the match range at the index
                let rawMatchRange = match.range(at: rangeIndex)
                // Convert the NSRange to a Swift Range and simultaneously check for it's validity
                guard let matchRange = Range<String.Index>(rawMatchRange, in: string) else {
                    return nil
                }
                // Derive a substring using the range
                return string[matchRange]
            }
        }

        return (strings.isEmpty ? nil : strings)
    }

    func matches(in string: String) -> [NSTextCheckingResult] {
        return self.matches(in: string, range: NSRange(location: 0, length: string.utf16.count))
    }
}
