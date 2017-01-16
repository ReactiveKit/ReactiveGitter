//
//  Room.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 14/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Freddy
import Foundation

public struct Room {
  public let id: String
  public let name: String            // Room name.
  public let uri: String?            // Room URI on Gitter.
  public let topic: String           // Room topic. (default: GitHub repo description)
  public let oneToOne: Bool          // Indicates if the room is a one-to-one chat.
  public let userCount: Int          // Count of users in the room.
  public let unreadItems: Int        // Number of unread messages for the current user.
  public let mentions: Int           // Number of unread mentions for the current user.
  public let lastAccessTime: String? // Last time the current user accessed the room in ISO format.
  public let favourite: Bool         // Indicates if the room is on of your favourites.
  public let lurk: Bool              // Indicates if the current user has disabled notifications.
  public let url: String             // Path to the room on gitter.
  public let githubType: String      // Type of the room.
  public let tags: [String]          // Tags that define the room.
}

extension Room: JSONDecodable {

  public init(json: JSON) throws {
    id = try json.decode(at: "id")
    name = try json.decode(at: "name")
    uri = try json.decode(at: "uri", alongPath: [.missingKeyBecomesNil, .nullBecomesNil])
    topic = try json.decode(at: "topic")
    oneToOne = try json.decode(at: "oneToOne")
    userCount = try json.decode(at: "userCount")
    unreadItems = try json.decode(at: "unreadItems")
    mentions = try json.decode(at: "mentions")
    lastAccessTime = try json.decode(at: "lastAccessTime", alongPath: [.missingKeyBecomesNil, .nullBecomesNil])
    favourite = (try? json.decode(at: "favourite")) ?? false
    lurk = try json.decode(at: "lurk")
    url = try json.decode(at: "url")
    githubType = try json.decode(at: "githubType")
    tags = try json.decodedArray(at: "tags")
  }
}
