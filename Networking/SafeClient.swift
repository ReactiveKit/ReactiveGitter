//
//  SafeClient.swift
//  ReactiveGitter
//
//  Created by Srdan Rasic on 07/05/2017.
//  Copyright © 2017 ReactiveKit. All rights reserved.
//

import Foundation
import ReactiveKit
import Client

public struct UserFriendlyError {

    public let message: String
    public let retry: PublishSubject<Void, NoError>?

    public init(message: String, canRetry: Bool) {
        self.message = message

        if canRetry {
            retry = PublishSubject()
        } else {
            retry = nil
        }
    }
}

public class SafeClient {

    public let base: Client
    public let errors = SafePublishSubject<UserFriendlyError>()
    public let activity = Activity()

    public init(wrapping client: Client) {
        base = client
    }

    public func response<Resource, Error: Swift.Error>(for request: Request<Resource, Error>, canUserRetry: Bool = true, autoRetryTimes: Int = 0, trackActivity: Bool = true) -> SafeSignal<Resource> {
        if trackActivity {
            return base
                .response(for: request)
                .retry(times: autoRetryTimes)
                .feedActivity(into: activity)
                .debug(request.path)
                .suppressAndFeedError(into: errors, canUserRetry: canUserRetry, map: { $0.localizedDescription })
        } else {
            return base
                .response(for: request)
                .retry(times: autoRetryTimes)
                .debug(request.path)
                .suppressAndFeedError(into: errors, canUserRetry: canUserRetry, map: { $0.localizedDescription })
        }
    }

    public func unsafeResponse<Resource, Error: Swift.Error>(for request: Request<Resource, Error>, trackActivity: Bool = true) -> Signal<Resource, Client.Error> {
        if trackActivity {
            return base.response(for: request).feedActivity(into: activity)
        } else {
            return base.response(for: request)
        }
    }
}

extension Request {

    public func response(using client: SafeClient, canUserRetry: Bool = true, autoRetryTimes: Int = 0, trackActivity: Bool = true) -> SafeSignal<Resource> {
        return client.response(for: self, canUserRetry: canUserRetry, autoRetryTimes: autoRetryTimes, trackActivity: trackActivity)
    }

    public func unsafeResponse(using client: SafeClient, trackActivity: Bool = true) -> Signal<Resource, Client.Error> {
        return client.unsafeResponse(for: self, trackActivity: trackActivity)
    }
}

extension SignalProtocol {

    public func feedError<S: SubjectProtocol>(into subject: S, canUserRetry: Bool, map: @escaping (Error) -> String) -> Signal<Element, Error> where S.Element == UserFriendlyError {
        return Signal { observer in
            let serialDisposable = SerialDisposable(otherDisposable: nil)
            var attempt: (() -> Void)? = nil
            attempt = {
                let disposables = CompositeDisposable()
                serialDisposable.otherDisposable?.dispose()
                serialDisposable.otherDisposable = disposables
                disposables += self.observe { event in
                    switch event {
                    case .next(let element):
                        observer.next(element)
                    case .completed:
                        attempt = nil
                        observer.completed()
                    case .failed(let error):
                        if canUserRetry {
                            let ce = UserFriendlyError(message: map(error), canRetry: true)
                            disposables += ce.retry!.observe { event in
                                switch event {
                                case .next:
                                    attempt?()
                                case .completed, .failed:
                                    attempt = nil
                                    observer.failed(error)
                                }
                            }
                            subject.next(ce)
                        } else {
                            attempt = nil
                            subject.next(UserFriendlyError(message: map(error), canRetry: false))
                            observer.failed(error)
                        }
                    }
                }
            }
            attempt?()
            return serialDisposable
        }
    }
    
    public func suppressAndFeedError<S: SubjectProtocol>(into subject: S, canUserRetry: Bool, map: @escaping (Error) -> String) -> Signal<Element, NoError> where S.Element == UserFriendlyError {
        return feedError(into: subject, canUserRetry: canUserRetry, map: map).suppressError(logging: true)
    }
}
