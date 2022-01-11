//
//  NextDayTests.swift
//
//
//  Created by Michal on 2021/10/12.
//

@testable import CalendarTimer
import XCTest

private let secondsInDay: TimeInterval = 24 * 60 * 60

class NextDayTests: XCTestCase {
    func testNextDayInTimeZone(identifier timeZoneId: String) throws {
        let timeZone = try XCTUnwrap(TimeZone(identifier: timeZoneId))
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = timeZone
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = timeZone
        let now = Date()
        let dayStartedAt = try XCTUnwrap(now.beginningOfDay(calendar: calendar))
        let nextDay = try XCTUnwrap(now.nextDay(timeZone: timeZone))
        debugPrint("tz: \(timeZoneId), now: \(dateFormatter.string(from: now)), " +
            "started at: \(dateFormatter.string(from: dayStartedAt)), " +
            "next day starts at: \(dateFormatter.string(from: nextDay)) (\(nextDay)")
        XCTAssertEqual(0, calendar.component(.second, from: dayStartedAt))
        XCTAssertEqual(0, calendar.component(.minute, from: dayStartedAt))
        XCTAssertEqual(0, calendar.component(.hour, from: dayStartedAt))
        XCTAssertEqual(calendar.component(.day, from: now), calendar.component(.day, from: dayStartedAt))
        XCTAssertEqual(0, calendar.component(.second, from: nextDay))
        XCTAssertEqual(0, calendar.component(.minute, from: nextDay))
        XCTAssertEqual(0, calendar.component(.hour, from: nextDay))
        XCTAssertEqual(calendar.component(.day, from: now) + 1, calendar.component(.day, from: nextDay))
        XCTAssertEqual(calendar.component(.day, from: dayStartedAt) + 1, calendar.component(.day, from: nextDay))
    }

    func testDistanceToNextDayInTimeZone(identifier timeZoneId: String) throws {
        let timeZone = try XCTUnwrap(TimeZone(identifier: timeZoneId))
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = timeZone
        let now = Date()
        let distanceToNextDay = now.distanceToNextDay(timeZone: timeZone)
        // sanity tests
        XCTAssertGreaterThanOrEqual(distanceToNextDay, 0)
        XCTAssertLessThan(distanceToNextDay, secondsInDay)
        let dayStartedAt = try XCTUnwrap(now.beginningOfDay(calendar: calendar))
        // compare with the beginning of the day
        XCTAssertEqual(secondsInDay, dayStartedAt.distanceToNextDay(timeZone: timeZone))
        XCTAssertGreaterThanOrEqual(dayStartedAt.distanceToNextDay(timeZone: timeZone), distanceToNextDay)
    }

    func testNextDayInUTC() throws {
        try testNextDayInTimeZone(identifier: "UTC")
    }

    func testNextDayInLondon() throws {
        try testNextDayInTimeZone(identifier: "Europe/London")
    }

    func testDistanceToNextDayInLondon() throws {
        try testDistanceToNextDayInTimeZone(identifier: "Europe/London")
    }

    func testNextDayInTaipei() throws {
        try testNextDayInTimeZone(identifier: "Asia/Taipei")
    }

    func testNextDayInNewYork() throws {
        try testNextDayInTimeZone(identifier: "America/New_York")
    }
}
