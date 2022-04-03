//
//  SearchResultsVC.swift
//  Flickr
//
//  Created by Ananth Desai on 17/03/22.
//

import Foundation
import Nuke
import UIKit

struct Photos: Codable {
    var photos: PhotoArray
}

struct PhotoArray: Codable {
    var photo: [SinglePhoto]

    func getPhotoArray() -> [SinglePhoto] {
        photo
    }
}

struct SinglePhoto: Codable {
    var id: String
    var owner: String
    var secret: String
    var server: String
    var title: String
}

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didSelectImage(url: URL, title: String, imageTitle: String)
}

class SearchResultsVC: UIViewController {
    private var photos: [URL] = []
    private var imageTitles: [String] = []
    private var searchString: String?
    private var collectionView: UICollectionView!
    private var progressView: UIActivityIndicatorView!
    private var constants = GlobalConstants()
    weak var searchResultsDelegate: SearchResultsViewControllerDelegate?

    init(searchString: String) {
        self.searchString = searchString
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewBackgroundColor
        navigationController?.navigationBar.tintColor = navigationBarTitleColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let collectionViewConstriants = setupCollectionView()
        let progressViewConstraints = setupProgressView()
        NSLayoutConstraint.activate(progressViewConstraints + collectionViewConstriants)
        fetchPhotos(searchString: searchString ?? "")
    }

    private func returnSearchUrl(searchString: String) -> URL? {
        constants.returnSearchUrl(searchString: searchString)
    }

    private func returnImageURl(image: SinglePhoto) -> URL? {
        constants.returnImageUrl(image: image)
    }

    private func constructIndividualUrls(_ result: Photos) -> [URL] {
        var individualPhotoUrls: [URL] = []
        for photo in result.photos.photo {
            guard let imageUrl = returnImageURl(image: photo) else {
                return []
            }
            individualPhotoUrls.append(imageUrl)
            imageTitles.append(photo.title)
        }
        return individualPhotoUrls
    }

    func fetchPhotos(searchString: String) {
        var photosArray: [URL] = []
        guard let url = returnSearchUrl(searchString: searchString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            var result: Photos?
            do {
                result = try JSONDecoder().decode(Photos.self, from: data)
            } catch {
                return
            }
            guard let result = result else {
                return
            }
            photosArray = self.constructIndividualUrls(result)
            self.photos = photosArray
            DispatchQueue.main.async { [self] in
                progressView.stopAnimating()
                collectionView.isHidden = false
                self.collectionView?.reloadData()
            }
        })
        task.resume()
    }

    func setupProgressView() -> [NSLayoutConstraint] {
        let progressView = UIActivityIndicatorView()
        progressView.configureView { progressView in
            progressView.startAnimating()
            progressView.hidesWhenStopped = true
        }
        view.addSubview(progressView)
        self.progressView = progressView
        return [
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: progressViewCenterYAnchorConstant)
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

    func setupCollectionView() -> [NSLayoutConstraint] {
        let collectionViewFlowLayout = returnCollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: collectionViewFlowLayout)
        collectionView.configureView { collectionView in
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.isHidden = true
            collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
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
}

extension SearchResultsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? CustomCollectionViewCell
        cell?.setupCollectionViewCell(photos: photos, indexPath: indexPath.row)
        guard let cell = cell else {
            return UICollectionViewCell()
        }
        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let searchString = self.searchString, photos.isEmpty == false else {
            return
        }
        searchResultsDelegate?.didSelectImage(url: photos[indexPath.row], title: searchString, imageTitle: imageTitles[indexPath.row])
    }
}

// MARK: Constants

private let navigationBarTitleColor = R.color.navigationBarTintColor()
private let viewBackgroundColor = R.color.viewBackground()
private let cellHeight: CGFloat = 120
private let placeholderCount = 20
private let cellReuseIdentifier = "customCell"
private let minimumInteritemSpacing: CGFloat = 3
private let minimumLineSpacing: CGFloat = 3
private let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
private let progressViewCenterYAnchorConstant: CGFloat = -50
