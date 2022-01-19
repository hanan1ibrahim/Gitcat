//
//  PrivateStarredReposViewController.swift
//  Gitcat
//
//  Created by HANAN on 14/05/1443 AH.
//

import UIKit
import Alamofire
import SafariServices

class PrivateStarredReposViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
   
    // MARK: - Varibles
    let spinner = UIActivityIndicatorView()
    let afSession: Session = {
        let interceptor = RequestIntercptor()
        return Session(
            interceptor: interceptor)
    }()
    var repositoriesModel = [Repository]()
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadingIndicator()
        initData()
        configureUI()
    }
    // MARK: - Functions
    func loadingIndicator() {
        spinner.style = UIActivityIndicatorView.Style.large
        spinner.center = view.center
        view.addSubview(spinner)
    }
    func initData() {
        getReposList()
    }
    func configureUI() {
        title = Titles.starredViewTitle
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
    func getReposList() {
        spinner.startAnimating()
        let requestURL = Router.privateStarredReposAPILink
        afSession.request(requestURL).responseDecodable(of: [Repository].self, completionHandler: { response in
            switch response.result {
            case .success(_):
                guard let repository = response.value else {return}
                self.repositoriesModel = repository
                self.tableView.reloadData()
                self.spinner.stopAnimating()
            case .failure(let error):
                self.presentAlert(title: "Error", msg: error.localizedDescription, btnTitle: "Ok")
            }
        })
    }
}
 // MARK: - TableView
extension PrivateStarredReposViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repositoriesModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ReposCell
        let model = repositoriesModel[indexPath.row]
        cell.userRepoName?.text = model.repositoryName
        cell.userRepoDescription?.text = model.repositoryDescription
        cell.userRepoLangauge?.text = model.repositoryLanguage
        cell.userRepoStars.isHidden = true
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

