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

struct FavoriteImageStructure {
    var imageTitle: String
    var url: URL

    init(url: URL, title: String) {
        imageTitle = title
        self.url = url
    }
}
