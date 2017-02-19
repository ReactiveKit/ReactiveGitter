//
//  RoomMessages.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 15/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Entities
import Networking
import ReactiveAPI
import ReactiveKit

public class RoomMessages {

  public let messages: SafeSignal<[Message]>
  public let sendMessage: SafeObserver<String>

  public init(client: SafeClient, room: Room) {

    let sendMessage = SafePublishSubject<String>()

    let messageSent = sendMessage
      .flatMapLatest { text -> SafeSignal<Message> in
        return room.sendMessage(text).response(using: client)
      }

    let messages = messageSent.eraseType().start(with: ())
      .flatMapLatest { () -> SafeSignal<[Message]> in
        return room.getMessages(limit: 50).response(using: client)
      }
      .shareReplay(limit: 1)

    self.messages = messages
    self.sendMessage = sendMessage.on
  }
}
