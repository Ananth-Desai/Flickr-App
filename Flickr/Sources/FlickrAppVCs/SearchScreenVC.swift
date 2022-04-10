//
//  NewSearchScreenVC.swift
//  Flickr
//
//  Created by Ananth Desai on 10/04/22.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol NewSearchScreenViewControllerDelegate: AnyObject {
    func didSelectImage(url: URL, title: String, imageTitle: String, imageId: String)
}

class NewSearchScreenVC: UIViewController {
    // MARK: Variables

    private weak var collectionView: UICollectionView!
    private weak var textView: UILabel!
    private weak var progressView: UIActivityIndicatorView!
    private var photos: [URL] = []
    private var searchString = BehaviorRelay<String>(value: "")
    private var nextVCTitle: String?
    private let disposeBag = DisposeBag()
    private let constants = GlobalConstants()
    private var imageTitles: [String] = []
    private var imageIDs: [String] = []
    weak var searchResultsDelegate: NewSearchScreenViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewBackgroundColor
        navigationController?.navigationBar.tintColor = navigationBarTintColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let textviewConstraints = setupDefaultTextView()
        let progressViewConstraints = setupProgressView()
        let collectionViewConstraints = setupCollectionView()
        NSLayoutConstraint.activate(textviewConstraints + progressViewConstraints + collectionViewConstraints)
        setSearchBarTargets()
        handleSearchStringSubscription()
    }

    private func setupDefaultTextView() -> [NSLayoutConstraint] {
        let textView = UILabel()
        textView.configureView { textView in
            textView.text = searchDefaultText
            textView.textAlignment = .center
            textView.lineBreakMode = .byClipping
            textView.numberOfLines = textNumberOfLines
            textView.textColor = defaultTextFontColor
            textView.font = UIFont(name: defaultTextFontName, size: defaultTextFontSize)
        }
        self.textView = textView
        view.addSubview(textView)

        return [
            textView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: defaultTextViewCenterYAnchorConstant),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: defaultTextViewLeadingAnchorConstant),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: defaultTextViewTrailingAnchorConstant)
        ]
    }

    private func returnCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = minimumInteritemSpacing
        collectionViewLayout.minimumLineSpacing = minimumLineSpacing
        collectionViewLayout.sectionInset = sectionInset
        collectionViewLayout.itemSize = CGSize(width: (view.frame.width - 6) / 3, height: cellHeight)
        return collectionViewLayout
    }

    private func setupCollectionView() -> [NSLayoutConstraint] {
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

    func setupProgressView() -> [NSLayoutConstraint] {
        let progressView = UIActivityIndicatorView()
        progressView.configureView { progressView in
            progressView.stopAnimating()
            progressView.hidesWhenStopped = true
        }
        view.addSubview(progressView)
        self.progressView = progressView
        return [
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: progressViewCenterYAnchorConstant)
        ]
    }

    private func setSearchBarTargets() {
        if #available(iOS 13.0, *) {
            navigationItem.searchController?.searchBar.searchTextField.addTarget(self, action: #selector(searchStringChanged), for: .editingDidEnd)
        } else {
            // Fallback on earlier versions
            let searchTextField = navigationItem.searchController?.searchBar.value(forKey: searchBarKey) as? UITextField
            searchTextField?.addTarget(self, action: #selector(searchStringChanged), for: .editingDidEnd)
        }
    }

    private func handleSearchStringSubscription() {
        searchString
            .asObservable()
            .subscribe(onNext: { string in
                if string.count > 2 {
                    self.progressView.startAnimating()
                    self.fetchPhotos(searchString: string)
                    self.nextVCTitle = string
                    self.textView.isHidden = true
                } else {
                    self.progressView.stopAnimating()
                    self.textView.isHidden = false
                    self.collectionView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }

    @objc private func searchStringChanged() {
        let newText = navigationItem.searchController?.searchBar.text
        if let newText = newText {
            searchString.accept(newText)
        }
    }

    func fetchPhotos(searchString: String) {
        var photosArray: [URL] = []
        imageTitles = []
        imageIDs = []
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
            imageIDs.append(photo.id)
        }
        return individualPhotoUrls
    }
}

// MARK: Extensions

extension NewSearchScreenVC: UICollectionViewDataSource, UICollectionViewDelegate {
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
        guard let nextVCTitle = nextVCTitle, photos.isEmpty == false else {
            return
        }
        searchResultsDelegate?.didSelectImage(url: photos[indexPath.row], title: nextVCTitle, imageTitle: imageTitles[indexPath.row], imageId: imageIDs[indexPath.row])
    }
}

// MARK: Constants

private let searchBarKey = "searchField"
private let viewBackgroundColor = R.color.viewBackground()
private let searchFieldPlaceholder = R.string.localizable.searchFieldPlaceholder()
private let searchDefaultText = R.string.localizable.searchScreenDefaultText()
private let textNumberOfLines = 3
private let defaultTextFontColor = R.color.favoritesDefaultText()
private let defaultTextFontName = "Arial"
private let defaultTextFontSize: CGFloat = 14
private let cellHeight: CGFloat = 120
private let cellReuseIdentifier = "customCell"
private let minimumInteritemSpacing: CGFloat = 3
private let minimumLineSpacing: CGFloat = 3
private let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
private let progressViewCenterYAnchorConstant: CGFloat = -50
private let navigationBarTintColor = R.color.navigationBarTintColor()
private let defaultTextViewCenterYAnchorConstant: CGFloat = -100
private let defaultTextViewLeadingAnchorConstant: CGFloat = 50
private let defaultTextViewTrailingAnchorConstant: CGFloat = -50
