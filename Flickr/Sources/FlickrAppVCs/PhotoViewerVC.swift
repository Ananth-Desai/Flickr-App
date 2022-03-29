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
    private var favouriteState: Bool?
    private var imageTitle: String?
    private weak var stackView: UIStackView?
    private weak var imageView: UIImageView?
    private weak var favoriteEnabledButton: UIButton?
    private weak var favoriteDisabledButton: UIButton?

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
            stackView.alignment = .fill
            stackView.distribution = .fill
            stackView.spacing = 20
        }
        self.stackView = stackView
        let labelConstraints = returnLabel(stackView: stackView)
        NSLayoutConstraint.activate(labelConstraints)
        let iconConstraints = returnIcon(stackView: stackView)
        NSLayoutConstraint.activate(iconConstraints)
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
            label.topAnchor.constraint(equalTo: stackView.topAnchor),
            label.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -60),
        ]
    }

    private func returnIcon(stackView: UIStackView) -> [NSLayoutConstraint] {
        let enabledButton = UIButton()
        enabledButton.configureView { button in
            button.imageView?.contentMode = .scaleAspectFit
        }
        let filledIcon = filledHeartIcon
        enabledButton.isHidden = true
        enabledButton.setImage(filledIcon, for: .normal)
        enabledButton.addTarget(self, action: #selector(clickedFavorite), for: .touchUpInside)
        favoriteEnabledButton = enabledButton

        let disabledButton = UIButton()
        disabledButton.configureView { button in
            button.imageView?.contentMode = .scaleAspectFit
        }
        let outlinedIcon = outlinedHeartIcon
        disabledButton.setImage(outlinedIcon, for: .normal)
        disabledButton.isHidden = false
        disabledButton.addTarget(self, action: #selector(clickedFavorite), for: .touchUpInside)
        favoriteDisabledButton = disabledButton

        stackView.addArrangedSubview(enabledButton)
        stackView.addArrangedSubview(disabledButton)

        return [
            enabledButton.topAnchor.constraint(equalTo: stackView.topAnchor),
            disabledButton.topAnchor.constraint(equalTo: stackView.topAnchor)
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
        guard let favoriteEnabledButton = favoriteEnabledButton, let favoriteDisabledButton = favoriteDisabledButton else {
            return
        }
        guard let imageTitle = imageTitle else {
            return
        }

        if favoriteEnabledButton.isHidden == true {
            self.favoriteEnabledButton?.isHidden = !favoriteEnabledButton.isHidden
            self.favoriteDisabledButton?.isHidden = !favoriteDisabledButton.isHidden
            if let pngImage = imageView?.image?.pngData() {
                UserDefaults.standard.set(pngImage, forKey: imageTitle)
            }
        } else {
            self.favoriteEnabledButton?.isHidden = !favoriteEnabledButton.isHidden
            self.favoriteDisabledButton?.isHidden = !favoriteDisabledButton.isHidden
            if let _ = UserDefaults.standard.object(forKey: imageTitle) as? Data {
                UserDefaults.standard.removeObject(forKey: imageTitle)
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
