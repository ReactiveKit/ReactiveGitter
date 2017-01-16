//
//  Authentication.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 15/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Entities
import Services
import Views
import Bond
import ReactiveKit

extension Authentication {

  public typealias Scene = (
    viewController: UIViewController,
    tokenAcquired: SafeSignal<Token>
  )

  public func createScene() -> Scene {
    let vc = ViewController.Authentication()

    vc.loginButton.reactive.tap
      .bind(to: UIApplication.shared) { application, _ in
        application.open(self.authorizationURL, options: [:])
      }

    return (vc, token)
  }
}
