//
//  ReactiveAPITests.swift
//  ReactiveAPITests
//
//  Created by Srdan Rasic on 23/11/2216.
//  Copyright © 2216 Reactive Kit. All rights reserved.
//

import XCTest
@testable import ReactiveAPI

class ReactiveAPITests: XCTestCase {

  let request = URLRequest(url: URL(string: "http//test.io")!)

  func testFormParameters() {
    let parameters = FormParameters(["a": "1", "b": 2])
    let request = parameters.apply(urlRequest: self.request)
    let bodyString = String(data: request.httpBody!, encoding: .utf8)
    XCTAssert(bodyString == "a=1&b=2" || bodyString == "b=2&a=1")
  }

  func testQueryParameters() {
    let parameters = QueryParameters(["a": "1", "b": "2"])
    let request = parameters.apply(urlRequest: self.request)
    let query = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)!.query!
    XCTAssert(query == "a=1&b=2" || query == "b=2&a=1")
  }

  func testJSONParameters() {
    let parameters = JSONParameters(["a": "1", "b": 2])
    let request = parameters.apply(urlRequest: self.request)
    let json = try! JSONSerialization.jsonObject(with: request.httpBody!, options: []) as! [String: Any]

    guard let a = json["a"] as? String else {
      XCTFail()
      return
    }

    guard let b = json["b"] as? Int else {
      XCTFail()
      return
    }

    XCTAssert(a == "1")
    XCTAssert(b == 2)
  }
}
