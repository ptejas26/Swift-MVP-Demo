//
//  UserViewController.swift
//  MVP_Demo
//
//  Created by Tejas on 2023-09-16.
//

import UIKit
// swiftformat:options --selfrequired
class UserViewController: UIViewController, UserPresenterDelegate {
    let presenter: UserPresenter = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"
        presenter.setViewDelegate(delegate: self)
        Task {
            try await self.presenter.getUsers()
        }
    }
}

extension UserPresenterDelegate {
    func presentUserData(user: [User]) {
        print(user.count)
    }

    func presentAlertOnView(title _: String, subTitle _: String) {}
}
