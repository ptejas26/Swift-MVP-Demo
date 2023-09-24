//
//  UserViewController.swift
//  MVP_Demo
//
//  Created by Tejas on 2023-09-16.
//

import UIKit

final class UserViewController: UIViewController {
    let presenter: UserPresenter = .init()
    private var users: [User] = []

    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.delegate = self
        tableView.dataSource = self
        presenter.setViewDelegate(delegate: self)
        Task {
            try await self.presenter.getUsers()
        }
    }
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyTableViewCell else {
            return UITableViewCell()
        }
        cell.labelText?.text = "Name: \(users[indexPath.row].name)\n" + "Username: \(users[indexPath.row].username)\n" + "Email: \(users[indexPath.row].email)"
        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTap(user: users[indexPath.row])
    }
}

extension UserViewController: UserPresenterDelegate {
    func presentUserData(users: [User]) {
        self.users = users
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func presentAlertOnView(_ title: String, _ subTitle: String) {
        let alert = UIAlertController(title: title, message: subTitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel))
        present(alert, animated: true)
    }
}

class MyTableViewCell: UITableViewCell {
    @IBOutlet var labelText: UILabel!
}
