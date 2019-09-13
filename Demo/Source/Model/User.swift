//
//  User.swift
//  Demo
//
//  Created by Scott Levie on 9/12/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation


struct User {
    let nameFirst: String
    let nameLast: String
    let gender: Gender
    let email: String
    let dateOfBirth: Date
    let phone: String
    let location: Location
    let imageUrls: ImageUrls

    enum Gender {
        case male
        case female
    }

    struct Location {
        let street: String
        let city: String
        let state: String
        let postalCode: String
        let latitude: Double
        let longitude: Double
        let timeZone: TimeZone
    }

    struct ImageUrls {
        let large: URL
        let medium: URL
        let thumbnail: URL
    }
}

