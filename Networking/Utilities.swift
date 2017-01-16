//
//  Utilities.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 14/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Foundation
import Freddy
import ReactiveAPI
import ReactiveKit

// TODO: Move to Frameworks

extension Dictionary where Value: OptionalProtocol {

  public var nonNils: [Key: Value.Wrapped] {
    var result: [Key: Value.Wrapped] = [:]

    forEach { pair in
      if let value = pair.value._unbox {
        result[pair.key] = value
      }
    }

    return result
  }
}

extension JSONParameters {

  public init(_ jsonOfOptionals: [String: Any?]) {
    self.init(jsonOfOptionals.nonNils)
  }
}

extension QueryParameters {

  public init(_ dictionaryOfOptionals: [String: String?]) {
    self.init(dictionaryOfOptionals.nonNils)
  }
}
