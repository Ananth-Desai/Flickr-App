//
//  ErrorCoordinator.swift
//  Flickr
//
//  Created by Ananth Desai on 09/03/22.
//

import Foundation
import UIKit

class ErrorCoordinator {
    // MARK: Variables

    private enum SearchFieldErrors: Error {
        case emptySearch
        case stringLengthInsufficient
    }

    private enum SearchApiCallErros: Error {
        case networkError
        case emptySearchResults
        case decodingError
    }

    private func checkSearchStringForErrors(_ string: String) throws {
        guard string.isEmpty == false else {
            throw SearchFieldErrors.emptySearch
        }
        guard string.count > 2 else {
            throw SearchFieldErrors.stringLengthInsufficient
        }
    }

    private func setupErrorAlertController(alertTitle: String, alertMessage: String) -> UIAlertController {
        let alertVC = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: backButtonText, style: .cancel, handler: nil))
        return alertVC
    }

    func handleSearchStringErrors(searchString string: String?) -> UIAlertController? {
        guard let string = string else {
            return nil
        }
        do {
            try checkSearchStringForErrors(string)
            return nil
        } catch SearchFieldErrors.emptySearch {
            let errorVC = setupErrorAlertController(alertTitle: searchErrorTitle, alertMessage: emptySearchErrorText)
            return errorVC
        } catch SearchFieldErrors.stringLengthInsufficient {
            let errorVC = setupErrorAlertController(alertTitle: searchErrorTitle, alertMessage: stringLengthInsufficientAlert)
            return errorVC
        } catch {}
        return nil
    }
}

// MARK: Constants

private let searchErrorTitle = R.string.localizable.searchErrorTitle()
private let emptySearchErrorText = R.string.localizable.emptySearchString()
private let stringLengthInsufficientAlert = R.string.localizable.stringLengthInsufficientAlertTitle()
private let backButtonText = R.string.localizable.back()
