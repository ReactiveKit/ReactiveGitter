//
//  Token.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 14/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Entities
import ReactiveAPI

extension Token {

  public static func get(clientID: String, secret: String, code: String, redirectURI: String) -> Request<Token, APIError> {
    let params: [String: Any] = [
      "client_id": clientID as Any,
      "client_secret": secret as Any,
      "code": code as Any,
      "redirect_uri": redirectURI as Any,
      "grant_type": "authorization_code" as Any
    ]
    return Request(path: "token", method: .post, parameters: JSONParameters(params), resource: Token.init, error: APIError.init)
  }
}
