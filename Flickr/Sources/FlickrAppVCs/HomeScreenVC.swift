//
//  HomeScreenVC.swift
//  Flickr-App
//
//  Created by Ananth Desai on 02/03/22.
//

import Foundation
import LeoUI
import UIKit

class HomeScreenVC: UIViewController {
    private var progressButton: ProgressButton?
    private var searchButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }

    private func setupViews() {
        if #available(iOS 13.0, *) {
            let textFieldConstraints = setupTextField()
            NSLayoutConstraint.activate(textFieldConstraints)
        } else {
            // Fallback on earlier versions
        }
        let searchButtonConstraints = setupSearchButton()
        NSLayoutConstraint.activate(searchButtonConstraints)

        let progressButtonConstraints = setupProgressButton()
        NSLayoutConstraint.activate(progressButtonConstraints)
    }

    @available(iOS 13.0, *)
    private func setupTextField() -> [NSLayoutConstraint] {
        let label = UISearchTextField()
        label.leftViewMode = .always
        label.translatesAutoresizingMaskIntoConstraints = false
        label.placeholder = textFieldPlaceholder
        label.backgroundColor = textFieldBackground
        label.tintColor = textFieldTintColor
        label.borderStyle = .roundedRect
        label.keyboardType = .default
        view.addSubview(label)
        return [
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ]
    }

    private func setupSearchButton() -> [NSLayoutConstraint] {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = buttonRadius
        button.setTitle(buttonTitle, for: .normal)
        button.backgroundColor = buttonColor
        button.setTitleColor(.white, for: .normal)
        button.contentEdgeInsets = buttonEdgeInsets
        button.addTarget(self, action: #selector(clickedSearch), for: .touchUpInside)
        searchButton = button
        view.addSubview(button)

        return [
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
        ]
    }

    private func setupProgressButton() -> [NSLayoutConstraint] {
        let progress = ProgressButton(frame: CGRect())
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.isHidden = true
        progress.showProgress()
        progressButton = progress
        view.addSubview(progress)

        return [
            progress.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progress.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
        ]
    }

    @objc private func clickedSearch() {
        searchButton?.isHidden = true
        progressButton?.isHidden = false
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
            self.progressButton?.isHidden = true
            self.searchButton?.isHidden = false
            timer.invalidate()
        }
    }
}

// MARK: Constants

private let textFieldBackground = UIColor(red: 0.462, green: 0.462, blue: 0.501, alpha: 0.02)
private let textFieldIconColor = UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1.0)
private let textFieldPlaceholder = "Search Flickr..."
private let buttonTitle = "Search"
private let buttonRadius: CGFloat = 10
private let buttonColor = UIColor(red: 0, green: 0.835, blue: 0.498, alpha: 1)
private let textFieldTintColor = UIColor(red: 0.952, green: 0.219, blue: 0.474, alpha: 1.0)
private let buttonEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
