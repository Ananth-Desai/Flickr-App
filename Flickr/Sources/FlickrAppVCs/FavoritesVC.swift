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
        textView.font = UIFont(name: favoritesDefaultTextFontName, size: favoritesDefaultTextFontSize)
        textView.textColor = textFieldColor
        textView.backgroundColor = viewBackgroundColor
        textView.textAlignment = .center
        textView.lineBreakMode = .byClipping
        textView.numberOfLines = textNumberOfLines
        view.addSubview(textView)

        return [
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: textViewCenterYAnchorConstant)
        ]
    }
}

// MARK: Constants

private let textFieldColor = returnColorPalette().favoritesDefaultTextColor
private let viewBackgroundColor = returnColorPalette().viewBackgroundColor
private let textNumberOfLines = 3
private let favoritesDefaultText = R.string.localizable.defaultText()
private let favoritesDefaultTextFontName = "Arial"
private let favoritesDefaultTextFontSize: CGFloat = 14
private let textViewCenterYAnchorConstant: CGFloat = -100
