//
//  HomeViewController.swift
//  Demo
//
//  Created by Scott Levie on 6/29/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.getUsers()
    }


    private func getUsers() {

        let service = RandomUserHttpService()

        service.fetchUsers(
            success: { users in
                print("success: \(users.count) users")
            },
            failure: { error in
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
            }
        )
    }


    // MARK: -


    private enum Demo: Int, CaseIterable {
        case map

        var title: String {
            switch self {
            case .map: return NSLocalizedString("Map", comment: "")
            }
        }
    }


    // MARK: - Table View


    @IBOutlet private weak var tableView: UITableView!

    private let cellId: String = "demoCellId"

    private func setupTableView() {
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellId)
    }


    // MARK: - UITableViewDataSource


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Demo.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath)
        let demo = Demo(rawValue: indexPath.row)!
        cell.textLabel?.text = demo.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }


    // MARK: - UITableViewDelegate


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Do something
    }
}

