//
//  BookmarksViewController.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

import UIKit
import CoreData
import SafariServices

class BookmarksViewController: UIViewController {
    var bookmarkedRepos = [SavedRepositories]()
    var bookmarkedUsers = [SavedUsers]()
    // searchLabel appear before searching
    let conditionLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //MARK: - @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    //MARK: - @Props
    lazy var searchController = UISearchController(searchResultsController: nil)
    //MARK: - UIcomponent
    let searchLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = Titles.searchForBookmarks
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        renderViewData(tableView: tableView)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = Titles.bookmarksViewTitle
        renderViewData(tableView: tableView)
        noBookmarksState(tableView: tableView, conditionLabel: conditionLabel)
    }
    override func viewDidLayoutSubviews() {
        searchLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    //MARK: - Functions
    func initView() {
        title = Titles.bookmarksViewTitle
        tabBarItem.title = Titles.bookmarksViewTitle
        conditionLabel.text = Titles.noBookmarks
        searchController.searchBar.delegate = self
        setupSearchController(search: searchController)
        view.addSubview(searchLabel)
        view.addSubview(conditionLabel)
        searchLabel.isHidden = true
        searchLabel.alpha = 0.0
        tableViewData()
        noBookmarksState(tableView: tableView, conditionLabel: conditionLabel)
    }
    func tableViewData() {
        tableView.registerCellNib(cellClass: UsersCell.self)
        tableView.registerCellNib(cellClass: ReposCell.self)
        tableView.tableFooterView = UIView()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    func renderViewData (tableView: UITableView) {
        DataBaseManger.shared.fetch(returnType: SavedUsers.self) { [weak self] (users) in
            self?.bookmarkedUsers = users
            tableView.reloadData()
        }
        DataBaseManger.shared.fetch(returnType: SavedRepositories.self) {  [weak self] (reps) in
            self?.bookmarkedRepos = reps
            tableView.reloadData()
        }
    }
    func searchFromDB (tableView: UITableView ,searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText.isEmpty {
            renderViewData(tableView: tableView)
            DispatchQueue.main.async {
                tableView.reloadData()
            }
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
    func noBookmarksState (tableView: UITableView, conditionLabel: UILabel ) {
        if bookmarkedUsers.isEmpty == true , bookmarkedRepos.isEmpty == true {
            conditionLabel.isHidden = false
            tableView.isHidden = true
        } else {
            conditionLabel.isHidden = true
            tableView.isHidden = false
        }
    }
    func deleteAndFetchUsers(at indexPath: IndexPath , tableView: UITableView, conditionLabel: UILabel) {
        let item = bookmarkedUsers[indexPath.row]
        DataBaseManger().delete(returnType: SavedUsers.self, delete: item)
        DataBaseManger().fetch(returnType: SavedUsers.self) { (users) in
            self.bookmarkedUsers = users
        }
        noBookmarksState(tableView: tableView, conditionLabel: conditionLabel)
    }
    func deleteAndFetchRepos(at indexPath: IndexPath , tableView: UITableView, conditionLabel: UILabel) {
        let item = bookmarkedRepos[indexPath.row]
        DataBaseManger().delete(returnType: SavedRepositories.self, delete: item)
        DataBaseManger().fetch(returnType: SavedRepositories.self) { (repos) in
            self.bookmarkedRepos = repos
        }
        noBookmarksState(tableView: tableView, conditionLabel: conditionLabel)
    }
}
//MARK: - SearchBar
extension BookmarksViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
            self.searchLabel.isHidden = false
        }
        UIView.animate(withDuration: 0.0, animations: {
            self.searchLabel.alpha = 1.0
            self.tableView.alpha = 0.0
        })
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchLabel.isHidden = true
        searchFromDB(tableView: tableView, searchController: searchController)
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.searchLabel.alpha = 0.0
        })
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        renderViewData(tableView: tableView)
        DispatchQueue.main.async {
            self.searchController.searchBar.text = nil
            self.searchLabel.isHidden = true
        }
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.searchLabel.alpha = 0.0
        })
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
        switch section {
        case 0:
            return Titles.usersViewTitle
        default:
            return Titles.repositoriesViewTitle
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            switch indexPath.section {
            case 0:
                deleteAndFetchUsers(at: indexPath, tableView: self.tableView, conditionLabel: conditionLabel)
            default:
                deleteAndFetchRepos(at: indexPath, tableView: self.tableView, conditionLabel: conditionLabel)
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
