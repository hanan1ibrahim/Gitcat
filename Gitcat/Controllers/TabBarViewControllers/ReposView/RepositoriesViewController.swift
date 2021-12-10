//
//  RepositoriesViewController.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

import UIKit
import Alamofire
import SafariServices
import CoreData

class RepositoriesViewController: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchLabel: UILabel!
    //MARK:- Varibles
    let spinner = UIActivityIndicatorView()
    let afSession: Session = {
        let interceptor = RequestIntercptor()
        return Session(
            interceptor: interceptor)
    }()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var searchController = UISearchController(searchResultsController: nil)
    var repositoriesModel = [Repository]()
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadingIndicator()
        initData()
        setupSearchController(search: searchController)
        configureUI()
    }
    //MARK:- Functions
    func loadingIndicator() {
        spinner.style = UIActivityIndicatorView.Style.large
        spinner.center = view.center
        view.addSubview(spinner)
    }
    func initData() {
        getReposList(query: "language:Swift")
    }
    func configureUI() {
        title = Titles.repositoriesViewTitle
        tabBarItem.title = Titles.repositoriesViewTitle
        searchController.searchBar.delegate = self
        searchLabel.isHidden = true
        searchLabel.text = "Search For repos.".localized()
        searchController.searchBar.placeholder = "Search ...".localized()
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
    func getReposList(query: String) {
        spinner.startAnimating()
        let requestURL = Router.repositoryAPIlink(query)
        afSession.request(requestURL).responseDecodable(of: Repositories.self, completionHandler: { response in
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
    func saveRepos(indexPath: IndexPath) {
        let saveRepoInfo = SavedRepositories(context: self.context)
        let repository = repositoriesModel[indexPath.row]
        saveRepoInfo.repoName = repository.repositoryName
        saveRepoInfo.repoDescreipion = repository.repositoryDescription
        saveRepoInfo.repoProgLang = repository.repositoryLanguage
        saveRepoInfo.repoURL = repository.repositoryURL
        try! self.context.save()
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
    func tableView( _ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = "\(String(describing: index))" as NSString
        return UIContextMenuConfiguration( identifier: identifier, previewProvider: nil) { [weak self] _ in
            let bookmarkAction = UIAction(title: Titles.bookmark, image: UIImage(systemName: "bookmark.fill")) { _ in
                self?.saveRepos(indexPath: indexPath)
            }
            let safariAction = UIAction(
                title: Titles.urlTitle,
                image: UIImage(systemName: "link")) { _ in
                let repoURL = self?.repositoriesModel[indexPath.row].repositoryURL
                let safariVC = SFSafariViewController(url: URL(string: repoURL ?? "")!)
                self?.present(safariVC, animated: true)
            }
            
            let shareAction = UIAction(
                title: Titles.share,
                image: UIImage(systemName: "square.and.arrow.up")) { _ in
                let image = UIImage(systemName: "bell")
                let repoURL = self?.repositoriesModel[indexPath.row].repositoryURL
                let sheetVC = UIActivityViewController(activityItems: [image!,repoURL!], applicationActivities: nil)
                self?.present(sheetVC, animated: true)
            }
            
            return UIMenu(title: "", image: nil, children: [safariAction ,bookmarkAction, shareAction])
        }
    }
}
// MARK:- SearchBar
extension RepositoriesViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
        searchLabel.isHidden = false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else {return}
        getReposList(query: query)
        searchLabel.isHidden = true
        tableView.isHidden = false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        getReposList(query: "language:Swift")
        tableView.isHidden = false
        searchLabel.isHidden = true
    }
}
