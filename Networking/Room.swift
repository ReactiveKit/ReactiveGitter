//
//  Room.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 14/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Entities
import Client

extension Room {

  public static func get() -> Request<[Room], APIError> {
    return Request(
        path: "rooms",
        method: .get,
        resource: [Room].init,
        error: APIError.init,
        needsAuthorization: true
    )
  }

  public static func query(_ q: String) -> Request<[Room], APIError> {
    return Request(
        path: "rooms",
        method: .get,
        parameters: JSONParameters(["q": q]),
        resource: [Room].init,
        error: APIError.init,
        needsAuthorization: true
    )
  }

  public static func join(_ uri: String) -> Request<Room, APIError> {
    return Request(
        path: "rooms",
        method: .post,
        parameters: JSONParameters(["uri": uri]),
        resource: Room.init,
        error: APIError.init,
        needsAuthorization: true
    )
  }

  public func getChannels() -> Request<[Room], APIError> {
    return Request(
        path: "rooms/\(id)/channels",
        method: .get,
        resource: [Room].init,
        error: APIError.init,
        needsAuthorization: true
    )
  }

  public func sendMessage(_ text: String) -> Request<Message, APIError> {
    return Request(
        path: "rooms/\(id)/chatMessages",
        method: .post,
        parameters: JSONParameters(["text": text]),
        resource: Message.init,
        error: APIError.init,
        needsAuthorization: true
    )
  }

  public func getMessages(limit: Int? = nil, skip: Int? = nil) -> Request<[Message], APIError> {
    return Request(
        path: "rooms/\(id)/chatMessages",
        method: .get,
        parameters: QueryParameters(nonNil: ["limit": limit.flatMap { "\($0)"}, "skip": skip.flatMap { "\($0)" }]),
        resource: [Message].init,
        error: APIError.init,
        needsAuthorization: true
    )
  }

  public func getUsers() -> Request<[User], APIError> {
    return Request(
        path: "rooms/\(id)/users",
        method: .get,
        resource: [User].init,
        error: APIError.init,
        needsAuthorization: true
    )
  }

  public func update(topic: String? = nil, noindex: Bool? = nil, tags: String? = nil) -> Request<Room, APIError> {
    return Request(
        path: "rooms",
        method: .put,
        parameters: JSONParameters(nonNil: ["topic": topic, "noindex": noindex, "tags": tags]),
        resource: Room.init,
        error: APIError.init,
        needsAuthorization: true
    )
  }

  public func leave() -> Request<Void, APIError> {
    return Request(
        path: "rooms",
        method: .delete,
        resource: { _ in },
        error: APIError.init,
        needsAuthorization: true
    )
  }
}
