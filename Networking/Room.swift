//
//  Room.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 14/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Entities
import ReactiveAPI

extension Room {

  public static func get() -> Request<[Room], APIError> {
    return Request(path: "rooms", method: .get, resource: [Room].init, error: APIError.init)
  }

  public static func query(_ q: String) -> Request<[Room], APIError> {
    let params = JSONParameters(["q": q])
    return Request(path: "rooms", method: .get, parameters: params, resource: [Room].init, error: APIError.init)
  }

  public static func join(_ uri: String) -> Request<Room, APIError> {
    let params = JSONParameters(["uri": uri])
    return Request(path: "rooms", method: .post, parameters: params, resource: Room.init, error: APIError.init)
  }

  public func getChannels() -> Request<[Room], APIError> {
    return Request(path: "rooms/\(id)/channels", method: .get, resource: [Room].init, error: APIError.init)
  }

  public func sendMessage(_ text: String) -> Request<Message, APIError> {
    let params = JSONParameters(["text": text])
    return Request(path: "rooms/\(id)/chatMessages", method: .post, parameters: params, resource: Message.init, error: APIError.init)
  }

  public func getMessages(limit: Int? = nil, skip: Int? = nil) -> Request<[Message], APIError> {
    let params = QueryParameters(["limit": limit.flatMap { "\($0)"}, "skip": skip.flatMap { "\($0)" }] as [String: String?])
    return Request(path: "rooms/\(id)/chatMessages", method: .get, parameters: params, resource: [Message].init, error: APIError.init)
  }

  public func getUsers() -> Request<[User], APIError> {
    return Request(path: "rooms/\(id)/users", method: .get, resource: [User].init, error: APIError.init)
  }

  public func update(topic: String? = nil, noindex: Bool? = nil, tags: String? = nil) -> Request<Room, APIError> {
    let params = ["topic": topic, "noindex": noindex, "tags": tags] as [String: Any?]
    return Request(path: "rooms", method: .put, parameters: JSONParameters(params), resource: Room.init, error: APIError.init)
  }

  public func leave() -> Request<Void, APIError> {
    return Request(path: "rooms", method: .delete, resource: { _ in }, error: APIError.init)
  }
}
