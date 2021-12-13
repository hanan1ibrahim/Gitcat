//
//  UsersViewController.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

import UIKit
import Alamofire
import SafariServices
import CoreData

class UsersViewController: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    //MARK:- Varibles
    let afSession: Session = {
        let interceptor = RequestIntercptor()
        return Session(
            interceptor: interceptor)
    }()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let spinner = UIActivityIndicatorView()
    var searchController = UISearchController(searchResultsController: nil)
    var usersModel = [User]()
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadingIndicator()
        configureUI()
        initData()
        setupSearchController(search: searchController)
        searchController.searchBar.placeholder = "Search ...".localized()
    }
    //MARK:- Functions
    func loadingIndicator() {
        spinner.style = UIActivityIndicatorView.Style.large
        spinner.center = view.center
        view.addSubview(spinner)
    }
    func initData() {
        getUsersList(query: "Jawaher")
    }
    func configureUI() {
        title = Titles.usersViewTitle
        tabBarItem.title = Titles.usersViewTitle
        searchController.searchBar.delegate = self
        searchLabel.isHidden = true
        searchLabel.text = "Search For users.".localized()
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
    func saveUserToBookmarks (indexPath: IndexPath) {
        let model = usersModel[indexPath.row]
        let items = SavedUsers(context: self.context)
        items.userName = model.userName
        items.userAvatar = model.userAvatar
        items.userURL = model.userURL
        try! self.context.save()
    }
    func getUsersList(query: String) {
        spinner.startAnimating()
        let requestURL = Router.usersListAPIlink(query)
        afSession.request(requestURL).responseDecodable(of: Users.self, completionHandler: { response in
            switch response.result {
            case .success(_):
                guard let users = response.value else {return}
                self.usersModel = users.items
                self.tableView.reloadData()
                self.spinner.stopAnimating()
            case .failure(let error):
                self.presentAlert(title: "Error", msg: error.localizedDescription, btnTitle: "Ok")
            }
        })
    }
    func followUser(user: String) {
        let requestURL = Router.privateUserFollowAPILink(user: user)
        afSession.request(requestURL).responseJSON { respone in
            switch respone.result {
            case .success(_):
                break
            case .failure(let error):
                self.presentAlert(title: "Error", msg: error.localizedDescription, btnTitle: "Ok")
            }
        }
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
    func tableView( _ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = "\(String(describing: index))" as NSString
        return UIContextMenuConfiguration( identifier: identifier, previewProvider: nil) { [weak self] _ in
            let bookmarkAction = UIAction(title: Titles.bookmark, image: UIImage(systemName: "bookmark.fill")) { _ in
                self?.saveUserToBookmarks(indexPath: indexPath)
            }
            let followAction = UIAction(title: Titles.follow, image: UIImage(systemName: "person.fill")) { _ in
                self?.followUser(user: self?.usersModel[indexPath.row].userName ?? "")
            }
            let safariAction = UIAction(
                title: Titles.urlTitle,
                image: UIImage(systemName: "link")) { _ in
                let userURL = self?.usersModel[indexPath.row].userURL
                let safariVC = SFSafariViewController(url: URL(string: userURL ?? "")!)
                self?.present(safariVC, animated: true)
            }
            
            let shareAction = UIAction(
                title: Titles.share,
                image: UIImage(systemName: "square.and.arrow.up")) { _ in
                let image = UIImage(systemName: "bell")
                let userURL = self?.usersModel[indexPath.row].userURL
                let sheetVC = UIActivityViewController(activityItems: [image!,userURL!], applicationActivities: nil)
                self?.present(sheetVC, animated: true)
            }
            
            return UIMenu(title: "", image: nil, children: [safariAction ,bookmarkAction, followAction, shareAction])
        }
    }
}
// MARK:- SearchBar
extension UsersViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
        searchLabel.isHidden = false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else {return}
        getUsersList(query: query)
        searchLabel.isHidden = true
        tableView.isHidden = false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        getUsersList(query: "Jawaher")
        tableView.isHidden = false
        searchLabel.isHidden = true
    }
}
