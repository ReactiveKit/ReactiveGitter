//
//  RoomList.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 15/01/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Entities
import Services
import Views
import Bond
import ReactiveKit

extension RoomList {

  public typealias Scene = (
    viewController: UIViewController,
    logOut: SafeSignal<Void>
  )

  public func createScene() -> Scene {
    let vc = ViewController.RoomList()

    rooms.bind(to: vc.tableView) { (rooms, indexPath, tableView) -> UITableViewCell in
      let cell = tableView.dequeueReusableCell(withIdentifier: RoomCell.classReuseIdentifier, for: indexPath) as! RoomCell
      cell.textLabel?.text = rooms[indexPath.row].name
      return cell
    }

    vc.tableView.reactive.selectedRow
      .with(latestFrom: rooms) { $1[$0] }
      .bind(to: vc) { vc, room in
        let scene = RoomMessages(client: self.client, room: room).createScene()
        vc.navigationController?.pushViewController(scene, animated: true)
      }

    return (vc, vc.logOutButton.reactive.tap)
  }
}

extension ReactiveExtensions where Base: UITableView {

  var selectedRow: SafeSignal<Int> {
    return delegate.signal(
      for: #selector(UITableViewDelegate.tableView(_:didSelectRowAt:))
    ) { (subject: SafePublishSubject<Int>, _: UITableView, indexPath: NSIndexPath) in
      subject.next(indexPath.row)
    }
  }
}
