//
//  QuadTreeBounds.swift
//  Demo
//
//  Created by Scott Levie on 9/14/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation

struct QuadTreeBounds {
    let horizontal: ClosedRange<Double>
    let vertical: ClosedRange<Double>

    func contains(x: Double, y: Double) -> Bool {
        return self.horizontal.contains(x) && self.vertical.contains(y)
    }

    var left: Double {
        return self.horizontal.lowerBound
    }

    var right: Double {
        return self.horizontal.upperBound
    }

    var top: Double {
        return self.vertical.lowerBound
    }

    var bottom: Double {
        return self.vertical.upperBound
    }

    var center: (x: Double, y: Double) {
        return (
            x: self.left + (self.width / 2),
            y: self.top + (self.height / 2)
        )
    }

    var width: Double {
        return (self.horizontal.upperBound - self.horizontal.lowerBound)
    }

    var height: Double {
        return (self.vertical.upperBound - self.vertical.lowerBound)
    }
}
