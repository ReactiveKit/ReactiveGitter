//
//  User.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 14/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Foundation
import Freddy

public struct User {
  public let id: String              // Gitter User ID.
  public let username: String        // Gitter/GitHub username.
  public let displayName: String     // Gitter/GitHub user real name.
  public let url: String             // Path to the user on Gitter.
  public let avatarUrlSmall: String  // User avatar URI (small).
  public let avatarUrlMedium: String // User avatar URI (medium).
}

extension User: JSONDecodable {

  public init(json: JSON) throws {
    id = try json.decode(at: "id")
    username = try json.decode(at: "username")
    displayName = try json.decode(at: "displayName")
    url = try json.decode(at: "url")
    avatarUrlSmall = try json.decode(at: "avatarUrlSmall")
    avatarUrlMedium = try json.decode(at: "avatarUrlMedium")
  }
}
