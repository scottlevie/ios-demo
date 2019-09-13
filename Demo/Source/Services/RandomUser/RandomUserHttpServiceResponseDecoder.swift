//
//  RandomUserHttpServiceResponseDecoder.swift
//  Demo
//
//  Created by Scott Levie on 9/13/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation


private let ERROR_DOMAIN: String = "Demo.RandomUserHttpServiceResponseDecoder"


protocol RandomUserHttpServiceResponseDecoderProtocol {
    func decode(_ data: Data) throws -> (info: RandomUserHttpService.Meta, users: [User])
}


class RandomUserHttpServiceResponseDecoder: RandomUserHttpServiceResponseDecoderProtocol {

    // MARK: - RandomUserHttpServiceResponseDecoderProtocol


    func decode(_ data: Data) throws -> (info: RandomUserHttpService.Meta, users: [User]) {

        let response = try self.decoder.decode(Response.self, from: data)

        let users = response.results.compactMap{ user -> User? in
            do { return try User(user) }
            catch {
                print("Cannot parse user: \(error)")
                return nil
            }
        }

        return (response.info, users)
    }


    // MARK: -


    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}


// MARK: - Decodable Response


private struct Response: Decodable {
    let info: RandomUserHttpService.Meta
    let results: [User]

    /**
     ```
     "name": {...}
     "gender": "male"
     "email": "gene.hansen@example.com"
     "dob": {...}
     "phone": "(952)-314-6849"
     "location": {...}
     "picture": {...}
     ```
     */
    struct User: Decodable {
        let name: Name
        let gender: Gender
        let email: String
        let dob: DOB
        let phone: String
        let location: Location
        let picture: ImageUrls

        /**
         ```
         "first": "gene"
         "last": "hansen"
         "title": "mr"
         ```
         */
        struct Name: Decodable {
            let first: String
            let last: String

            enum CodingKeys: CodingKey {
                case first
                case last
            }
        }

        enum Gender: String, Decodable {
            case male
            case female
        }

        /**
         ```
         "age": 62
         "date": "1957-09-01T23:58:20Z"
         ```
         */
        struct DOB: Decodable {
            let age: Int
            let date: Date
        }

        /**
         ```
         "street": "4719 westheimer rd"
         "city": "mcallen"
         "state": "new mexico"
         "postcode": 96770
         "coordinates": {...}
         "timezone": {...}
         ```
         */
        struct Location: Decodable {
            let street: String
            let city: String
            let state: String
            let postcode: Int
            let coordinates: Coordinates
            let timezone: TimeZoneOffset

            /**
             ```
             "latitude": "58.0943"
             "longitude": "-132.8570"
             ```
             */
            struct Coordinates: Decodable {
                let latitude: String
                let longitude: String
            }


            /**
             ```
             "description": "Bangkok, Hanoi, Jakarta"
             "offset": "+7:00"
             ```
             */
            struct TimeZoneOffset: Decodable {
                let offset: String

                enum CodingKeys: CodingKey {
                    case offset
                }
            }
        }

        struct ImageUrls: Decodable {
            let large: URL
            let medium: URL
            let thumbnail: URL
        }
    }
}


// MARK: - Init Objects from Intermediates


private extension User {

    init(_ user: Response.User) throws {

        let location = try User.Location(user.location)

        self.init(
            nameFirst: user.name.first,
            nameLast: user.name.last,
            gender: User.Gender(user.gender),
            email: user.email,
            dateOfBirth: user.dob.date,
            phone: user.phone,
            location: location,
            imageUrls: User.ImageUrls(user.picture)
        )
    }
}


private extension User.Location {

    init(_ loc: Response.User.Location) throws {

        guard let lat = Double(loc.coordinates.latitude) else {
            // TODO: Throw a more meaningful error
            throw NSError(domain: ERROR_DOMAIN, code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Cannot convert latitude string '\(loc.coordinates.latitude)' to a Double"
                ])
        }

        guard let lon = Double(loc.coordinates.longitude) else {
            // TODO: Throw a more meaningful error
            throw NSError(domain: ERROR_DOMAIN, code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Cannot convert longitude string '\(loc.coordinates.longitude)' to a Double"
                ])
        }

        let timeZone = try type(of: self).timezone(forOffsetString: loc.timezone.offset)

        self.init(
            street: loc.street,
            city: loc.city,
            state: loc.street,
            postalCode: "\(loc.postcode)",
            latitude: lat,
            longitude: lon,
            timeZone: timeZone
        )
    }

    private static func timezone(forOffsetString offsetString: String) throws -> TimeZone {

        guard let matches = self.offsetRegex.substrings(in: offsetString) else {
            // TODO: Throw a more meaningful error
            throw NSError(domain: ERROR_DOMAIN, code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Offset string '\(offsetString)' does not match the expected format '\(self.offsetRegex.pattern)'"
                ])
        }

        let match = matches[0]
        let sign: Double = (match[1] == "-") ? -1 : 1
        let hours = Double(match[2]!)!
        let minutes = Double(match[3]!)!

        let offsetSeconds = sign * ((hours * 60 * 60) + (minutes * 60))

        guard let timezone = TimeZone(secondsFromGMT: Int(offsetSeconds)) else {
            // TODO: Throw a more meaningful error
            throw NSError(domain: ERROR_DOMAIN, code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Cannot convert offset in seconds \(offsetSeconds) to TimeZone"
                ])
        }

        return timezone
    }

    /// "+7:00"
    private static let offsetRegex: NSRegularExpression = try! .init(pattern: #"^(\+|-)?(\d+):(\d+)$"#, options: [])
}


private extension User.Gender {

    init(_ gender: Response.User.Gender) {
        switch gender {
        case .male: self = .male
        case .female: self = .female
        }
    }
}


private extension User.ImageUrls {

    init(_ urls: Response.User.ImageUrls) {
        self.large = urls.large
        self.medium = urls.medium
        self.thumbnail = urls.thumbnail
    }
}
