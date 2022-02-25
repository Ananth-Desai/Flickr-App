//
// Copyright © 2022 Surya Software Systems Pvt. Ltd.
//

import Foundation

enum InfoPlistDictionary {
    static func getValueFor(_ key: InfoPlistKey) throws -> String {
        if let value = (Bundle.main.infoDictionary?[key.rawValue] as? String)?.replacingOccurrences(of: "\\", with: "") {
            return value
        }
        throw InfoPlistDictionaryError.noValuePresentFor(key: "\(key)")
    }
}

enum InfoPlistDictionaryError: Error {
    case noValuePresentFor(key: String? = nil, error: Error? = nil)
}

enum InfoPlistKey: String {
    case appVersion = "CFBundleShortVersionString"
    case apiClientBaseURL = "APIClientBaseURL"
}
