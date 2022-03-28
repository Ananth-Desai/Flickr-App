//
//  PhotoViewerVC.swift
//  Flickr
//
//  Created by Ananth Desai on 28/03/22.
//

import Foundation
import Nuke
import UIKit

class PhotoViewerVC: UIViewController {
    private var url: URL
    private var imageTitle: String?
    private weak var stackView: UIStackView?
    private weak var imageView: UIImageView?
    private weak var favoriteButton: UIButton?
    private var favouriteState: Bool?

    init(url: URL, title _: String, imageTitle: String) {
        self.url = url
        self.imageTitle = imageTitle
        favouriteState = false
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewBackgroundColor
        let imageViewConstraints = setupImageView(stackView: stackView)
        NSLayoutConstraint.activate(imageViewConstraints)
        let stackViewConstraints = setupStackView()
        NSLayoutConstraint.activate(stackViewConstraints)
    }

    private func setupStackView() -> [NSLayoutConstraint] {
        let stackView = UIStackView()
        stackView.configureView { stackView in
            stackView.axis = .horizontal
            stackView.distribution = .fillProportionally
            stackView.contentMode = .scaleAspectFill
            stackView.spacing = 20
        }
        self.stackView = stackView
        let iconConstraints = returnIcon(stackView: stackView)
        NSLayoutConstraint.activate(iconConstraints)
        let labelConstraints = returnLabel(stackView: stackView)
        NSLayoutConstraint.activate(labelConstraints)
        view.addSubview(stackView)

        guard let imageView = imageView else {
            return []
        }
        return [
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15.0),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15.0),
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20.0)
        ]
    }

    private func returnLabel(stackView: UIStackView) -> [NSLayoutConstraint] {
        let label = UILabel()
        label.configureView { label in
            label.text = imageTitle
            label.font = label.font.withSize(20)
            label.clipsToBounds = false
        }
        stackView.addArrangedSubview(label)
        return [
            label.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
        ]
    }

    private func returnIcon(stackView: UIStackView) -> [NSLayoutConstraint] {
        let button = UIButton()
        button.configureView { button in
            button.imageView?.contentMode = .scaleAspectFill
        }
        let icon = favouriteState! ? filledHeartIcon : outlinedHeartIcon
        button.setImage(icon, for: .normal)
        button.addTarget(self, action: #selector(clickedFavorite), for: .touchUpInside)
        favoriteButton = button
        stackView.addSubview(button)

        return [
            button.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ]
    }

    private func setupImageView(stackView _: UIStackView?) -> [NSLayoutConstraint] {
        let imageView = UIImageView()
        imageView.configureView { imageView in
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = imageViewBackgroundColor
        }
        self.imageView = imageView
        Nuke.loadImage(with: url, into: imageView)
        view.addSubview(imageView)

        return [
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
    }

    @objc func clickedFavorite() {
        guard let favouriteState = favouriteState else {
            return
        }
        self.favouriteState = !favouriteState
    }
}

// MARK: Constants

private let viewBackgroundColor = R.color.viewBackground()
private let imageViewBackgroundColor = R.color.tabBarBackground()
private let filledHeartIcon = R.image.heartFilled()
private let outlinedHeartIcon = R.image.heartOutlined()
