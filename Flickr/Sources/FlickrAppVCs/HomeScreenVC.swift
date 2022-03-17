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
    private weak var progressButton: ProgressButton?
    private weak var searchButton: UIButton?
    private weak var searchBar: UISearchBar?

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

        let progressButtonConstraints = setupProgressButton()
        NSLayoutConstraint.activate(progressButtonConstraints)
    }

    private func setupTextField() -> [NSLayoutConstraint] {
        let searchBar = UISearchBar()
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.addTarget(self, action: #selector(setButtonBackground), for: .editingChanged)
            searchBar.searchTextField.borderStyle = .roundedRect
        } else {
            // Fallback on earlier versions
            let searchTextField = searchBar.value(forKey: "searchField") as? UITextField
            searchTextField?.addTarget(self, action: #selector(setButtonBackground), for: .editingChanged)
            searchTextField?.borderStyle = .roundedRect
        }
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = NSLocalizedString("searchFieldPlaceholder", comment: "")
        searchBar.backgroundColor = textFieldBackground
        searchBar.tintColor = textFieldTintColor
        searchBar.keyboardType = .default
        self.searchBar = searchBar
        view.addSubview(searchBar)
        return [
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: searchBarCenterYAnchorConstant),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: searchBarLeadingAnchorConstant),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: searchBarTrailingAnchorConstant)
        ]
    }

    private func setupSearchButton() -> [NSLayoutConstraint] {
        let searchButton = UIButton()
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.layer.cornerRadius = buttonRadius
        searchButton.setTitle(NSLocalizedString("searchButtonTitle", comment: ""), for: .normal)
        searchButton.backgroundColor = disabledButtonColor
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.contentEdgeInsets = buttonEdgeInsets
        searchButton.addTarget(self, action: #selector(clickedSearch), for: .touchUpInside)
        self.searchButton = searchButton
        view.addSubview(searchButton)

        return [
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: searchButtonCenterYAnchotConstant)
        ]
    }

    private func setupProgressButton() -> [NSLayoutConstraint] {
        let progressButton = ProgressButton()
        progressButton.translatesAutoresizingMaskIntoConstraints = false
        progressButton.layer.cornerRadius = buttonRadius
        progressButton.isHidden = true
        progressButton.backgroundColor = enabledButtonColor
        progressButton.setTitleColor(.white, for: .normal)
        progressButton.showProgress()
        self.progressButton = progressButton
        view.addSubview(progressButton)
        guard let searchBar = searchBar else {
            return [
                progressButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                progressButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: progressButtonCenterYAnchorConstant),
                progressButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: progressButtonLeadingAnchorConstant),
                progressButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: progressButtonTrailingAnchorConstant)
            ]
        }

        return [
            progressButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: progressButtonCenterYAnchorConstant),
            progressButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: progressButtonLeadingAnchorConstant),
            progressButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: progressButtonTrailingAnchorConstant),
            progressButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor)
        ]
    }

    @objc private func setButtonBackground() {
        guard let searchBar = searchBar else {
            return
        }
        searchButton?.isEnabled = (searchBar.text?.count ?? 0) > 0 ? true : false
        searchButton?.backgroundColor = (searchBar.text?.count ?? 0) > 0 ? enabledButtonColor : disabledButtonColor
    }

    @objc private func clickedSearch() {
        let errorCoordinator = Flickr.ErrorCoordinator()
        let apiCoordinator = ApiCoordinator()
        guard let alertVC = errorCoordinator.handleSearchStringErrors(searchString: searchBar?.text) else {
            guard let searchBar = searchBar else {
                return
            }
            let searchStatus = apiCoordinator.fetchPhotos(searchString: searchBar.text ?? "")
            searchButton?.isHidden = true
            progressButton?.isHidden = false
            _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                self.progressButton?.isHidden = true
                self.searchButton?.isHidden = false
                timer.invalidate()
            }
            if searchStatus == true {
                let searchResultsVC = SearchResultsVC()
//                navigationController?.pushViewController(searchResultsVC, animated: true)
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
private let searchBarCenterYAnchorConstant: CGFloat = -150
private let searchBarLeadingAnchorConstant: CGFloat = 30
private let searchBarTrailingAnchorConstant: CGFloat = -30
private let searchButtonCenterYAnchotConstant: CGFloat = -100
private let progressButtonCenterYAnchorConstant: CGFloat = -100
private let progressButtonLeadingAnchorConstant: CGFloat = -50
private let progressButtonTrailingAnchorConstant: CGFloat = 50
