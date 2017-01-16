//
//  RoomMessages.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 15/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import UIKit

extension ViewController {

  public class RoomMessages: UIViewController {

    public private(set) var tableView = UITableView().setup {
      $0.tableFooterView = UIView()
      $0.rowHeight = UITableViewAutomaticDimension
      $0.estimatedRowHeight = 200
      $0.allowsSelection = false
    }

    public init() {
      super.init(nibName: nil, bundle: nil)

      tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.classReuseIdentifier)

      view.addSubview(tableView)
      tableView.anchor(in: view)
    }

    public required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}
