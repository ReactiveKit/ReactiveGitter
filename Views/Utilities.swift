//
//  Utilities.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 15/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Foundation
import UIKit

public protocol SetupProtocol: AnyObject {}

extension SetupProtocol {

  @discardableResult
  public func setup(_ configure: (Self) -> Void) -> Self {
    configure(self)
    return self
  }
}

extension SetupProtocol where Self: UIView {

  public var autoLayouting: Self {
    self.translatesAutoresizingMaskIntoConstraints = false
    return self
  }

  public func setup(_ configure: (Self) -> Void = { _ in }) -> Self {
    self.translatesAutoresizingMaskIntoConstraints = false
    configure(self)
    return self
  }
}

extension NSObject: SetupProtocol {}

extension UITableViewCell {

  public static var classReuseIdentifier: String {
    return String(describing: type(of: self))
  }
}

public extension UIEdgeInsets {

  public init(uniform value: CGFloat) {
    left = value
    right = value
    top = value
    bottom = value
  }
}

public enum Edge {
  case top
  case bottom
  case leading
  case left
  case trailing
  case right
}

public struct EdgeConstraints {
  public let leading: NSLayoutConstraint?
  public let trailing: NSLayoutConstraint?
  public let left: NSLayoutConstraint?
  public let right: NSLayoutConstraint?
  public let top: NSLayoutConstraint?
  public let bottom: NSLayoutConstraint?
}

public struct SizeConstraints {
  public let width: NSLayoutConstraint?
  public let height: NSLayoutConstraint?
}

public enum LayoutCenter {
  case x
  case y
}

public protocol Anchorable {
  var leadingAnchor: NSLayoutXAxisAnchor { get }
  var trailingAnchor: NSLayoutXAxisAnchor { get }
  var leftAnchor: NSLayoutXAxisAnchor { get }
  var rightAnchor: NSLayoutXAxisAnchor { get }
  var topAnchor: NSLayoutYAxisAnchor { get }
  var bottomAnchor: NSLayoutYAxisAnchor { get }
  var widthAnchor: NSLayoutDimension { get }
  var heightAnchor: NSLayoutDimension { get }
  var centerXAnchor: NSLayoutXAxisAnchor { get }
  var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: Anchorable {}
extension UILayoutGuide: Anchorable {}

public extension Anchorable {

  @discardableResult
  func anchor(_ edges: [Edge] = [.top, .bottom, .left, .right], in view: Anchorable, insets: UIEdgeInsets = .zero, isActive: Bool = true) -> EdgeConstraints {

    let top: NSLayoutConstraint? = edges.contains(.top) ? topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top) : nil
    let bottom: NSLayoutConstraint? = edges.contains(.bottom) ? bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom) : nil
    let leading: NSLayoutConstraint? = edges.contains(.leading) ? leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left) : nil
    let trailing: NSLayoutConstraint? = edges.contains(.trailing) ? trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right) : nil
    let left: NSLayoutConstraint? = edges.contains(.left) ? leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left) : nil
    let right: NSLayoutConstraint? = edges.contains(.right) ? rightAnchor.constraint(equalTo: view.rightAnchor, constant: -insets.right) : nil

    [top, leading, bottom, trailing, left, right].forEach {
      $0?.isActive = isActive
    }
    return EdgeConstraints(leading: leading, trailing: trailing, left: left, right: right, top: top, bottom: bottom)
  }

  @discardableResult
  func center(_ layoutCenters: [LayoutCenter] = [.x, .y], in view: Anchorable, isActive: Bool = true, offset: CGPoint = .zero) -> (x: NSLayoutConstraint?, y: NSLayoutConstraint?) {
    let x: NSLayoutConstraint? = layoutCenters.contains(.x) ? centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset.x) : nil
    let y: NSLayoutConstraint? = layoutCenters.contains(.y) ? centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset.y) : nil
    if isActive {
      x?.isActive = true
      y?.isActive = true
    }
    return (x, y)
  }

  @discardableResult
  func constrain(widthTo width: CGFloat? = nil, heightTo height: CGFloat? = nil, isActive: Bool = true) -> SizeConstraints {

    let constraints = SizeConstraints(
      width: width.flatMap { widthAnchor.constraint(equalToConstant: $0) },
      height: height.flatMap { heightAnchor.constraint(equalToConstant: $0) }
    )
    if isActive {
      constraints.width?.isActive = true
      constraints.height?.isActive = true
    }
    return constraints
  }

  @discardableResult
  func constrain(widthTo widthView: Anchorable? = nil, heightTo heightView: Anchorable? = nil, isActive: Bool = true) -> SizeConstraints {
    let constraints = SizeConstraints(
      width: widthView.flatMap { widthAnchor.constraint(equalTo: $0.widthAnchor) },
      height: heightView.flatMap { heightAnchor.constraint(equalTo: $0.heightAnchor) }
    )
    if isActive {
      constraints.width?.isActive = true
      constraints.height?.isActive = true
    }
    return constraints
  }

}

