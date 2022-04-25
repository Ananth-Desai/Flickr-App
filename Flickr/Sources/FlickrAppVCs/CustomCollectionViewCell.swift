//
//  CustomCollectionViewCell.swift
//  Flickr
//
//  Created by Ananth Desai on 31/03/22.
//

import Foundation
import Nuke
import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    var indexPath: Int?
    var photos: URL?

    override func prepareForReuse() {
        super.prepareForReuse()
        for views in subviews {
            views.removeFromSuperview()
        }
    }

    func setupCollectionViewCell(photos: URL, indexPath: Int) {
        self.photos = photos
        self.indexPath = indexPath
        let imageView = returnImageView()
        Nuke.loadImage(with: photos, into: imageView)
        addSubview(imageView)
        let imageViewConstraints = returnImageViewConstraints(imageView: imageView)
        NSLayoutConstraint.activate(imageViewConstraints)
    }

    private func returnImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.configureView { iV in
            iV.tag = 10
            iV.contentMode = .scaleAspectFill
            iV.clipsToBounds = true
        }
        return imageView
    }

    private func returnImageViewConstraints(imageView: UIImageView) -> [NSLayoutConstraint] {
        [
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
    }

    private func returnSpinner() -> [NSLayoutConstraint] {
        let spinner = UIActivityIndicatorView()
        spinner.configureView { sp in
            sp.startAnimating()
        }
        addSubview(spinner)
        return [
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
    }
}
