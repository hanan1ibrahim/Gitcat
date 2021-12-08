//
//  UIVC+Ext.swift
//  Gitcat
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

import UIKit

extension UIViewController {
    func setupSearchController (search: UISearchController) {
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = true
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        search.searchBar.placeholder = "Search ..."
        navigationItem.searchController = search
    }
}
