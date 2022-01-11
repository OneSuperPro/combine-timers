//
//  RepeatingTimer.swift
//
//
//  Created by Michal on 2021/10/30.
//

import Combine
import CombineSchedulers

@available(iOS 14.0, *)
public extension Publishers {
    struct Repeating<Upstream>: Publisher where Upstream: Publisher {
        public typealias Output = Upstream.Output
        public typealias Failure = Upstream.Failure
        let publisher: AnyPublisher<Upstream.Output, Upstream.Failure>

        init<S: Scheduler>(upstream: Upstream, every interval: S.SchedulerTimeType.Stride, delayed: Bool, scheduler: S) {
            let timer = Publishers.Timer(every: interval, scheduler: scheduler).autoconnect()
            if delayed {
                publisher = timer
                    .map { _ in upstream }
                    .switchToLatest()
                    .eraseToAnyPublisher()
            } else {
                publisher = Concatenate(prefix: Just(scheduler.now), suffix: timer)
                    .flatMap(maxPublishers: .max(1)) { _ in upstream }
//                    .map { _ in upstream }
//                    .switchToLatest()
                    .eraseToAnyPublisher()
            }
        }

        public func receive<S>(subscriber: S) where S: Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input {
            publisher.receive(subscriber: subscriber)
        }
    }
}

@available(iOS 14.0, *)
public extension Publisher {
    func repeating<S: Scheduler>(_ interval: S.SchedulerTimeType.Stride, delayed: Bool, scheduler: S) -> Publishers.Repeating<Self> {
        Publishers.Repeating(upstream: self, every: interval, delayed: delayed, scheduler: scheduler)
    }
}
