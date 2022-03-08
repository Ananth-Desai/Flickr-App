//
//  HomeScreenVC.swift
//  Flickr-App
//
//  Created by Ananth Desai on 02/03/22.
//

import Foundation
import UIKit

class HomeScreenVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }

    private func setupViews() {
        let textFieldConstraints = setupTextField()
        NSLayoutConstraint.activate(textFieldConstraints)
        let searchButtonConstraints = setupSearchButton()
        NSLayoutConstraint.activate(searchButtonConstraints)
    }

    private func setupTextField() -> [NSLayoutConstraint] {
        let textField = UITextField()
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = textFieldPlaceholder
        textField.backgroundColor = textFieldBackground
        textField.tintColor = textFieldTintColor
        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        if #available(iOS 13.0, *) {
            textField.leftView = getPlaceholderButton()
        } else {
            // Fallback on earlier versions
        }

        view.addSubview(textField)
        return [
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            textField.widthAnchor.constraint(equalToConstant: 330)
        ]
    }

    private func setupSearchButton() -> [NSLayoutConstraint] {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = buttonRadius
        button.setTitle(buttonTitle, for: .normal)
        button.backgroundColor = buttonColor
        button.setTitleColor(.white, for: .normal)
        view.addSubview(button)

        return [
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 270),
            button.widthAnchor.constraint(equalToConstant: 100)
        ]
    }

    private func getPlaceholderButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        button.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = textFieldIconColor
        return button
    }
}

// MARK: Constants

private let textFieldBackground = UIColor(red: 0.462, green: 0.462, blue: 0.501, alpha: 0.12)
private let textFieldIconColor = UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1.0)
private let textFieldPlaceholder = "Search Flickr..."
private let buttonTitle = "Search"
private let buttonRadius: CGFloat = 10
private let buttonColor = UIColor(red: 0, green: 0.835, blue: 0.498, alpha: 1)
private let textFieldTintColor = UIColor(red: 0.952, green: 0.219, blue: 0.474, alpha: 1.0)
