//
//  BookmarksViewController.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

import UIKit
import CoreData

class BookmarksViewController: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchLabel: UILabel!
    //MARK: - UI Proprties
    var searchController = UISearchController(searchResultsController: nil)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //MARK: - Data Proprties
    var bookmarkedRepos = [SavedRepositories]()
    var bookmarkedUsers = [SavedUsers]()
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initViewData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initViewData()
        initUItitles()
    }
    //MARK: - UI Functions
    func initUI() {
        tableViewData()
        searchLabelData()
        initSearchBar()
        initUItitles()
    }
    func initViewData() {
        noBookmarksLabelState()
        fetchCoreDataModels()
    }
    func initUItitles() {
        title = Titles.bookmarksViewTitle
        tabBarItem.title = Titles.bookmarksViewTitle
    }
    func initSearchBar() {
        setupSearchController(search: searchController)
        searchController.searchBar.delegate = self
    }
    func searchLabelData() {
        searchLabel.text = Titles.noBookmarks
    }
    func tableViewData() {
        tableView.registerCellNib(cellClass: UsersCell.self)
        tableView.registerCellNib(cellClass: ReposCell.self)
        tableView.tableFooterView = UIView()
    }
    func noBookmarksLabelState() {
        if bookmarkedUsers.isEmpty == true && bookmarkedRepos.isEmpty == true {
            searchLabel.isHidden = false
            tableView.isHidden = true
        } else {
            searchLabel.isHidden = true
            tableView.isHidden = false
        }
    }
    //MARK: - Data Functions
    func fetchCoreDataModels() {
        DataBaseManger.shared.fetch(returnType: SavedUsers.self) { [weak self] (users) in
            self?.bookmarkedUsers = users
            self?.tableView.reloadData()
        }
        DataBaseManger.shared.fetch(returnType: SavedRepositories.self) {  [weak self] (reps) in
            self?.bookmarkedRepos = reps
            self?.tableView.reloadData()
        }
    }
    func searchFromCoreData() {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText.isEmpty {
            fetchCoreDataModels()
            tableView.reloadData()
        } else {
            let request : NSFetchRequest<SavedUsers> = SavedUsers.fetchRequest()
            request.predicate = NSPredicate(format: "userName CONTAINS [cd] %@", searchText)
            request.sortDescriptors = [NSSortDescriptor(key: "userName", ascending: true)]
            let request2 : NSFetchRequest<SavedRepositories> = SavedRepositories.fetchRequest()
            request2.predicate = NSPredicate(format: "repoName CONTAINS [cd] %@", searchText)
            request2.sortDescriptors = [NSSortDescriptor(key: "repoName", ascending: true)]
            do {
                bookmarkedUsers = try context.fetch(request)
                bookmarkedRepos = try context.fetch(request2)
                
            } catch {
                print(error)
            }
            tableView.reloadData()
        }
    }
    func deleteUsersFromTableView(at indexPath: IndexPath) {
        let item = bookmarkedUsers[indexPath.row]
        DataBaseManger().delete(returnType: SavedUsers.self, delete: item)
        DataBaseManger().fetch(returnType: SavedUsers.self) { (users) in
            self.bookmarkedUsers = users
        }
        noBookmarksLabelState()
    }
    func deleteRepositoriesFromTableView(at indexPath: IndexPath) {
        let item = bookmarkedRepos[indexPath.row]
        DataBaseManger().delete(returnType: SavedRepositories.self, delete: item)
        DataBaseManger().fetch(returnType: SavedRepositories.self) { (repos) in
            self.bookmarkedRepos = repos
        }
        noBookmarksLabelState()
    }
}
//MARK:- TableView
extension BookmarksViewController: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return bookmarkedUsers.count
        default:
            return bookmarkedRepos.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            let cell = tableView.dequeue() as UsersCell
            cell.cellData(with: bookmarkedUsers[indexPath.row])
            return cell
        default:
            let cell = tableView.dequeue() as ReposCell
            cell.cellData(with: bookmarkedRepos[indexPath.row])
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerText = UILabel()
        switch section {
        case 0:
            if bookmarkedUsers.isEmpty == false {
                headerText.text = Titles.usersViewTitle
            } else {
                headerText.text = nil
            }
        default:
            if bookmarkedRepos.isEmpty == false {
                headerText.text = Titles.repositoriesViewTitle
            } else {
                headerText.text = nil
            }
        }
        return headerText.text
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            switch indexPath.section {
            case 0:
                deleteUsersFromTableView(at: indexPath)
            default:
                deleteRepositoriesFromTableView(at: indexPath)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 60
        default:
            return 100
        }
    }
}

//MARK: - SearchBar
extension BookmarksViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchLabel.isHidden = false
        tableView.isHidden = true
        searchLabel.text = "Search For Bookmarks"
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchLabel.isHidden = true
        tableView.isHidden = false
        searchFromCoreData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchCoreDataModels()
        noBookmarksLabelState()
        searchLabel.text = Titles.noBookmarks
    }
}
