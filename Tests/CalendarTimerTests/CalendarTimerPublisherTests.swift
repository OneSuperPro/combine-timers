//
//  CalendarTimerPublisherTests.swift
//
//
//  Created by Michal on 2021/10/12.
//

@testable import CalendarTimer
import Combine
import CombineSchedulers
import XCTest

private let secondsInDay: Double = 24 * 60 * 60

@available(iOS 15.0.0, *)
class CalendarTimerPublisherTests: XCTestCase {
    func testNextDayPublisherInTimeZone(_ timeZone: TimeZone, repeats: Bool, stride: DispatchQueue.SchedulerTimeType.Stride) async throws -> UInt {
        let scheduler = DispatchQueue.test
        return await withUnsafeContinuation { (continuation: UnsafeContinuation<UInt, Never>) in
            var cancellable: Cancellable?
            var counter: UInt = 0
            var finished = false
            cancellable = CalendarTimer.nextDay(timeZone: timeZone, repeats: repeats, scheduler: scheduler)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure:
                        XCTFail()
                    case .finished:
                        finished = true
                    }
                }, receiveValue: {
                    counter += 1
                })
            scheduler.advance(by: stride)
            if repeats {
                XCTAssertFalse(finished)
            } else {
                XCTAssertEqual(1, counter)
                if counter > 0 {
                    XCTAssertTrue(finished)
                }
            }
            cancellable = nil
            continuation.resume(returning: counter)
        }
    }

    func testNextDayPublisherInTimeZone(_ timeZone: TimeZone) async throws {
        // advance by 24 hours
        var counter = try await testNextDayPublisherInTimeZone(timeZone, repeats: false, stride: .seconds(secondsInDay))
        XCTAssertEqual(1, counter)

        // advance by 48 hours
        counter = try await testNextDayPublisherInTimeZone(timeZone, repeats: false, stride: .seconds(2 * secondsInDay))
        XCTAssertEqual(1, counter)

        // advance to the next day and a second
        let interval = Date().distanceToNextDay(timeZone: timeZone) + 1
        counter = try await testNextDayPublisherInTimeZone(timeZone, repeats: false, stride: .seconds(interval))
        XCTAssertEqual(1, counter)

        // advance by 24 hours (repeated)
        counter = try await testNextDayPublisherInTimeZone(timeZone, repeats: true, stride: .seconds(secondsInDay))
        XCTAssertEqual(1, counter)

        // advance by 48 hours (repeated)
        counter = try await testNextDayPublisherInTimeZone(timeZone, repeats: true, stride: .seconds(2 * secondsInDay))
        XCTAssertEqual(2, counter)

        // advance to the next day and 24 hours and a second (repeated)
        counter = try await testNextDayPublisherInTimeZone(timeZone, repeats: true, stride: .seconds(interval + secondsInDay + 1))
        XCTAssertEqual(2, counter)

        // advance to the next day and 48 hours and a second (repeated)
        counter = try await testNextDayPublisherInTimeZone(timeZone, repeats: true, stride: .seconds(interval + 2 * secondsInDay + 1))
        XCTAssertEqual(3, counter)

        // advance to the next day and 24 hours without a few seconds (repeated)
        counter = try await testNextDayPublisherInTimeZone(timeZone, repeats: true, stride: .seconds(interval + secondsInDay - 2))
        XCTAssertEqual(1, counter)
    }

    func testNextDayPublisherInUTC() async throws {
        let timeZone = try XCTUnwrap(TimeZone(identifier: "UTC"))
        try await testNextDayPublisherInTimeZone(timeZone)
    }

    func testNextDayPublisherInLondon() async throws {
        let timeZone = try XCTUnwrap(TimeZone(identifier: "Europe/London"))
        try await testNextDayPublisherInTimeZone(timeZone)
    }

    func testNextDayPublisherInNewYork() async throws {
        let timeZone = try XCTUnwrap(TimeZone(identifier: "America/New_York"))
        try await testNextDayPublisherInTimeZone(timeZone)
    }
}
