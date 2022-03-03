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

        let constraints = setupStackView()
        NSLayoutConstraint.activate(constraints)
    }

    private func setupStackView() -> [NSLayoutConstraint] {
        let stackView = UIStackView(arrangedSubviews: [setupTextField(), setupSearchButton()])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = stackViewSpacing
        stackView.distribution = .equalCentering

        view.addSubview(stackView)

        return [
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: stackViewYConstant),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: stackViewWidthConstant)
        ]
    }

    private func setupTextField() -> UITextField {
        let textField = UITextField()
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = textFieldPlaceholder
        textField.backgroundColor = textFieldBackground
        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        if #available(iOS 13.0, *) {
            textField.leftView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        } else {
            // Fallback on earlier versions
        }
        return textField
    }

    private func setupSearchButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = buttonRadius
        button.setTitle(buttonTitle, for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        return button
    }
}

// MARK: Constants

private let textFieldBackground = UIColor(red: 0.462, green: 0.462, blue: 0.501, alpha: 0.12)
private let textFieldPlaceholder = "Search Flickr..."
private let stackViewYConstant: CGFloat = -80
private let stackViewWidthConstant: CGFloat = -40
private let stackViewSpacing: CGFloat = 20
private let buttonTitle = "Search"
private let buttonRadius: CGFloat = 10
