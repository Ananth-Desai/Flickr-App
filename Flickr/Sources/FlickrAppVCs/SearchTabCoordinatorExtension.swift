//
//  SearchTabCoordinatorExtension.swift
//  Flickr
//
//  Created by Ananth Desai on 20/03/22.
//

import Foundation

extension SearchTabCoordinator: SearchScreenViewControllerDelegate {
    func didTapSearchButton(searchString: String) {
        let searchResultsVC = SearchResultsVC()
        searchResultsVC.title = searchString
        rootNavigationController?.pushViewController(searchResultsVC, animated: true)
    }
}
