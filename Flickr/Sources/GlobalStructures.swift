//
//  GlobalStructures.swift
//  Flickr
//
//  Created by Ananth Desai on 30/03/22.
//

import Differentiator
import Foundation
import GRDB

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

struct FavoriteImageData: Codable {
    var imageId: String
    var imageTitle: String
    var imageData: Data

    init(imageId: String, imageData: Data, imageTitle: String) {
        self.imageData = imageData
        self.imageTitle = imageTitle
        self.imageId = imageId
    }
}

struct FavoriteImagesArray: Codable {
    var array: [FavoriteImageData]

    init(array: [FavoriteImageData]) {
        self.array = array
    }
}

struct PhotoUrl {
    var photoUrl: URL
    var id: Int
}

extension PhotoUrl: IdentifiableType {
    var identity: Int {
        id
    }

    typealias Identity = Int
}

extension PhotoUrl: Equatable {}

struct PhotosSectionDS {
    var photos: [Item]
    var uniqueIdentity: Int = 0

    mutating func pushToPhotosArray(image: PhotoUrl) {
        photos.append(image)
    }

    mutating func emptyPhotosArray() {
        photos = []
    }
}

extension PhotosSectionDS: AnimatableSectionModelType, Equatable, IdentifiableType {
    var items: [PhotoUrl] {
        photos
    }

    init(original: PhotosSectionDS, items: [PhotoUrl]) {
        self = original
        photos = items
    }

    var identity: Int {
        uniqueIdentity
    }

    typealias Identity = Int

    typealias Item = PhotoUrl
}

struct FavoritesRecords: Codable, FetchableRecord, PersistableRecord, TableRecord, Identifiable {
    var id: String
    var name: String
    var image: Data

    init(id: String, name: String, image: Data) {
        self.id = id
        self.name = name
        self.image = image
    }
}
