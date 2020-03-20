//
//  QuadTreeDataPoint.swift
//  Demo
//
//  Created by Scott Levie on 9/14/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation


struct QuadTreeDataPoint<Id: Hashable> {
    let id: Id
    let x: Double
    let y: Double
}
