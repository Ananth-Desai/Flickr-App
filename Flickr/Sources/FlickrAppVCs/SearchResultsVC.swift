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
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = navigationBarTitleColor
    }
}

// MARK: Constants

private let navigationBarTitleColor = UIColor(red: 0.952, green: 0.219, blue: 0.474, alpha: 1.0)
