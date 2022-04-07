//
//  FavoritesVC.swift
//  Flickr-App
//
//  Created by Ananth Desai on 02/03/22.
//

import Foundation
import Nuke
import UIKit

class FavoritesVC: UIViewController {
    weak var favoritesDelegate: FavoritesViewControllerDelegate?
    private weak var collectionView: UICollectionView!
    private weak var textView: UILabel!
    private var isFavouritesEmpty: Bool?
    private var favoritesArray: [FavoriteImageData]?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewBackgroundColor
        navigationController?.navigationBar.tintColor = navigationBarTitleColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let array = favoritesDelegate?.getFavoriteImagesFromStorage()
        favoritesArray = array
        guard let array = array else {
            return
        }
        if array.isEmpty {
            isFavouritesEmpty = true
        } else {
            isFavouritesEmpty = false
        }
        let constraints = setupView(favoritesArray: array)
        NSLayoutConstraint.activate(constraints)
    }

    override func viewDidAppear(_: Bool) {
        let array = favoritesDelegate?.getFavoriteImagesFromStorage()
        if favoritesArray?.count != array?.count {
            guard let array = array else {
                return
            }
            checkAndResetViews(favoritesArray: array)
            isFavouritesEmpty = array.isEmpty
        }
    }

    private func setupView(favoritesArray: [FavoriteImageData]?) -> [NSLayoutConstraint] {
        guard let favoritesArray = favoritesArray else {
            return []
        }
        if favoritesArray.isEmpty {
            let constraints = setupDefaultTextView()
            return constraints
        } else {
            let constraints = setupCollectionView()
            return constraints
        }
    }

    private func checkAndResetViews(favoritesArray: [FavoriteImageData]?) {
        guard let favoritesArray = favoritesArray else {
            return
        }
        self.favoritesArray = favoritesArray
        if favoritesArray.isEmpty {
            collectionView?.isHidden = true
            textView?.isHidden = false
        } else {
            textView?.isHidden = true
            if collectionView != nil {
                collectionView?.reloadData()
                collectionView?.isHidden = false
            } else {
                let constraints = setupCollectionView()
                NSLayoutConstraint.activate(constraints)
            }
        }
    }

    private func setupDefaultTextView() -> [NSLayoutConstraint] {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = favoritesDefaultText
        textView.font = UIFont(name: favoritesDefaultTextFontName, size: favoritesDefaultTextFontSize)
        textView.textColor = textFieldColor
        textView.backgroundColor = viewBackgroundColor
        textView.textAlignment = .center
        textView.lineBreakMode = .byClipping
        textView.numberOfLines = textNumberOfLines
        self.textView = textView
        view.addSubview(textView)

        return [
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: textViewCenterYAnchorConstant)
        ]
    }

    func setupCollectionView() -> [NSLayoutConstraint] {
        let collectionViewFlowLayout = returnCollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: collectionViewFlowLayout)
        collectionView.configureView { collectionView in
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        }
        self.collectionView = collectionView
        view.addSubview(collectionView)

        return [
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
    }

    func returnCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = minimumInteritemSpacing
        collectionViewLayout.minimumLineSpacing = minimumLineSpacing
        collectionViewLayout.sectionInset = sectionInset
        collectionViewLayout.itemSize = CGSize(width: (view.frame.width - 6) / 3, height: cellHeight)
        return collectionViewLayout
    }

    func returnImageView(cell _: UICollectionViewCell, indexPath _: IndexPath, imageData: Data?) -> UIImageView? {
        guard let imageData = imageData else {
            return nil
        }
        let imageView = UIImageView(image: UIImage(data: imageData))
        imageView.configureView { imageView in
            imageView.tag = 10
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
        }
        return imageView
    }

    func returnImageViewConstraints(imageView: UIImageView, cell: UICollectionViewCell) -> [NSLayoutConstraint] {
        [
            imageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: cell.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
        ]
    }
}

extension FavoritesVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        guard let favoritesArray = favoritesDelegate?.getFavoriteImagesFromStorage() else {
            return 0
        }
        return favoritesArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        guard let favoritesArray = favoritesDelegate?.getFavoriteImagesFromStorage() else {
            return cell
        }
        let imageData = favoritesArray[indexPath.row].imageData
        let imageView = returnImageView(cell: cell, indexPath: indexPath, imageData: imageData)
        guard let imageView = imageView else {
            return cell
        }
        cell.addSubview(imageView)
        let imageViewConstraints = returnImageViewConstraints(imageView: imageView, cell: cell)
        NSLayoutConstraint.activate(imageViewConstraints)

        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let favoritesArray = favoritesDelegate?.getFavoriteImagesFromStorage() else {
            return
        }
        favoritesDelegate?.selectedImageFromFavoritesVC(imageData: favoritesArray[indexPath.row].imageData, imageTitle: favoritesArray[indexPath.row].imageTitle, imageId: favoritesArray[indexPath.row].imageId)
    }
}

// MARK: Constants

private let textFieldColor = R.color.favoritesDefaultText()
private let navigationBarTitleColor = R.color.navigationBarTintColor()
private let viewBackgroundColor = R.color.viewBackground()
private let textNumberOfLines = 3
private let favoritesDefaultText = R.string.localizable.defaultText()
private let favoritesDefaultTextFontName = "Arial"
private let favoritesDefaultTextFontSize: CGFloat = 14
private let textViewCenterYAnchorConstant: CGFloat = -100
private let cellHeight: CGFloat = 120
private let cellReuseIdentifier = "favoritesCell"
private let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
private let minimumInteritemSpacing: CGFloat = 3
private let minimumLineSpacing: CGFloat = 3
