//
//  RoomMessages.swift
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

extension RoomMessages {

  public func createScene() -> UIViewController {
    let vc = ViewController.RoomMessages()

    messages
      .flatMap { try? NSAttributedString(html: $0.html) }
      .bind(to: vc.tableView) { (messages, indexPath, tableView) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.classReuseIdentifier, for: indexPath) as! MessageCell
        cell.textLabel?.attributedText = messages[indexPath.row]
        return cell
    }

    return vc
  }
}
