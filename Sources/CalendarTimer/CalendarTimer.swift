//
//  CalendarTimer.swift
//
//
//  Created by Michal on 2021/10/12.
//

import Combine
import CombineSchedulers
import struct Foundation.Date
import struct Foundation.TimeZone

public enum CalendarTimer {
    public static func nextDay<S: Scheduler>(
        timeZone: TimeZone,
        repeats: Bool = false,
        scheduler: S
    ) -> AnyPublisher<Void, Never> {
        let seconds = Date().distanceToNextDay(timeZone: timeZone)
        let interval = S.SchedulerTimeType.Stride.seconds(seconds)
        let next = Just(())
            .delay(for: interval, scheduler: scheduler)
            .eraseToAnyPublisher()
        if repeats == false {
            return next
        } else {
            let timer = Publishers.Timer<S>(every: .seconds(24 * 60 * 60), scheduler: scheduler)
                .autoconnect()
                .map { _ in }
                .eraseToAnyPublisher()
            return Publishers.Concatenate(prefix: next, suffix: timer)
                .map { _ in }
                .eraseToAnyPublisher()
        }
    }
}
