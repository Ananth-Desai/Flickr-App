//
//  FavoritesVC.swift
//  Flickr-App
//
//  Created by Ananth Desai on 02/03/22.
//

import Foundation
import UIKit

class FavoritesVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewBackgroundColor
        let constraints = setupView()
        NSLayoutConstraint.activate(constraints)
    }

    private func setupView() -> [NSLayoutConstraint] {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = favoritesDefaultText
        textView.font = UIFont(name: "Arial", size: 14)
        textView.textColor = textFieldColor
        textView.backgroundColor = viewBackgroundColor
        textView.textAlignment = .center
        textView.lineBreakMode = .byClipping
        textView.numberOfLines = textNumberOfLines
        view.addSubview(textView)

        return [
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
        ]
    }
}

// MARK: Constants

private let textFieldColor = UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1.0)
private let viewBackgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
private let textNumberOfLines = 3
private let favoritesDefaultText = R.string.localizable.defaultText()
