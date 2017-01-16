//
//  Message.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 14/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Entities
import ReactiveAPI

extension Message {

  public func update(text: String, roomId: String) -> Request<Message, APIError> {
    let params = JSONParameters(["text": text])
    return Request(path: "rooms/\(roomId)/chatMessages/\(id)", method: .put, parameters: params, resource: Message.init, error: APIError.init)
  }
}
