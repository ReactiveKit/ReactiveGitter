//
//  Message.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 14/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Entities
import Client

extension Message {

  public func update(text: String, roomId: String) -> Request<Message, APIError> {
    return Request(
        path: "rooms/\(roomId)/chatMessages/\(id)",
        method: .put,
        parameters: JSONParameters(["text": text]),
        resource: Message.init,
        error: APIError.init,
        needsAuthorization: true
    )
  }
}
