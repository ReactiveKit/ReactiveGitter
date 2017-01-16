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

public protocol RequestParameters {
  func apply(urlRequest: URLRequest) -> URLRequest
}

public struct FormParameters: RequestParameters {

  public let data: [String: Any]

  public init(_ data: [String: Any]) {
    self.data = data
  }

  public func apply(urlRequest: URLRequest) -> URLRequest {
    var request = urlRequest
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpBody = data.keyValuePairs.data(using: .utf8)
    return request
  }
}

public struct JSONParameters: RequestParameters {

  public let json: Any

  public init(_ json: Any) {
    self.json = json
  }

  public func apply(urlRequest: URLRequest) -> URLRequest {
    var request = urlRequest
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    if let json = json as? [Any] {
      request.httpBody = json.jsonString.data(using: .utf8)
    } else if let json = json as? [String: Any] {
      request.httpBody = json.jsonString.data(using: .utf8)
    }

    return request
  }
}

public struct QueryParameters: RequestParameters {

  public let query: [String: String]

  public init(_ query: [String: String]) {
    self.query = query
  }

  public func apply(urlRequest: URLRequest) -> URLRequest {
    var request = urlRequest
    var urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)!
    var items = urlComponents.queryItems ?? []
    items.append(contentsOf: query.map { URLQueryItem(name: $0.key, value: $0.value) })
    urlComponents.queryItems = items
    request.url = urlComponents.url
    return request
  }
}
