//
//  SettingsViewController.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    var isLoggedIn: Bool {
        if TokenManager.shared.fetchAccessToken() != nil {
            return true
        }
        return false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if isLoggedIn {
            logOutButton.title = "Sign Out"
            logOutButton.tintColor = .red
        } else {
            logOutButton.title = "Sign In"
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func didTapLogut(_ sender: Any) {
        if isLoggedIn {
            navigationController?.popViewController(animated: true)
            TokenManager.shared.clearAccessToken()
        } else {
            let loginView = LoginViewController.instaintiate(on: .mainView)
            loginView.hidesBottomBarWhenPushed = true
            loginView.getGitHubAccessToken()
            navigationController?.pushViewController(loginView, animated: true)
        }
    }
}
