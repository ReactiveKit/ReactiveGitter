//
//  Extensions.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 16/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Foundation

extension NSAttributedString {

  convenience init(html: String) throws {
    guard let data = NSAttributedString.styledHTMLwithHTML(html).data(using: String.Encoding.utf8) else {
      throw NSError(domain: "Invalid HTML", code: -500, userInfo: nil)
    }

    let options = [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue] as [String : Any]
    try self.init(data: data, options: options, documentAttributes: nil)
  }

  static func styledHTMLwithHTML(_ html: String) -> String {
    return "<meta charset=\"UTF-8\"><style> body { font-family: 'HelveticaNeue'; font-size: 16px; } b {font-family: 'MarkerFelt-Wide'; }</style><body>" + html + "</body>";
  }
}
