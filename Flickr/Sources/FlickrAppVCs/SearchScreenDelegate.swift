//
//  SearchScreenDelegate.swift
//  Flickr
//
//  Created by Ananth Desai on 20/03/22.
//

import Foundation

protocol SearchScreenViewControllerDelegate: AnyObject {
    func didTapSearchButton(searchString: String)
}
