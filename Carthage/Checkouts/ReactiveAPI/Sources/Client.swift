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

import Foundation
import ReactiveKit

open class Client {

  public enum Error: Swift.Error {
    case network(Swift.Error)
    case parser(Swift.Error)
    case remote(Swift.Error)
    case client(String)
  }

  public let baseURL: String
  public let session: URLSession
  public var defaultHeaders: [String: String] = [:]
  public var timeoutInterval: TimeInterval = 30

  public init(baseURL: String, session: URLSession = URLSession.shared) {
    self.baseURL = baseURL
    self.session = session
  }

  /// For example, authorize request with the token.
  open func prepare<T, E: Swift.Error>(request: Request<T, E>) -> Request<T, E> {
    return request
  }

  /// Perform request.
  open func response<Resource, Error: Swift.Error>(for request: Request<Resource, Error>) -> Signal<Resource, Client.Error> {
    let request = prepare(request: request)

    let headers = defaultHeaders.merging(contentsOf: request.headers ?? [:])
    
    var urlRequest = URLRequest(url: URL(string: self.baseURL / request.path)!)
    urlRequest.httpMethod = request.method.rawValue
    headers.forEach { urlRequest.addValue($1, forHTTPHeaderField: $0) }

    if let parameters = request.parameters {
      urlRequest = parameters.apply(urlRequest: urlRequest)
    }

    let response = Signal<Resource, Client.Error> { observer in

      let task = self.session.dataTask(with: urlRequest) { (data, urlResponse, error) in
        guard let urlResponse = urlResponse as? HTTPURLResponse else {
          if let error = error {
            observer.failed(.network(error))
          } else {
            observer.failed(.client("Did not receive HTTPURLResponse. Huh?"))
          }
          return
        }

        if let error = error {
          if let data = data, let serverError = try? request.error(data) {
            observer.failed(.remote(serverError))
          } else {
            observer.failed(.network(error))
          }
          return
        }

        guard (200..<300).contains(urlResponse.statusCode) else {
          if let data = data, let error = try? request.error(data) {
            observer.failed(.remote(error))
          } else {
            var message = "Validation failed: HTTP status code \(urlResponse.statusCode)."
            if let data = data, let responseString = String(data: data, encoding: .utf8) { message += "\n" + responseString }
            observer.failed(.client(message))
          }
          return
        }

        if let data = data {
          do {
            let resource = try request.resource(data)
            observer.next(resource)
            observer.completed()
          } catch let error as Client.Error {
            observer.failed(error)
          } catch let error {
            observer.failed(.parser(error))
          }
        } else {
          // no error, no data - valid empty response
          do {
            let resource = try request.resource(Data())
            observer.next(resource)
            observer.completed()
          } catch let error as Client.Error {
            observer.failed(error)
          } catch let error {
            observer.failed(.parser(error))
          }
        }
      }

      task.resume()

      return BlockDisposable {
        task.cancel()
      }
    }

    return response
      .timeout(after: timeoutInterval, with: .client("Network request timed out. Please check your connection."))
  }
}

extension Client.Error {

  public var localizedDescription: String {
    switch self {
    case .network(let error):
      return error.localizedDescription
    case .parser(let error):
      return error.localizedDescription
    case .remote(let error):
      return error.localizedDescription
    case .client(let message):
      return message
    }
  }
}
