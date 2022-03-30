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
    private var favoriteState: Bool
    private var imageTitle: String?
    private weak var stackView: UIStackView?
    private weak var imageView: UIImageView?
    private weak var favoriteButton: UIButton?
    weak var photoViewerDelegate: PhotoViewerViewControllerDelegate?

    init(url: URL, imageTitle: String) {
        self.url = url
        self.imageTitle = imageTitle
        if UserDefaults.standard.object(forKey: imageTitle) != nil {
            favoriteState = true
        } else {
            favoriteState = false
        }
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewBackgroundColor
        let imageViewConstraints = setupImageView()
        let stackViewConstraints = setupStackView()
        let labelConstraints = returnLabel(stackView: stackView)
        let iconConstraints = returnIcon(stackView: stackView)
        NSLayoutConstraint.activate(imageViewConstraints + stackViewConstraints + labelConstraints + iconConstraints)
    }

    private func setupStackView() -> [NSLayoutConstraint] {
        let stackView = UIStackView()
        stackView.configureView { stackView in
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fill
            stackView.spacing = stackViewSpacing
        }
        self.stackView = stackView
        view.addSubview(stackView)

        guard let imageView = imageView else {
            return []
        }
        return [
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: stackViewLeadingAnchorConstant),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: stackViewTrailingAnchorConstant),
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: stackViewTopAnchorConstant)
        ]
    }

    private func returnLabel(stackView: UIStackView?) -> [NSLayoutConstraint] {
        let label = UILabel()
        label.configureView { label in
            label.text = imageTitle
            label.font = label.font.withSize(labelFontSize)
            label.clipsToBounds = false
        }
        guard let stackView = stackView else {
            return []
        }
        stackView.addArrangedSubview(label)

        return [
            label.topAnchor.constraint(equalTo: stackView.topAnchor),
            label.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: labelTrailingAnchorConstant)
        ]
    }

    private func returnIcon(stackView: UIStackView?) -> [NSLayoutConstraint] {
        let button = UIButton(type: .custom)
        button.configureView { button in
            button.setImage(self.favoriteState ? filledHeartIcon?.withRenderingMode(.alwaysTemplate) : outlinedHeartIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.addTarget(self, action: #selector(clickedFavorite), for: .touchUpInside)
            button.imageView?.tintColor = favoriteToggleButtonTintColor
        }
        guard let stackView = stackView else {
            return []
        }
        stackView.addArrangedSubview(button)
        favoriteButton = button

        return [
            button.topAnchor.constraint(equalTo: stackView.topAnchor)
        ]
    }

    private func setupImageView() -> [NSLayoutConstraint] {
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
        guard let favoriteButton = favoriteButton, let imageTitle = imageTitle else {
            return
        }
        if favoriteState {
            favoriteButton.setImage(outlinedHeartIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
            if UserDefaults.standard.object(forKey: imageTitle) != nil {
                UserDefaults.standard.removeObject(forKey: imageTitle)
                photoViewerDelegate?.popFromFavorites(url: url, title: imageTitle)
                favoriteState = false
            }
        } else {
            favoriteButton.setImage(filledHeartIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
            if let pngImage = imageView?.image?.pngData() {
                UserDefaults.standard.set(pngImage, forKey: imageTitle)
                photoViewerDelegate?.pushToFavorites(url: url, title: imageTitle)
                favoriteState = true
            }
        }
        return
    }
}

// MARK: Constants

private let viewBackgroundColor = R.color.viewBackground()
private let imageViewBackgroundColor = R.color.tabBarBackground()
private let filledHeartIcon = R.image.heartFilled()
private let outlinedHeartIcon = R.image.heartOutlined()
private let stackViewSpacing: CGFloat = 20
private let stackViewLeadingAnchorConstant: CGFloat = 15
private let stackViewTrailingAnchorConstant: CGFloat = -15
private let stackViewTopAnchorConstant: CGFloat = 20
private let labelFontSize: CGFloat = 20
private let labelTrailingAnchorConstant: CGFloat = -60
private let favoriteToggleButtonTintColor = R.color.favouriteToggleButtonTintColor()
