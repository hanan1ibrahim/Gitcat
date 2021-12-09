//
//  BookmarksViewController.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

import UIKit

class BookmarksViewController: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    //MARK:- Varibles
    var searchController = UISearchController(searchResultsController: nil)
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController(search: searchController)
        configureUI()
        setupTableView()
        initData()
    }
    //MARK:- Functions
    func initData() {
        
    }
    func configureUI() {
        title = "Bookmarks"
        searchController.searchBar.delegate = self
        searchLabel.text = "Search For Bookmarks"
        searchLabel.isHidden = true
    }
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCellNib(cellClass: UsersCell.self)
        tableView.registerCellNib(cellClass: ReposCell.self)
    }
}
//MARK:- TableView
extension BookmarksViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeue() as UsersCell
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeue() as ReposCell
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
           return "Users"
        case 1:
           return "Repositories"
        default:
            return ""
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
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
       return .delete
   }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {
           tableView.beginUpdates()
           tableView.endUpdates()
       }
   }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK:- SearchBar
extension BookmarksViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
        searchLabel.isHidden = false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else {return}
        searchLabel.isHidden = true
        tableView.isHidden = false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.isHidden = false
        searchLabel.isHidden = true
    }
}
