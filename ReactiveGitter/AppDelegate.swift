//
//  AppDelegate.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 14/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import UIKit
import Bond
import Scenes
import Interactors
import Networking
import ReactiveAPI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var authorizationCodeParser: TokenService.AuthorizationCodeParser!
  var tokenService: TokenService!

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    applyTheme()

    let window = UIWindow(frame: UIScreen.main.bounds)
    let authorizationCodeParser = TokenService.AuthorizationCodeParser()
    let tokenService = TokenService()

    tokenService.token.bind(to: window) { window, token in
      if let token = token {
        let client = SafeClient(wrapping: APIClient(token: token))
        let scene = RoomList(client: client).createScene()
        let navigationController = UINavigationController(rootViewController: scene.viewController)
        client.errors.bind(to: navigationController.reactive.userErrors)
        window.rootViewController = navigationController
        scene.logOut.bind(to: tokenService) { tokenService, _ in
          tokenService.updateToken(nil)
        }
      } else {
        let client = SafeClient(wrapping: AuthenticationAPIClient())
        let authorizationCode = authorizationCodeParser.parsedCode
        let scene = Authentication(client: client, authorizationCode: authorizationCode).createScene()
        client.errors.bind(to: scene.viewController.reactive.userErrors)
        window.rootViewController = scene.viewController
        scene.tokenAcquired.bind(to: tokenService) { tokenService, token in
          tokenService.updateToken(token)
        }
      }
    }

    self.window = window
    self.authorizationCodeParser = authorizationCodeParser
    self.tokenService = tokenService

    window.makeKeyAndVisible()
    return true
  }

  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    return authorizationCodeParser.parseAndHandleToken(url)
  }

  func applyTheme() {
    UIView.appearance().tintColor = UIColor(red: 232/255, green: 33/255, blue: 102/255, alpha: 1)
  }
}
