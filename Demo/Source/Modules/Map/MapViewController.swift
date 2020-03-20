//
//  MapViewController.swift
//  Demo
//
//  Created by Scott Levie on 9/15/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        RandomUserHttpService().fetchUsers(success: { [unowned self] users in

            self.userById = users.reduce(into: [:], { (result, user) in
                let id = Id(objectType: "User", id: UUID().uuidString)
                result[id] = user
            })

            for (id, user) in self.userById {
                let dataPoint = QuadTreeDataPoint<Id>.init(id: id, x: user.location.latitude, y: user.location.longitude)
                self.quadTreeRoot.insert(dataPoint)
            }
            
        }, failure: { error in
            print("Failed to download users: \(error)")
        })
    }

    struct Id: Hashable {
        let objectType: String
        let id: String

        func hash(into hasher: inout Hasher) {
            hasher.combine(self.objectType)
            hasher.combine(self.id)
        }
    }

    private var userById: [Id: User] = [:]

    @IBOutlet private weak var mapView: MKMapView!

    let quadTreeRoot = QuadTreeNode<Id>(
        capacity: 4,
        .init(horizontal: (-180)...180, vertical: (-90)...90)
    )
}
