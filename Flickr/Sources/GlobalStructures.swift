//
//  GlobalStructures.swift
//  Flickr
//
//  Created by Ananth Desai on 30/03/22.
//

import Foundation

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
