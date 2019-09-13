//
//  ViewController.swift
//  Demo
//
//  Created by Scott Levie on 6/29/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUsers()
    }


    private func getUsers() {

        let service = RandomUserHttpService()

        service.fetchUsers(success: { users in
            print("success: \(users.count) users")

        }, failure: { error in
            switch (error as! RandomUserHttpService.ServiceError) {
            case .httpError(let error):
                print("HTTP Error: \(error)")
            case .cannotParseJson(let error, rawResponse: let response):
                print("Cannot parse json: \(error)\nRaw response: \(response ?? "nil")")
            case .noData:
                print("Received no data")
            case .unexpectedJsonType(let received, let expected):
                print("Expected json type \(expected), but received type \(received)")
            }
        })
    }
}

