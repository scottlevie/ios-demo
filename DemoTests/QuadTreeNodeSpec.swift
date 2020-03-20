//
//  QuadTreeNodeSpec.swift
//  DemoTests
//
//  Created by Scott Levie on 9/15/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import XCTest
@testable import Demo


class QuadTreeNodeSpec: XCTestCase {

    func testInsertUpToCapacity() {

        // Given
        let node = QuadTreeNode<Int>(capacity: 1, .init(
            horizontal: 0...8,
            vertical: 0...8
        ))
        let dataPoint = QuadTreeDataPoint(id: 0, x: 4, y: 4)

        // When
        node.insert(dataPoint)

        // Expect

        // The manifest should contain exactly one id
        XCTAssert(node.manifest.count == 1)
        // The data point id should appear in the manifest
        XCTAssert(node.manifest.contains(dataPoint.id))
        // The node should contain exactly one data point
        XCTAssert(node.dataPointsById.count == 1)
        // The node should contain the inserted data point
        XCTAssert(node.dataPointsById.keys.contains(dataPoint.id))
        // The node should still be a leaf (should not have subdivided)
        XCTAssert(node.isLeaf == true)
        XCTAssert(node.leftTopNode == nil)
        XCTAssert(node.leftBottomNode == nil)
        XCTAssert(node.rightTopNode == nil)
        XCTAssert(node.rightBottomNode == nil)
    }

    func testSubdivide() {

        // Given
        let node = QuadTreeNode<Int>(capacity: 1, .init(
            horizontal: 0...8,
            vertical: 0...8
        ))
        let dataPoint0 = QuadTreeDataPoint(id: 0, x: 2, y: 2)
        let dataPoint1 = QuadTreeDataPoint(id: 1, x: 2, y: 2)

        // When
        node.insert(dataPoint0)
        node.insert(dataPoint1)

        // Expect

        // The node should subdivide itself
        XCTAssert(node.isLeaf == false)
        XCTAssert(node.leftTopNode != nil)
        XCTAssert(node.leftBottomNode != nil)
        XCTAssert(node.rightTopNode != nil)
        XCTAssert(node.rightBottomNode != nil) 
        // The data point should be contained by left-top node
        if let leftTopNode = node.leftTopNode {
            XCTAssert(leftTopNode.dataPointsById.count == 1)
            XCTAssert(leftTopNode.dataPointsById[dataPoint1.id] != nil)
        }
        // The other nodes should be empty
        if let subnode = node.leftBottomNode  { XCTAssert(subnode.dataPointsById.isEmpty) }
        if let subnode = node.rightTopNode    { XCTAssert(subnode.dataPointsById.isEmpty) }
        if let subnode = node.rightBottomNode { XCTAssert(subnode.dataPointsById.isEmpty) }
    }
}
