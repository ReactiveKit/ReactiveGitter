//
//  Client.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 14/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Entities
import ReactiveAPI

private let GitterAPIBaseURL = "https://api.gitter.im/v1"
private let GitterAPIBaseStreamURL = "https://stream.gitter.im/v1"
private let GitterAuthorizationBaseURL = "https://gitter.im/login/oauth/authorize"
private let GitterAuthenticationAPIBaseURL = "https://gitter.im/login/oauth"

public class APIClient: Client {

  public init(token: Token) {
    super.init(baseURL: GitterAPIBaseURL)
    defaultHeaders = ["Authorization": "Bearer \(token.accessToken)"]
  }
}

public class AuthenticationAPIClient: Client {
  
  public init() {
    super.init(baseURL: GitterAuthenticationAPIBaseURL)
  }

  public static func authorizationURL(clientID: String, redirectURI: String) -> URL {
    return URL(string: "\(GitterAuthorizationBaseURL)?client_id=\(clientID)&response_type=code&redirect_uri=\(redirectURI)")!
  }
}
