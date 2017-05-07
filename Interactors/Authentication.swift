//
//  Authentication.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 15/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Entities
import Networking
import ReactiveKit

private let clientID = "31625d251b64ec0f01b19577c150f8bcb8c5f6a3"
private let secret = "e629e37430a3a37905f642972caf3e6dce28d819"
private let redirectURI = "reactive-gitter://token"

public class Authentication {

  public enum AuthorizationResponse {
    case authorized(String)
    case unauthorized(String)
  }

  public let token: SafeSignal<Token>

  public init(client: SafeClient, authorizationCode: SafeSignal<AuthorizationResponse>) {

    token = authorizationCode
      .flatMapLatest { code -> SafeSignal<Token> in
        if case .authorized(let code) = code {
          return Token
            .get(clientID: clientID, secret: secret, code: code, redirectURI: redirectURI)
            .response(using: client)
            .debug()
        } else {
          return .never()
        }
    }
  }

  public var authorizationURL: URL {
    return AuthenticationAPIClient.authorizationURL(clientID: clientID, redirectURI: redirectURI)
  }
}
