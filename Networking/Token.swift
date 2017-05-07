//
//  Token.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 14/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Entities
import Client

extension Token {

  public static func get(clientID: String, secret: String, code: String, redirectURI: String) -> Request<Token, APIError> {
    let params: [String: String] = [
      "client_id": clientID,
      "client_secret": secret,
      "code": code,
      "redirect_uri": redirectURI,
      "grant_type": "authorization_code"
    ]
    return Request(
        path: "token",
        method: .post,
        parameters: JSONParameters(params),
        resource: Token.init,
        error: APIError.init,
        needsAuthorization: true
    )
  }
}
