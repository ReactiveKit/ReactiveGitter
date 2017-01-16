//
//  Utilities.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 14/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Foundation
import Freddy

private let dateTimeFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"
  formatter.timeZone = TimeZone(secondsFromGMT: 0)
  formatter.locale = Locale(identifier: "en_US_POSIX")
  return formatter
}()

extension String {
  public  func to8601Date() throws -> Date {
    if let date = dateTimeFormatter.date(from: self) {
      return date
    } else {
      throw JSON.Error.valueNotConvertible(value: .string(self), to: Date.self)
    }
  }
}

extension Date {
  public func to8601String() -> String {
    return dateTimeFormatter.string(from: self)
  }
}

extension String {

  public func toURL() throws -> URL {
    if let url = URL(string: self) {
      return url
    } else {
      throw JSON.Error.valueNotConvertible(value: .string(self), to: URL.self)
    }
  }
}

extension JSONDecodable {

  public init(data: Data) throws {
    let json = try JSON(data: data)
    try self.init(json: json)
  }
}

extension Array where Element: JSONDecodable {

  public init(data: Data) throws {
    let json = try JSON(data: data)
    switch json {
    case .array(let array):
      try self.init(array.map(Element.init))
    default:
      throw JSON.Error.valueNotConvertible(value: json, to: [Element].self)
    }
  }
}
