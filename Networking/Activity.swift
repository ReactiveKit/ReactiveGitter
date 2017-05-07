//
//  Activity.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 07/05/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import ReactiveKit
import UIKit

public class Activity {

    fileprivate let _isActive = Property(false)

    private var count = 0 {
        didSet {
            if oldValue == 1, count == 0 {
                _isActive.value = false
            } else if oldValue == 0, count == 1 {
                _isActive.value = true
            }
        }
    }

    public var isActive: Bool {
        return _isActive.value
    }

    public init(updateNetworkActivityIndicator: Bool = true) {
        if updateNetworkActivityIndicator {
            _ = _isActive.observeNext { isActive in
                UIApplication.shared.isNetworkActivityIndicatorVisible = isActive
            }
        }
    }

    public func increase() {
        count += 1
    }

    public func decrease() {
        count -= 1
    }
}

extension Activity: SubjectProtocol {

    public func on(_ event: Event<Bool, NoError>) {
        switch event {
        case .next(let active):
            if active {
                increase()
            } else {
                decrease()
            }
        default:
            break
        }
    }
    
    public func observe(with observer: @escaping (Event<Bool, NoError>) -> Void) -> Disposable {
        return _isActive.observeIn(.immediateOnMain).observe(with: observer)
    }
}
