//
//  Token.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 14/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Foundation
import Freddy

public struct Token {
  public let accessToken: String   // The token that can be used to access the Gitter API.
  public let tokenType: String     // The type of token received. At this time, this field will always have the value Bearer.
  public let expiresIn: String?    // The remaining lifetime on the access token.

  public init(accessToken: String, tokenType: String, expiresIn: String? = nil) {
    self.accessToken = accessToken
    self.tokenType = tokenType
    self.expiresIn = expiresIn
  }
}

extension Token: JSONDecodable {

  public init(json: JSON) throws {
    accessToken = try json.decode(at: "access_token")
    expiresIn = try json.decode(at: "expires_in", alongPath: [.missingKeyBecomesNil, .nullBecomesNil])
    tokenType = try json.decode(at: "token_type")
  }
}
