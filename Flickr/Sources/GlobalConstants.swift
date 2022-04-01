//
//  GlobalConstants.swift
//  Flickr
//
//  Created by Ananth Desai on 29/03/22.
//

import Foundation
struct GlobalConstants {
    private let baseSearchUrl = "https://www.flickr.com/services/rest"
    private let imageSearchUrl = "https://live.staticflickr.com"
    private let apiKey = "397717930841a3bd19df470ac48fc84f"
    private let apiMethod = "flickr.photos.search"
    private let format = "json"
    private let noJsonCallback = 1

    func returnSearchUrl(searchString: String) -> URL? {
        URL(string: "\(baseSearchUrl)/?method=\(apiMethod)&api_key=\(apiKey)&format=\(format)&nojsoncallback=\(noJsonCallback)&text=\(searchString)")
    }

    func returnImageUrl(image: SinglePhoto) -> URL? {
        URL(string: "\(imageSearchUrl)/\(image.server)/\(image.id)_\(image.secret).jpg")
    }
}
