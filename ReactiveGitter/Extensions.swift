//
//  Extensions.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 15/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import UIKit
import Networking
import ReactiveKit
import Bond

extension ReactiveExtensions where Base: UIViewController {

  public var userErrors: Bond<UserFriendlyError> {
    return bond { vc, error in
      let alert = UIAlertController(title: "Error occurred", message: error.message, preferredStyle: .actionSheet)
      if let retry = error.retry {
        let action = UIAlertAction(title: "Retry", style: .default) { _ in
          retry.next()
        }
        alert.addAction(action)
      }
      let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)
      alert.addAction(dismissAction)
      vc.present(alert, animated: true)
    }
  }
}
