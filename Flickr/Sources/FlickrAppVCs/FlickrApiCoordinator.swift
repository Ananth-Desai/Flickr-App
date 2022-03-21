//
//  URLCoordinator.swift
//  Flickr
//
//  Created by Ananth Desai on 17/03/22.
//

import Foundation

class ApiCoordinator {
    struct Photos: Codable {
        var photos: PhotoArray
    }

    struct PhotoArray: Codable {
        var photo: [SinglePhoto]
    }

    struct SinglePhoto: Codable {
        var id: String
        var owner: String
        var secret: String
        var server: String
        var title: String
    }

    private func returnSearchUrl(searchString: String) -> URL? {
        URL(string: "\(baseSearchUrl)/?method=\(method)&api_key=\(apiKey)&format=\(format)&nojsoncallback=\(noJsonCallback)&text=\(searchString)")
    }

    private func returnImageURl(image: SinglePhoto) -> URL? {
        URL(string: "\(imageSearchUrl)/\(image.server)/\(image.id)_\(image.secret).jpg")
    }

    func fetchPhotos(searchString: String) -> Bool {
        guard let url = returnSearchUrl(searchString: searchString) else {
            return false
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
            guard self.constructIndividualUrls(result) == true else {
                return
            }
        })
        task.resume()
        return true
    }

    private func constructIndividualUrls(_ result: Photos) -> Bool {
        var individualPhotosUrls: [URL] = []
        for photo in result.photos.photo {
            guard let imageUrl = returnImageURl(image: photo) else {
                return false
            }
            individualPhotosUrls.append(imageUrl)
        }
        return true
    }
}

// MARK: Constants

private let baseSearchUrl = "https://www.flickr.com/services/rest"
private let imageSearchUrl = "https://live.staticflickr.com"
private let apiKey = "397717930841a3bd19df470ac48fc84f"
private let method = "flickr.photos.search"
private let format = "json"
private let noJsonCallback = 1
