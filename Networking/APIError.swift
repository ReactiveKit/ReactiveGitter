//
//  Error.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 14/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Freddy

public struct APIError: Error {
  public let message: String

  public init(message: String) {
    self.message = message
  }
}

extension APIError: JSONDecodable {

  public init(json: JSON) throws {
    message = try json.decode(at: "error")
  }
}

extension APIError {

  public var localizedDescription: String {
    return message
  }
}

extension JSON.Error {

  public var localizedDescription: String {
    return "nja"
  }
}
