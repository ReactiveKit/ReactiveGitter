//
//  RoomList.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 15/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import UIKit

extension ViewController {

  public class RoomList: UIViewController {

    public private(set) var tableView = UITableView().setup {
      $0.tableFooterView = UIView()
      $0.rowHeight = 50
    }

    public private(set) var logOutButton = UIBarButtonItem(title: "Log out", style: .plain, target: nil, action: nil)

    public init() {
      super.init(nibName: nil, bundle: nil)

      tableView.register(RoomCell.self, forCellReuseIdentifier: RoomCell.classReuseIdentifier)
      navigationItem.title = "Rooms"
      navigationItem.rightBarButtonItem = logOutButton

      view.addSubview(tableView)
      tableView.anchor(in: view)
    }
    
    public required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      if let indexPath = tableView.indexPathForSelectedRow {
        tableView.deselectRow(at: indexPath, animated: animated)
      }
    }
  }
}
