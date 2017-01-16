//
//  The MIT License (MIT)
//
//  Copyright (c) 2017 Srdan Rasic (@srdanrasic)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import ReactiveKit

public struct Request<Resource, Error: Swift.Error> {

  public var path: String
  public var method: HTTPMethod
  public var parameters: RequestParameters?
  public var headers: [String: String]?
  public var resource: (Data) throws -> Resource
  public var error: (Data) throws -> Error

  public init(path: String,
              method: HTTPMethod,
              parameters: RequestParameters? = nil,
              headers: [String: String]? = nil,
              resource: @escaping (Data) throws -> Resource,
              error: @escaping (Data) throws -> Error) {

    self.path = path
    self.method = method
    self.parameters = parameters
    self.headers = headers
    self.resource = resource
    self.error = error
  }
}

extension Request {

  public func response(using client: Client) -> Signal<Resource, Client.Error> {
    return client.response(for: self)
  }
}
