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
        let alertTitle = NSLocalizedString("searchErrorTitle", comment: "")
        guard let string = string else {
            return nil
        }
        do {
            try checkSearchStringForErrors(string)
            return nil
        } catch SearchFieldErrors.emptySearch {
            let emptySearchError = NSLocalizedString("emptySearchString", comment: "")
            let errorVC = setupErrorAlertController(alertTitle: alertTitle, alertMessage: emptySearchError)
            return errorVC
        } catch SearchFieldErrors.stringLengthInsufficient {
            let stringLengthInsufficientError = NSLocalizedString("stringLengthInsufficientAlertTitle", comment: "")
            let errorVC = setupErrorAlertController(alertTitle: alertTitle, alertMessage: stringLengthInsufficientError)
            return errorVC
        } catch {}
        return nil
    }

    func setupErrorAlertController(alertTitle: String, alertMessage: String) -> UIAlertController {
        let alertVC = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: NSLocalizedString("back", comment: ""), style: .cancel, handler: nil))
        return alertVC
    }
}
