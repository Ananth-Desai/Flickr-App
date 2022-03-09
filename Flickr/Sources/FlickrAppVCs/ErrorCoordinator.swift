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

    func checkSearchStringForErrors(_ string: String) throws {
        guard string.isEmpty == false else {
            throw SearchFieldErrors.emptySearch
        }
        guard string.count > 2 else {
            throw SearchFieldErrors.stringLengthInsufficient
        }
    }

    func handleSearchStringErrors(searchString string: String?) -> UIAlertController? {
        guard let string = string else {
            return nil
        }
        do {
            try checkSearchStringForErrors(string)
            return nil
        } catch SearchFieldErrors.emptySearch {
            let errorVC = setupErrorAlertController(alertTitle: errorAlertTitle, alertMessage: emptySearchAlertTitle)
            return errorVC
        } catch SearchFieldErrors.stringLengthInsufficient {
            let errorVC = setupErrorAlertController(alertTitle: errorAlertTitle, alertMessage: stringLengthInsufficientAlertMessage)
            return errorVC
        } catch {}
        return nil
    }

    func setupErrorAlertController(alertTitle: String, alertMessage: String) -> UIAlertController {
        let alertVC = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Back", style: .cancel, handler: nil))
        return alertVC
    }
}

// MARK: Constants

private let errorAlertTitle: String = "Error"
private let emptySearchAlertTitle: String = "Search String cannot be empty"
private let stringLengthInsufficientAlertMessage: String = "Search string length must be greater than 2"
