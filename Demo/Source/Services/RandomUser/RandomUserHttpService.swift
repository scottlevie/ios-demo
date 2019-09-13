//
//  RandomUserHttpService.swift
//  Demo
//
//  Created by Scott Levie on 9/12/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation


protocol UserServiceProtocol {
    func fetchUsers(success: @escaping ([User])->Void, failure: @escaping (Error)->Void)
}


class RandomUserHttpService: UserServiceProtocol {

    // MARK: - UserServiceProtocol


    func fetchUsers(success: @escaping ([User])->Void, failure: @escaping (Error)->Void) {

        let url = self.prepareUrl()

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in

            switch self.handleResponse(data, response, error) {
            case .success((_, _, let users)): success(users)
            case .failure(let error): failure(error)
            }
        }

        task.resume()
    }


    // MARK: -


    struct Meta: Decodable {
        let page: Int
        let results: Int
        let seed: String
        let version: String
    }

    private let url = URL(string: "https://randomuser.me/api/1.2/")!
    private let decoder: RandomUserHttpServiceResponseDecoder = .init()

    private func prepareUrl() -> URL {

        var components = URLComponents(url: self.url, resolvingAgainstBaseURL: false)!

        components.queryItems = [
            URLQueryItem(name: "inc", value: "gender,name,location,email,dob,phone,picture"),
            URLQueryItem(name: "results", value: "10"),
            URLQueryItem(name: "nat", value: "us")
        ]

        return components.url!
    }

    private func handleResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Result<(HTTPURLResponse, RandomUserHttpService.Meta, [User]), ServiceError> {

        if let error = error {
            return .failure(.httpError(error))
        }

        guard let data = data, (data.count > 0) else {
            return .failure(.noData)
        }

        do {
            let (meta, users) = try self.decoder.decode(data)
            let response = response as! HTTPURLResponse
            return .success((response, meta, users))
        }
        catch {
            let responseString = String(data: data, encoding: .utf8)
            return .failure(.cannotParseJson(error, rawResponse: responseString))
        }
    }

    enum ServiceError: Error {
        case httpError(Error)
        case cannotParseJson(Error, rawResponse: String?)
        case unexpectedJsonType(received: String, expected: String)
        case noData
    }
}
