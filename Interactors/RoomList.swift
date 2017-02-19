//
//  RoomList.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 15/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Entities
import Networking
import ReactiveAPI
import ReactiveKit

public class RoomList {

  public let client: SafeClient
  public let rooms: SafeSignal<[Room]>
  public let leaveRoom: SafeObserver<Room>

  public init(client: SafeClient) {

    let leaveRoom = SafePublishSubject<Room>()

    let leftRoom = leaveRoom
      .flatMapLatest { room -> SafeSignal<Void> in
        return room.leave().response(using: client)
      }

    let user = User.me()
      .response(using: client)
      .shareReplay(limit: 1)

    let rooms = leftRoom.start(with: ())
      .flatMapLatest { () -> SafeSignal<[Room]> in
        return user.flatMapLatest { user -> SafeSignal<[Room]> in
          user.getRooms().response(using: client)
        }
      }
      .shareReplay(limit: 1)

    self.client = client
    self.rooms = rooms
    self.leaveRoom = leaveRoom.on
  }
}
