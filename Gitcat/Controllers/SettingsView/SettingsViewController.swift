//
//  SettingsViewController.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    var isLoggedIn: Bool {
        if TokenManager.shared.fetchAccessToken() != nil {
            return true
        }
        return false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initView ()
        checkLoginStatus()
    }
    func checkLoginStatus() {
        if isLoggedIn {
            logOutButton.title = "Log Out".localized()
            logOutButton.tintColor = .red
        } else {
            logOutButton.title = "log In".localized()
        }
    }
    func collectionData() {
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.register( UINib(nibName: "SettingsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SettingsCollectionViewCell")
    }
    func initView () {
        title = "Settings".localized()
        collectionData()
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
//MARK: - CollectionView
extension SettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
     }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingsCollectionViewCell", for: indexPath) as! SettingsCollectionViewCell
            cell.setDarkModeCell(indexPath: indexPath)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingsCollectionViewCell", for: indexPath) as! SettingsCollectionViewCell
            cell.setChangeLanguageCell(indexPath: indexPath)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 300)
    }
 }
