//
//  GlobalConstants.swift
//  Flickr
//
//  Created by Ananth Desai on 29/03/22.
//

import Foundation

class GlobalConstants {
    static var shared = GlobalConstants()

    let baseSearchUrl = "https://www.flickr.com/"
    let requestPath = "services/rest/"
    let imageSearchUrl = "https://live.staticflickr.com"
    let apiKey = "397717930841a3bd19df470ac48fc84f"
    let apiMethod = "flickr.photos.search"
    let format = "json"
    let noJsonCallback = "1"
    let searchStringParameterName = "text"

    func returnSearchUrl(searchString: String) -> URL? {
        URL(string: "\(baseSearchUrl)\(requestPath)/?method=\(apiMethod)&api_key=\(apiKey)&format=\(format)&nojsoncallback=\(noJsonCallback)&text=\(searchString)")
    }

    func returnImageUrl(image: SinglePhoto) -> URL? {
        URL(string: "\(imageSearchUrl)/\(image.server)/\(image.id)_\(image.secret).jpg")
    }

    init() {}
}
