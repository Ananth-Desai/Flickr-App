//
//  FileManagerCoordinator.swift
//  Flickr
//
//  Created by Ananth Desai on 01/04/22.
//

import Foundation

class FileManagerCoordinator {
    static func storeData(_ favoritesData: FavoriteImagesArray?) {
        let searchDirectory = FileManager.SearchPathDirectory.documentDirectory
        guard let url = FileManager.default.urls(for: searchDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName, isDirectory: false) else {
            return
        }
        do {
            let data = try JSONEncoder().encode(favoritesData)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            return
        }
    }

    static func retrieveData() -> [FavoriteImageData]? {
        let searchDirectory = FileManager.SearchPathDirectory.documentDirectory
        guard let url = FileManager.default.urls(for: searchDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName, isDirectory: false) else {
            return nil
        }

        if !FileManager.default.fileExists(atPath: url.path) {
            return nil
        }
        if let data = FileManager.default.contents(atPath: url.path) {
            var decodedData: FavoriteImagesArray?
            do {
                decodedData = try JSONDecoder().decode(FavoriteImagesArray.self, from: data)
                return decodedData?.array
            } catch {
                return nil
            }
        }
        return nil
    }
}

// MARK: Constants

private let fileName = "favorites.json"
