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

class SearchResultsVC: UIViewController {
    private var photos: [URL] = []
    private var searchString: String?
    private var collectionView: UICollectionView?

    init(searchString: String) {
        self.searchString = searchString
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func returnImageView(cell: UICollectionViewCell, indexPath: IndexPath) -> [NSLayoutConstraint] {
        let imageView = UIImageView()
        imageView.tag = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.sizeToFit()
        Nuke.loadImage(with: photos[indexPath.row], into: imageView)
        cell.addSubview(imageView)

        return [
            imageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: cell.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = navigationBarTitleColor
        let constraints = setupCollectionView()
        NSLayoutConstraint.activate(constraints)
        fetchPhotos(searchString: searchString ?? "")
    }

    private func returnSearchUrl(searchString: String) -> URL? {
        URL(string: "\(baseSearchUrl)/?method=\(apiMethod)&api_key=\(apiKey)&format=\(format)&nojsoncallback=\(noJsonCallback)&text=\(searchString)")
    }

    private func returnImageURl(image: SinglePhoto) -> URL? {
        URL(string: "\(imageSearchUrl)/\(image.server)/\(image.id)_\(image.secret).jpg")
    }

    private func constructIndividualUrls(_ result: Photos) -> [URL] {
        var individualPhotoUrls: [URL] = []
        for photo in result.photos.photo {
            guard let imageUrl = returnImageURl(image: photo) else {
                return []
            }
            individualPhotoUrls.append(imageUrl)
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
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        })
        task.resume()
    }

    func setupCollectionView() -> [NSLayoutConstraint] {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = 3
        collectionViewLayout.minimumLineSpacing = 3
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionViewLayout.itemSize = CGSize(width: view.frame.width / 3.2, height: 120.0)
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: collectionViewLayout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "customCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView = collectionView
        view.addSubview(collectionView)

        return [
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
    }

    func returnSpinner(cell: UICollectionViewCell) -> [NSLayoutConstraint] {
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(spinner)
        return [
            spinner.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ]
    }
}

extension SearchResultsVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        photos.isEmpty ? 20 : photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath)
        if photos.isEmpty {
            let spinnerConstraints = returnSpinner(cell: cell)
            NSLayoutConstraint.activate(spinnerConstraints)
        } else {
            let imageViewConstriants = returnImageView(cell: cell, indexPath: indexPath)
            NSLayoutConstraint.activate(imageViewConstriants)
        }
        return cell
    }
}

// MARK: Constants

private let baseSearchUrl = "https://www.flickr.com/services/rest"
private let imageSearchUrl = "https://live.staticflickr.com"
private let apiKey = "397717930841a3bd19df470ac48fc84f"
private let apiMethod = "flickr.photos.search"
private let format = "json"
private let noJsonCallback = 1
private let navigationBarTitleColor = returnColorPalette().navigationBarTitleColor
private let viewBackgroundColor = returnColorPalette().viewBackgroundColor
