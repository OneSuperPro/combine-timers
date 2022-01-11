import Foundation

public extension Date {
    /// Returns a new `Date` representing the date starting on the beginning of the day.
    /// - Parameter calendar: The calendar used to calculate the next day.
    /// - Returns: A new date, or nil if a date could not be calculated with the given input.
    func beginningOfDay(calendar: Calendar) -> Date? {
        guard let date = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self) else {
            assertionFailure("Failed to reset time of a date")
            return nil
        }
        return date
    }

    /// Returns a new `Date` representing the date starting on the beginning of the day.
    /// - Parameter timeZone: The time zone used to calculate the next day.
    /// - Returns: A new date, or nil if a date could not be calculated with the given input.
    func beginningOfDay(timeZone: TimeZone) -> Date? {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        return beginningOfDay(calendar: calendar)
    }

    /// Returns a new `Date` representing the date starting on the beginning of the next day.
    /// - Parameter calendar: The calendar used to calculate the next day.
    /// - Returns: A new date, or nil if a date could not be calculated with the given input.
    func nextDay(calendar: Calendar) -> Date? {
        // add one day
        guard let dayLater = calendar.date(byAdding: .day, value: 1, to: self) else {
            assertionFailure("Failed to add 1 day to the current date")
            return nil
        }
        // reset the time
        return dayLater.beginningOfDay(calendar: calendar)
    }

    /// Returns a new `Date` representing the date starting on the beginning of the next day.
    /// - Parameter timeZone: The time zone used to calculate the next day.
    /// - Returns: A new date, or nil if a date could not be calculated with the given input.
    func nextDay(timeZone: TimeZone) -> Date? {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        return nextDay(calendar: calendar)
    }

    /// Returns the distance from this date to the beginning of the next day, specified as a time interval.
    /// - Parameter timeZone: The time zone used to calculate the next day.
    /// - Returns: The distance from this date to the other date, as a `TimeInterval` (in seconds).
    func distanceToNextDay(timeZone: TimeZone) -> TimeInterval {
        guard let date = nextDay(timeZone: timeZone) else {
            assertionFailure("Failed to get the next day of \(self)")
            return -1
        }
        return distance(to: date)
    }
}
