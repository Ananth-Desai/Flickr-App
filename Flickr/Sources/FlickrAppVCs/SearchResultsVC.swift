//
//  SearchResultsVC.swift
//  Flickr
//
//  Created by Ananth Desai on 17/03/22.
//

import Foundation
import UIKit

class SearchResultsVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewBackgroundColor
        navigationController?.navigationBar.tintColor = navigationBarTitleColor
    }
}

// MARK: Constants

private let navigationBarTitleColor = returnColorPalette().navigationBarTitleColor
private let viewBackgroundColor = returnColorPalette().viewBackgroundColor
