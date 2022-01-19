//
//  FollowersViewController.swift
//  Gitcat
//
//  Created by HANAN on 14/05/1443 AH.
//

import UIKit
import Alamofire

class FollowersViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
// MARK: - IBOutlets
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var searchLabel: UILabel!

// MARK: - Varibles
    
    let afSession: Session = {
        let interceptor = RequestIntercptor()
        return Session(
            interceptor: interceptor)
    }()
    let spinner = UIActivityIndicatorView()
    var followingModel = [Following]() {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellNib(cellClass: UsersCell.self)
        getFollowingList()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    @objc func refresh(_ sender: AnyObject) {
        getFollowingList()
        refreshControl.endRefreshing()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            getFollowingList()
            tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        getFollowingList()
        tableView.reloadData()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        getFollowingList()
        tableView.reloadData()
    }
    func presentAlert(title: String, msg: String, btnTitle: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: btnTitle, style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    func getFollowingList() {
        spinner.startAnimating()
        let requestURL = Router.privateFollwersAPIlink
        afSession.request(requestURL).responseDecodable(of: [Following].self, completionHandler: { response in
                switch response.result {
                case .success(_):
                    guard let users = response.value else {return}
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.spinner.stopAnimating()
                        self.followingModel = users
                    }
                case .failure(let error):
                    self.presentAlert(title: "Error", msg: error.localizedDescription, btnTitle: "Ok")
                }
            })
        }
}
// MARK: - TableView

extension FollowersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        followingModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as UsersCell
        cell.userName.text = followingModel[indexPath.row].userName
        let avatarURL = followingModel[indexPath.row].userAvatar
        cell.userAvatar.downloadImage(urlString: avatarURL)
        cell.userAvatar.layer.cornerRadius = UsersCell.profileImageSize.width / 2.0
        cell.userAvatar.contentMode = .scaleAspectFill
        cell.userAvatar.layer.masksToBounds = false
        cell.userAvatar.layer.cornerRadius = cell.userAvatar.frame.height/2
        cell.userAvatar.clipsToBounds = true
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

