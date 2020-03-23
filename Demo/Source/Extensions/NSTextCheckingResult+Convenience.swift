//
//  NSTextCheckingResult+Convenience.swift
//  Demo
//
//  Created by Scott Levie on 3/20/20.
//  Copyright © 2020 Scott Levie. All rights reserved.
//

import Foundation


extension NSTextCheckingResult {

    func substring(group i: Int, in string: String) -> Substring? {
        let nsrange = self.range(at: i)
        guard let range = Range(nsrange, in: string) else { return nil }
        return string[range]
    }

    func substrings(in string: String) -> [Substring?] {
        self.mapRanges(in: string) { range -> Substring? in
            guard let range = range else { return nil }
            return string[range]
        }
    }

    func mapSubstrings<T>(in string: String, transform: (Substring?) -> T) -> [T] {
        self.mapRanges(in: string) { range -> T in
            guard let range = range else { return transform(nil) }
            return transform(string[range])
        }
    }

    func mapRanges<T>(in string: String, transform: (Range<String.Index>?) -> T) -> [T] {
        self.mapNSRanges { nsrange -> T in
            let range = Range(nsrange, in: string)
            return transform(range)
        }
    }

    func mapNSRanges<T>(transform: (NSRange) -> T) -> [T] {
        self.mapRangeIndexes { i -> T in
            let range = self.range(at: i)
            return transform(range)
        }
    }

    func mapRangeIndexes<T>(transform: (Int) -> T) -> [T] {
        (0..<self.numberOfRanges).map{ transform($0) }
    }
}
