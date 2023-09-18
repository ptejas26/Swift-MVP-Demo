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
    func presentUserData(user: [User])
    func presentAlertOnView(title: String, subTitle: String)
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
        print(responseObject)
        let decoder = JSONDecoder()
        let users = try decoder.decode([User].self, from: data)
        delegate?.presentUserData(user: users)
    }
}
