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

extension String {

    func appendingPathComponent(_ pathComponent: String) -> String {
        return NSString(string: self).appendingPathComponent(pathComponent)
    }
}

extension Dictionary {

    var jsonString: String {
        let json = try! JSONSerialization.data(withJSONObject: self, options: [])
        return String(data: json, encoding: .utf8)!
    }
}


extension Array {

    var jsonString: String {
        let json = try! JSONSerialization.data(withJSONObject: self, options: [])
        return String(data: json, encoding: .utf8)!
    }
}

extension Dictionary {

    var keyValuePairs: String {
        return map { kv in
            let key = kv.key
            let value = "\(kv.value)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            return "\(key)=\(value)"
        }.joined(separator: "&")
    }
}

extension Dictionary {

    public mutating func merge(contentsOf dictionary: [Key: Value]) {
        dictionary.forEach { key, value in
            self[key] = value
        }
    }

    public func merging(contentsOf dictionary: [Key: Value]) -> [Key: Value] {
        var me = self
        me.merge(contentsOf: dictionary)
        return me
    }
}

public protocol OptionalProtocol {
    associatedtype Wrapped
    var _unbox: Optional<Wrapped> { get }
    init(nilLiteral: ())
    init(_ some: Wrapped)
}

extension Optional: OptionalProtocol {
    public var _unbox: Optional<Wrapped> {
        return self
    }
}

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
