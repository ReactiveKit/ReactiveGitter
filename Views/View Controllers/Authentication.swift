//
//  AuthenticationViewController.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 15/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import UIKit

extension ViewController {

  public class Authentication: UIViewController {

    public private(set) lazy var titleLabel = UILabel().setup {
      $0.text = "Reactive Gitter"
      $0.font = .preferredFont(forTextStyle: .title1)
    }

    public private(set) lazy var loginButton = UIButton(type: .system).setup {
      $0.setTitle("Log in", for: .normal)
    }

    public init() {
      super.init(nibName: nil, bundle: nil)
      view.backgroundColor = .white

      view.addSubview(titleLabel)
      titleLabel.center(in: view)

      view.addSubview(loginButton)
      loginButton.center(in: view, offset: .init(x: 0, y: 60))
    }

    public required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}
