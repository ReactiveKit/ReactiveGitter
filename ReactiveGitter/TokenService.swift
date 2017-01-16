//
//  TokenService.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 15/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Foundation
import Entities
import ReactiveKit
import ReactiveAPI
import Networking
import Services

open class TokenService: NSObject {

  private var _token = Property<Token?>(nil)

  public var token: SafeSignal<Token?> {
    return _token.toSignal()
  }

  public override init() {
    super.init()
    if let accessToken = UserDefaults.standard.object(forKey: "token") as? String {
      _token.value = Token(accessToken: accessToken, tokenType: "Bearer")
    }
  }

  public func updateToken(_ token: Token?) {
    // TODO: Use Keychain instead
    UserDefaults.standard.set(token?.accessToken, forKey: "token")
    UserDefaults.standard.synchronize()
    _token.value = token
  }
}

extension TokenService {

  open class AuthorizationCodeParser {

    fileprivate let _parsedCode = SafePublishSubject<Authentication.AuthorizationResponse>()
    open var parsedCode: SafeSignal<Authentication.AuthorizationResponse> {
      return _parsedCode.toSignal()
    }

    public init() {}

    open func parseAndHandleToken(_ url: URL) -> Bool {
      let components = URLComponents(url: url as URL, resolvingAgainstBaseURL: false)!

      guard let host = components.host , host == "token" else {
        return false
      }

      if let keyValue = components.queryItems?.filter({ $0.name == "code" }).first, let code = keyValue.value  {
        _parsedCode.next(.authorized(code))
        return true
      } else {
        _parsedCode.next(.unauthorized("Token request code not received."))
        return false
      }
    }
  }
}
