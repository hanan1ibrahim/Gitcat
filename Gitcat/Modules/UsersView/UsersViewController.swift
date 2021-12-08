//
//  UsersViewController.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

import UIKit
import Alamofire
import SafariServices

class UsersViewController: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    //MARK:- Varibles
    let spinner = UIActivityIndicatorView()
    var searchController = UISearchController(searchResultsController: nil)
    var usersModel = [Users]()
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadingIndicator()
        getUsersList()
        setupSearchController(search: searchController)
    }
    //MARK:- Functions
    func loadingIndicator() {
        spinner.style = UIActivityIndicatorView.Style.large
        spinner.center = view.center
        view.addSubview(spinner)
    }
    func configureUI() {
        title = "Users"
    }
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCellNib(cellClass: UsersCell.self)
    }
    func presentAlert(title: String, msg: String, btnTitle: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: btnTitle, style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    func getUsersList() {
        spinner.startAnimating()
        let requestURL = Router.usersListAPIlink
        AF.request(requestURL).responseDecodable(of: [Users].self, completionHandler: { response in
                switch response.result {
                case .success(_):
                    guard let users = response.value else {return}
                    self.usersModel = users
                    self.tableView.reloadData()
                    self.spinner.stopAnimating()
                case .failure(let error):
                    self.presentAlert(title: "Error", msg: error.localizedDescription, btnTitle: "Ok")
                }
            })
        }
}
// MARK:- TableView
extension UsersViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usersModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as UsersCell
        cell.userName.text = usersModel[indexPath.row].userName
        let avatarURL = usersModel[indexPath.row].userAvatar
        cell.userAvatar.downloadImage(urlString: avatarURL)
        cell.userAvatar.layer.cornerRadius = UsersCell.profileImageSize.width / 2.0
        cell.userAvatar.contentMode = .scaleAspectFill
        cell.userAvatar.layer.masksToBounds = false
        cell.userAvatar.layer.cornerRadius = cell.userAvatar.frame.height/2
        cell.userAvatar.clipsToBounds = true
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let userURL = usersModel[indexPath.row].userURL
        let safariVC = SFSafariViewController(url: URL(string: userURL)!)
        self.present(safariVC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
