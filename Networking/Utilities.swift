//
//  Utilities.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 14/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Foundation
import Freddy
import Client
import ReactiveKit

extension JSONParameters {

  public init(nonNil jsonOfOptionals: [String: Any?]) {
    self.init(jsonOfOptionals.nonNils)
  }
}

extension QueryParameters {

  public init(nonNil dictionaryOfOptionals: [String: String?]) {
    self.init(dictionaryOfOptionals.nonNils)
  }
}
