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

open class Client {

    public enum Error: Swift.Error {
        case network(Swift.Error, Int)
        case remote(Swift.Error, Int)
        case parser(Swift.Error)
        case client(String)
    }

    public let baseURL: String
    public let session: URLSession
    public var defaultHeaders: [String: String] = [:]

    public init(baseURL: String, session: URLSession = URLSession.shared) {
        self.baseURL = baseURL
        self.session = session
    }

    /// For example, authorize request with the token.
    open func prepare<T, E: Swift.Error>(request: Request<T, E>) -> Request<T, E> {
        return request
    }

    /// Perform request.
    @discardableResult
    open func perform<Resource, Error: Swift.Error>(_ request: Request<Resource, Error>, completion: @escaping (Result<Resource, Client.Error>) -> Void) -> URLSessionTask {

        let request = prepare(request: request)
        let headers = defaultHeaders.merging(contentsOf: request.headers ?? [:])

        var urlRequest = URLRequest(url: URL(string: self.baseURL.appendingPathComponent(request.path))!)
        urlRequest.httpMethod = request.method.rawValue
        headers.forEach { urlRequest.addValue($1, forHTTPHeaderField: $0) }

        if let parameters = request.parameters {
            urlRequest = parameters.apply(urlRequest: urlRequest)
        }

        let task = self.session.dataTask(with: urlRequest) { (data, urlResponse, error) in
            guard let urlResponse = urlResponse as? HTTPURLResponse else {
                if let error = error {
                    completion(.failure(.network(error, 0)))
                } else {
                    completion(.failure(.client("Did not receive HTTPURLResponse. Huh?")))
                }
                return
            }

            if let error = error {
                if let data = data, let serverError = try? request.error(data) {
                    completion(.failure(.remote(serverError, urlResponse.statusCode)))
                } else {
                    completion(.failure(.network(error, urlResponse.statusCode)))
                }
                return
            }

            guard (200..<300).contains(urlResponse.statusCode) else {
                if let data = data, let error = try? request.error(data) {
                    completion(.failure(.remote(error, urlResponse.statusCode)))
                } else {
                    var message = "Validation failed: HTTP status code \(urlResponse.statusCode)."
                    if let data = data, let responseString = String(data: data, encoding: .utf8) { message += "\n" + responseString }
                    let error = Client.Error.client(message)
                    completion(.failure(.remote(error, urlResponse.statusCode)))
                }
                return
            }

            if let data = data {
                do {
                    let resource = try request.resource(data)
                    completion(.success(resource))
                } catch let error as Client.Error {
                    completion(.failure(error))
                } catch let error {
                    completion(.failure(.parser(error)))
                }
            } else {
                // no error, no data - valid empty response
                do {
                    let resource = try request.resource(Data())
                    completion(.success(resource))
                } catch let error as Client.Error {
                    completion(.failure(error))
                } catch let error {
                    completion(.failure(.parser(error)))
                }
            }
        }
        
        task.resume()
        return task
    }
}

extension Client.Error {

    public var code: Int? {
        switch self {
        case .network(_, let code):
            return code
        case .remote(_, let code):
            return code
        default:
            return 0
        }
    }
}
