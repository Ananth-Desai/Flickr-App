//
//  SearchResultsVC.swift
//  Flickr
//
//  Created by Ananth Desai on 17/03/22.
//

import Foundation
import UIKit
import Nuke

struct Photos: Codable {
    var photos: PhotoArray
}

struct PhotoArray: Codable {
    var photo: [SinglePhoto]
    
    func getPhotoArray() -> [SinglePhoto] {
        return photo;
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func returnImageView(cell: UICollectionViewCell, indexPath: IndexPath) -> [NSLayoutConstraint] {
        let imageView = UIImageView()
        imageView.tag = 10
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.sizeToFit()
        Nuke.loadImage(with: photos[indexPath.row], into: imageView)
        cell.addSubview(imageView)
        
        return [
            imageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: cell.topAnchor)
        ]
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = navigationBarTitleColor
        let constraints = setupCollectionView()
        NSLayoutConstraint.activate(constraints)
        self.fetchPhotos(searchString: searchString ?? "")
    }
    
    private func returnSearchUrl(searchString: String) -> URL? {
        return URL(string: "\(baseSearchUrl)/?method=\(apiMethod)&api_key=\(apiKey)&format=\(format)&nojsoncallback=\(noJsonCallback)&text=\(searchString)")
    }

    private func returnImageURl(image: SinglePhoto) -> URL? {
        return URL(string: "\(imageSearchUrl)/\(image.server)/\(image.id)_\(image.secret).jpg")
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
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionViewLayout.itemSize = CGSize(width: 123.0, height: 120.0)
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
}

extension SearchResultsVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath)
        let imageViewConstriants = returnImageView(cell: cell, indexPath: indexPath)
        NSLayoutConstraint.activate(imageViewConstriants)
        
        return cell
    }
}

// MARK: Constants

private let navigationBarTitleColor = UIColor(red: 0.952, green: 0.219, blue: 0.474, alpha: 1.0)
private let baseSearchUrl = "https://www.flickr.com/services/rest"
private let imageSearchUrl = "https://live.staticflickr.com"
private let apiKey = "397717930841a3bd19df470ac48fc84f"
private let apiMethod = "flickr.photos.search"
private let format = "json"
private let noJsonCallback = 1
