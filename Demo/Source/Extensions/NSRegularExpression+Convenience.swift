//
//  NSRegularExpression+Convenience.swift
//  Demo
//
//  Created by Scott Levie on 9/12/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation

/// Makes the syntax to access `NSRegularExpression` a bit nicer.
typealias Regex = NSRegularExpression

extension NSRegularExpression {

    /**
     Initializes a new regular expression instance.

     Makes the syntax a bit nicer by hiding the `pattern` parameter label and removing the `options` parameter.
     An empty options instance will be used instead.
     */
    convenience init(_ pattern: String) throws {
        try self.init(pattern: pattern, options: [])
    }

    /**
     Returns the first match in the given string using the full range of the string.

     Typically a regular expression will be matched against the complete string instead of a slice of the string.
     This method makes the syntax a bit nicer for the caller by removing the `range` parameter.
     The full range of the string will be used instead.
     */
    func firstMatch(in string: String, options: MatchingOptions = []) -> NSTextCheckingResult? {
        self.firstMatch(in: string, options: options, range: self.fullNSRange(string))
    }

    /**
     Returns the first match in the given string.

     Changes the `range` parameter from `NSRange` to `Range<String.Index>`
     */
    func firstMatch(in string: String, options: MatchingOptions = [], range: Range<String.Index>?) -> NSTextCheckingResult? {
        let nsrange = self.nsrange(range, in: string)
        return self.firstMatch(in: string, options: options, range: nsrange)
    }

    /**
     Returns the matches in the given string using the full range of the string.

     Typically a regular expression will be matched against the complete string instead of a slice of the string.
     This method makes the syntax a bit nicer for the caller by removing the `range` parameter.
     The full range of the string will be used instead.
     */
    func matches(in string: String, options: MatchingOptions = []) -> [NSTextCheckingResult] {
        self.matches(in: string, options: options, range: self.fullNSRange(string))
    }

    /**
     Returns the matches in the given string.

     Changes the `range` parameter from `NSRange` to `Range<String.Index>`
     */
    func matches(in string: String, options: MatchingOptions = [], range: Range<String.Index>?) -> [NSTextCheckingResult] {
        let nsrange = self.nsrange(range, in: string)
        return self.matches(in: string, options: options, range: nsrange)
    }

    /**
     Returns the matches in the given string as substrings.

     Each array of substrings represents a match and each substring represents a capture group within a match.
     A substring may be nil if the capture group is optional.

     Example
     ```
     pattern: "\d+(\.\d+)?"
     string: "100.5, 23"
     substrings: [["100.5", ".5"], ["23", nil]]
     ```
     */
    func substrings(in string: String, options: MatchingOptions = [], range: Range<String.Index>? = nil) -> [[Substring?]] {
        let matches = self.matches(in: string, options: options, range: range)
        return matches.map{ $0.substrings(in: string) }
    }

    private func nsrange(_ rangeOrNil: Range<String.Index>?, in string: String) -> NSRange {
        // Search the full range of the string if none is provided
        let range = rangeOrNil ?? self.fullRange(string)
        // Convert the given Range object to ye olde NSRange
        return NSRange(range, in: string)
    }

    private func fullRange(_ string: String) -> Range<String.Index> {
        string.startIndex..<string.endIndex
    }

    private func fullNSRange(_ string: String) -> NSRange {
        NSRange(location: 0, length: string.utf16.count)
    }
}
