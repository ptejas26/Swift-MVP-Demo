//
//  UserPresenter.swift
//  MVP_Demo
//
//  Created by Tejas on 2023-09-16.
//

import UIKit

// https://jsonplaceholder.typicode.com/users

enum CustomError: Error {
    case badURL
    case badRequest
    case noDataFound
}

protocol UserPresenterDelegate: AnyObject {
    func presentUserData(users: [User])
    func presentAlertOnView(_ title: String, _ subTitle: String)
}

typealias PresenterDelegate = UIViewController & UserPresenterDelegate

final class UserPresenter {
    weak var delegate: PresenterDelegate?

    func setViewDelegate(delegate: PresenterDelegate?) {
        self.delegate = delegate
    }

    func getUsers() async throws {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            throw CustomError.badURL
        }
        let (data, responseObject) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let users = try decoder.decode([User].self, from: data)
        delegate?.presentUserData(users: users)
    }

    public func didTap(user: User) {
        delegate?.presentAlertOnView(user.name, "Above user has \(user.username) and \(user.email) is the email")
    }
}
