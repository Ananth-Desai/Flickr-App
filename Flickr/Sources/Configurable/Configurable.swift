//
// Copyright © 2022 Surya Software Systems Pvt. Ltd.
//

import UIKit

protocol Configurable {}

extension Configurable where Self: AnyObject {
    /// Configures an object according to its various properties. It returns the object after modifying the properties
    ///
    /// For eg:
    ///
    ///     let view = UIView()
    ///     view.configure { v in
    ///         v.alpha = 1.0
    ///     }
    ///
    func configure(_ f: (Self) -> Void) {
        f(self)
    }
}

extension Configurable where Self: UIView {
    /// Configures an object according to its various properties. It also sets up the translatesAutoresizingMaskIntoConstraints property to false. It returns the object after modifying the properties
    ///
    /// For eg:
    ///
    ///     let view = UIView()
    ///     view.configureView { v in
    ///         v.alpha = 1.0
    ///     }
    ///
    func configureView(_ f: (Self) -> Void = { _ in }) {
        translatesAutoresizingMaskIntoConstraints = false
        return f(self)
    }
}

extension UIView: Configurable {}
