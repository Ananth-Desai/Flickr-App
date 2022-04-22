//
//  NewSearchScreenVC.swift
//  Flickr
//
//  Created by Ananth Desai on 10/04/22.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

protocol SearchScreenViewControllerDelegate: AnyObject {
    func didSelectImage(url: URL, title: String, imageTitle: String, imageId: String)
}

class SearchScreenVC: UIViewController {
    // MARK: Variables

    private weak var collectionView: UICollectionView!
    private weak var textView: UILabel!
    private weak var progressView: UIActivityIndicatorView!
    private var photos: [URL] = []
    private var photoSections: [PhotosSectionDS] = [PhotosSectionDS(photos: [])]
    private var dataSource: RxCollectionViewSectionedAnimatedDataSource<PhotosSectionDS>?
    private var nextVCTitle: String?
    private var imagesLoaded: Bool = false
    private var clickedCancel: Bool = false
    private let disposeBag = DisposeBag()
    private let constants = GlobalConstants()
    private var imageTitles: [String] = []
    private var imageIDs: [String] = []
    private weak var task: URLSessionDataTask?
    weak var searchResultsDelegate: SearchScreenViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewBackgroundColor
        navigationController?.navigationBar.tintColor = navigationBarTintColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let textviewConstraints = setupDefaultTextView()
        let progressViewConstraints = setupProgressView()
        let collectionViewConstraints = setupCollectionView()
        NSLayoutConstraint.activate(textviewConstraints + progressViewConstraints + collectionViewConstraints)
        handleCancelButtonSubsciption()
        handleSearchStringSubscription()
        setupRxDataSource()
    }

    private func setupRxDataSource() {
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<PhotosSectionDS>(
            configureCell: { _, collectionView, indexPath, photosObject in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? CustomCollectionViewCell
                if let cell = cell {
                    cell.setupCollectionViewCell(photos: photosObject.photoUrl, indexPath: indexPath.row)
                    return cell
                }
                return UICollectionViewCell()
            }
        )
        self.dataSource = dataSource
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

    private func handleSearchStringSubscription() {
        navigationItem.searchController?.searchBar.rx.text
            .asObservable()
            .debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext: { string in
                if let string = string {
                    if string.count > 2 {
                        self.collectionView.isHidden = true
                        self.progressView.startAnimating()
                        self.fetchPhotos(searchString: string)
                        self.nextVCTitle = string
                        self.textView.isHidden = true
                        self.clickedCancel = false
                    } else {
                        if !self.imagesLoaded {
                            self.progressView.stopAnimating()
                            self.textView.isHidden = false
                            self.collectionView.isHidden = true
                        } else {
                            if self.clickedCancel {
                                self.progressView.stopAnimating()
                                self.textView.isHidden = true
                                self.collectionView.isHidden = false
                            } else {
                                self.progressView.stopAnimating()
                                self.textView.isHidden = false
                                self.collectionView.isHidden = true
                            }
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    private func handleCancelButtonSubsciption() {
        navigationItem.searchController?.searchBar.rx.cancelButtonClicked
            .asObservable()
            .subscribe(onNext: { _ in
                self.clickedCancel = true
                self.task?.cancel()
                self.progressView.stopAnimating()
            })
            .disposed(by: disposeBag)
    }

    func fetchPhotos(searchString: String) {
        if task?.state == .running {
            task?.cancel()
        }
        var photosArray: [URL] = []
        imageTitles = []
        imageIDs = []
        imagesLoaded = false
        photoSections[0].emptyPhotosArray()
        ApiCallHandler.shared.fetchRequest(searchString: searchString)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                switch result {
                case let .success(response):
                    photosArray = self.constructIndividualUrls(response)
                    self.photos = photosArray
                    if let dataSource = self.dataSource {
                        Observable.just(self.photoSections)
                            .bind(to: self.collectionView.rx.items(dataSource: dataSource))
                            .disposed(by: self.disposeBag)
                    }
                    self.progressView.stopAnimating()
                    self.collectionView.isHidden = false
                    self.imagesLoaded = true
                case .failure: break
                }
            }
            .disposed(by: disposeBag)
    }

    private func returnSearchUrl(searchString: String) -> URL? {
        constants.returnSearchUrl(searchString: searchString)
    }

    private func returnImageURl(image: SinglePhoto) -> URL? {
        constants.returnImageUrl(image: image)
    }

    private func constructIndividualUrls(_ result: Photos) -> [URL] {
        var individualPhotoUrls: [URL] = []
        var count = 0
        for photo in result.photos.photo {
            guard let imageUrl = returnImageURl(image: photo) else {
                return []
            }
            individualPhotoUrls.append(imageUrl)
            photoSections[0].pushToPhotosArray(image: PhotoUrl(photoUrl: imageUrl, id: count))
            count += 1
            imageTitles.append(photo.title)
            imageIDs.append(photo.id)
        }
        return individualPhotoUrls
    }
}

// MARK: Extensions

extension SearchScreenVC: UICollectionViewDelegate {
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
