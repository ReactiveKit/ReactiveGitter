//
//  User.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 14/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Entities
import Client

extension User {

  public static func me() -> Request<User, APIError> {
    return Request(
        path: "user/me",
        method: .get,
        resource: User.init,
        error: APIError.init,
        needsAuthorization: true
    )
  }

  public static func get(limit: Int? = nil, skip: Int? = nil) -> Request<[User], APIError> {
    return Request(
        path: "user",
        method: .get,
        parameters: JSONParameters(nonNil: ["limit": limit, "skip": skip]),
        resource: [User].init,
        error: APIError.init,
        needsAuthorization: true
    )
  }

  public static func query(_ q: String, limit: Int? = nil, skip: Int? = nil) -> Request<[User], APIError> {
    return Request(
        path: "user",
        method: .get,
        parameters: JSONParameters(nonNil: ["q": q, "limit": limit, "skip": skip]),
        resource: [User].init,
        error: APIError.init,
        needsAuthorization: true
    )
  }

  public func getRooms() -> Request<[Room], APIError> {
    return Request(
        path: "user/\(id)/rooms",
        method: .get,
        resource: [Room].init,
        error: APIError.init,
        needsAuthorization: true
    )
  }

  public func getChannels() -> Request<[Room], APIError> {
    return Request(
        path: "user/\(id)/channels",
        method: .get,
        resource: [Room].init,
        error: APIError.init,
        needsAuthorization: true
    )
  }
}
