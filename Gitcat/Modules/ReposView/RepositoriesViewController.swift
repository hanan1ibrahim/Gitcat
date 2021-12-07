//
//  RepositoriesViewController.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

import UIKit
import Alamofire
import SafariServices

class RepositoriesViewController: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    //MARK:- Varibles
    let spinner = UIActivityIndicatorView()
    var repositoriesModel = [Repository]()
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadingIndicator()
        getUsersList()
    }
    //MARK:- Functions
    func loadingIndicator() {
        spinner.style = UIActivityIndicatorView.Style.large
        spinner.center = view.center
        view.addSubview(spinner)
    }
    func configureUI() {
        title = "Repositories"
    }
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCellNib(cellClass: ReposCell.self)
    }
    func presentAlert(title: String, msg: String, btnTitle: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: btnTitle, style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    func getUsersList() {
        spinner.startAnimating()
        let requestURL = Router.repositoryAPIlink("language:Swift")
        AF.request(requestURL).responseDecodable(of: Repositories.self, completionHandler: { response in
                switch response.result {
                case .success(_):
                    guard let repository = response.value else {return}
                    self.repositoriesModel = repository.items
                    self.tableView.reloadData()
                    self.spinner.stopAnimating()
                case .failure(let error):
                    self.presentAlert(title: "Error", msg: error.localizedDescription, btnTitle: "Ok")
                }
            })
        }
}
// MARK:- TableView
extension RepositoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repositoriesModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ReposCell
        let model = repositoriesModel[indexPath.row]
        cell.userRepoName?.text = model.repositoryName
        cell.userRepoDescription?.text = model.repositoryDescription
        cell.userRepoStars?.text = "\(Int.random(in: 534..<8436))"
        cell.userRepoLangauge?.text = model.repositoryLanguage
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let repoURL = repositoriesModel[indexPath.row].repositoryURL
        let safariVC = SFSafariViewController(url: URL(string: repoURL)!)
        self.present(safariVC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
