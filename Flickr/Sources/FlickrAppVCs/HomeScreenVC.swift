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
    private var searchString: UITextField?

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
        let textField = UISearchTextField()
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = NSLocalizedString("searchFieldPlaceholder", comment: "")
        textField.backgroundColor = textFieldBackground
        textField.tintColor = textFieldTintColor
        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        textField.addTarget(self, action: #selector(setButtonBackground), for: .editingChanged)
        searchString = textField
        view.addSubview(textField)
        return [
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ]
    }

    private func setupSearchButton() -> [NSLayoutConstraint] {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = buttonRadius
        button.setTitle(NSLocalizedString("searchButtonTitle", comment: ""), for: .normal)
        button.backgroundColor = disabledButtonColor
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
        let progress = ProgressButton()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.layer.cornerRadius = buttonRadius
        progress.isHidden = true
        progress.backgroundColor = enabledButtonColor
        progress.contentEdgeInsets = buttonEdgeInsets
        progress.setTitle("", for: .normal)
        progress.setTitleColor(.white, for: .normal)
        progress.showProgress()
        progressButton = progress
        view.addSubview(progress)

        return [
            progress.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progress.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            progress.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            progress.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: 50)
        ]
    }

    @objc private func setButtonBackground() {
        searchButton?.isEnabled = (searchString?.text!.count)! > 0 ? true : false
        searchButton?.backgroundColor = (searchString?.text!.count)! > 0 ? enabledButtonColor : disabledButtonColor
    }

    @objc private func clickedSearch() {
        let errorCoordinator = Flickr.ErrorCoordinator()
        guard let alertVC = errorCoordinator.handleSearchStringErrors(searchString: searchString?.text) else {
            searchButton?.isHidden = true
            progressButton?.isHidden = false
            _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                self.progressButton?.isHidden = true
                self.searchButton?.isHidden = false
                timer.invalidate()
            }
            return
        }
        present(alertVC, animated: true, completion: nil)
    }
}

// MARK: Constants

private let textFieldBackground = UIColor(red: 0.462, green: 0.462, blue: 0.501, alpha: 0.02)
private let textFieldIconColor = UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1.0)
private let buttonRadius: CGFloat = 10
private let enabledButtonColor = UIColor(red: 0, green: 0.835, blue: 0.498, alpha: 1)
private let disabledButtonColor = UIColor(red: 0, green: 0.835, blue: 0.498, alpha: 0.5)
private let textFieldTintColor = UIColor(red: 0.952, green: 0.219, blue: 0.474, alpha: 1.0)
private let buttonEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
