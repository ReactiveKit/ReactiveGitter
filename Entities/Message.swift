//
//  Message.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 14/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Freddy
import Foundation

public struct Message {
  public let id: String           // ID of the message.
  public let text: String      // Original message in plain-text/markdown.
  public let html: String      // HTML formatted message.
  public let sent: Date      // ISO formatted date of the message.
  public let editedAt: Date?  // ISO formatted date of the message if edited.
  public let fromUser: User    // (User)[user-resource] that sent the message.
  public let unread: Bool      // Boolean that indicates if the current user has read the message.
  public let readBy: Int       // Number of users that have read the message.
  public let urls: [Url]    // List of URLs present in the message.

  public struct Url {
    let url: String
  }
}

extension Message: JSONDecodable {

  public init(json: JSON) throws {
    id = try json.decode(at: "id")
    text = try json.decode(at: "text")
    html = try json.decode(at: "html")
    sent = try json.getString(at: "sent").to8601Date()
    editedAt = try json.getString(at: "editedAt", alongPath: [.missingKeyBecomesNil, .nullBecomesNil])?.to8601Date()
    fromUser = try json.decode(at: "fromUser")
    unread = try json.decode(at: "unread")
    readBy = try json.decode(at: "readBy")
    urls = try json.decodedArray(at: "urls")
  }
}

extension Message.Url: JSONDecodable {

  public init(json: JSON) throws {
    url = try json.decode(at: "url")
  }
}
