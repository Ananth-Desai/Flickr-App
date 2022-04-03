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
        guard let url = FileManager.default.urls(for: searchDirectory, in: .userDomainMask).first?.appendingPathComponent("favorites.json", isDirectory: false) else {
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
        guard let url = FileManager.default.urls(for: searchDirectory, in: .userDomainMask).first?.appendingPathComponent("favorites.json", isDirectory: false) else {
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
                print("Decoding Error")
            }
        } else {
            print("No Contents")
        }
        return nil
    }

    static func removeData() {
        let searchDirectory = FileManager.SearchPathDirectory.documentDirectory
        guard let url = FileManager.default.urls(for: searchDirectory, in: .userDomainMask).first?.appendingPathComponent("favorites.json", isDirectory: false) else {
            return
        }
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
                print("Deleted")
            } catch {
                print("Deleting Error")
            }
        } else {
            print("File Doesn't exist")
        }
    }
}
