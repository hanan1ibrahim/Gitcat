//
//  UIVC+Ext.swift
//  Gitcat
//
//  Created by Ali Fayed on 08/12/2021.
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
