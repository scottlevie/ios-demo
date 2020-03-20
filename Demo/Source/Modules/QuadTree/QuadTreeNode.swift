//
//  QuadTreeNode.swift
//  Demo
//
//  Created by Scott Levie on 9/14/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation


class QuadTreeNode<Id: Hashable> {

    init(capacity: Int, _ bounds: QuadTreeBounds) {
        guard (capacity > 0) else { fatalError() }
        self.capacity = capacity
        self.bounds = bounds
    }

    /// The maximum number of data points that can be attached
    /// to this node before it must be subdivided
    let capacity: Int
    let bounds: QuadTreeBounds
    /// Contains the ids of all the data points attached to this node and all its descendents
    private(set) var manifest: Set<Id> = []
    /// The datapoints attached directly to this node
    private(set) var dataPointsById: [Id: QuadTreeDataPoint<Id>] = [:]

    private(set) var isLeaf: Bool = true
    private(set) var leftTopNode: QuadTreeNode?
    private(set) var leftBottomNode: QuadTreeNode?
    private(set) var rightTopNode: QuadTreeNode?
    private(set) var rightBottomNode: QuadTreeNode?

    @discardableResult
    func insert(_ dataPoint: QuadTreeDataPoint<Id>) -> Bool {

        // Do not insert the data point if it is not within the node's bounds
        guard self.bounds.contains(x: dataPoint.x, y: dataPoint.y) else {
            return false
        }

        // Remove the given data point from it's current node before attempting to insert it
        self.removeDataPoint(for: dataPoint.id)

        // Add the data point's id to the manifest
        self.manifest.insert(dataPoint.id)

        // Insert the data point directly, if the node hasn't yet exceeded its capacity
        if (self.dataPointsById.count < self.capacity) {
            self.dataPointsById[dataPoint.id] = dataPoint
            return true
        }

        // Init sub-nodes
        self.subdivideIfNecessary()

        // Attempt to insert the data points into one of the sub-nodes
        if self.leftTopNode!.insert(dataPoint) { return true }
        if self.leftBottomNode!.insert(dataPoint) { return true }
        if self.rightTopNode!.insert(dataPoint) { return true }
        if self.rightBottomNode!.insert(dataPoint) { return true }

        assertionFailure("Failed to insert data point into any of the sub-nodes")
        return false
    }

    private func subdivideIfNecessary() {

        guard self.isLeaf else { return }
        self.isLeaf = false

        let center = self.bounds.center

        self.leftTopNode = .init(capacity: self.capacity, .init(
            horizontal: (self.bounds.left...center.x),
            vertical: (self.bounds.top...center.y)
        ))

        self.leftBottomNode = .init(capacity: self.capacity, .init(
            horizontal: (self.bounds.left...center.x),
            vertical: (center.y...self.bounds.bottom)
        ))

        self.rightTopNode = .init(capacity: self.capacity, .init(
            horizontal: (center.x...self.bounds.right),
            vertical: (self.bounds.top...center.y)
        ))

        self.rightBottomNode = .init(capacity: self.capacity, .init(
            horizontal: (center.x...self.bounds.right),
            vertical: (center.y...self.bounds.bottom)
        ))
    }

    @discardableResult
    func removeDataPoint(for id: Id) -> Bool {

        // Do nothing if the manifest does not contain the given id
        guard self.manifest.contains(id) else {
            return false
        }

        defer {
            // After the data point has been removed.
            // Remove it's id from the manifest and collapse the node
            self.manifest.remove(id)
            self.collapse()
        }

        // Remove the data point from this node directly
        if (self.dataPointsById.removeValue(forKey: id) != nil) {
            return true
        }

        // Remove the data point from one of the sub-nodes
        if (self.leftTopNode?.removeDataPoint(for: id) == true) { return true }
        if (self.leftBottomNode?.removeDataPoint(for: id) == true) { return true }
        if (self.rightTopNode?.removeDataPoint(for: id) == true) { return true }
        if (self.rightBottomNode?.removeDataPoint(for: id) == true) { return true }

        assertionFailure("Failed to remove data point from any of the sub-nodes")
        return false
    }

    private func collapse() {

        // Only collapse the node if it's not a leaf and the total number of
        // data points from all it's descendants is less than the node's capacity
        guard !self.isLeaf && (self.manifest.count <= self.capacity) else {
            return
        }

        // Gather data points from all decendants and add them to this node directly
        self.dataPointsById = self.allDataPoints().reduce(into: [:], { $0[$1.id] = $1 })

        // Release all the other nodes
        self.leftTopNode = nil
        self.leftBottomNode = nil
        self.rightTopNode = nil
        self.rightBottomNode = nil

        // Mark as leaf
        self.isLeaf = true
    }

    private func allDataPoints() -> [QuadTreeDataPoint<Id>] {

        var dataPoints = Array(self.dataPointsById.values)
        if let node = self.leftTopNode     { dataPoints.append(contentsOf: node.allDataPoints()) }
        if let node = self.leftBottomNode  { dataPoints.append(contentsOf: node.allDataPoints()) }
        if let node = self.rightTopNode    { dataPoints.append(contentsOf: node.allDataPoints()) }
        if let node = self.rightBottomNode { dataPoints.append(contentsOf: node.allDataPoints()) }
        return dataPoints
    }
}
