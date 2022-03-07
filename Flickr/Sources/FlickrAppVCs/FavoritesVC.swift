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
        setupView()
    }

    private func setupView() {
        let textView = UITextView(frame: CGRect(x: 0, y: view.frame.height / 4, width: view.frame.width, height: 50))
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = defaultText
        textView.font = UIFont(name: "Arial", size: 14)
        textView.textColor = textFieldColor
        textView.backgroundColor = viewBackgroundColor
        textView.textAlignment = .center
        textView.isEditable = false
        view.addSubview(textView)
    }
}

// MARK: Constants

private let defaultText = "Search for a photo and mark it as your favorite. Photos marked as favorites can be viewed offline."
private let textFieldColor = UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1.0)
private let viewBackgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
