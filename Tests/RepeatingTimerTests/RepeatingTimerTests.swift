import Combine
import CombineSchedulers
import RepeatingTimer
import XCTest

class RepeatingTimerTests: XCTestCase {
    func testRepeatingEverySecondWithDelay() {
        let scheduler = DispatchQueue.test
        var output: [Void] = []

        let cancellable = Just(())
            .repeating(.seconds(1), delayed: true, scheduler: scheduler)
            .sink { output.append($0) }

        // 0s
        XCTAssertEqual(output.count, 0)

        scheduler.advance(by: 1) // 1s
        XCTAssertEqual(output.count, 1)

        scheduler.advance(by: 2) // 3s
        XCTAssertEqual(output.count, 3)

        scheduler.advance(by: 0.5) // 3.5s
        XCTAssertEqual(output.count, 3)

        cancellable.cancel()

        scheduler.advance(by: 2) // 5.5s
        XCTAssertEqual(output.count, 3)
    }

    func testRepeatingEverySecondWithoutDelay() {
        let scheduler = DispatchQueue.test
        var output: [Void] = []

        let cancellable = Just(())
            .repeating(.seconds(1), delayed: false, scheduler: scheduler)
            .sink { output.append($0) }

        // 0s
        XCTAssertEqual(output.count, 1)

        scheduler.advance(by: 1) // 1s
        XCTAssertEqual(output.count, 2)

        scheduler.advance(by: 2) // 3s
        XCTAssertEqual(output.count, 4)

        scheduler.advance(by: 0.5) // 3.5s
        XCTAssertEqual(output.count, 4)

        cancellable.cancel()

        scheduler.advance(by: 2) // 5.5s
        XCTAssertEqual(output.count, 4)
    }

    func testRestartingTimerEverySecondWithoutDelay() {
        let scheduler = DispatchQueue.test
        var output: [DispatchQueue.SchedulerTimeType] = []
        // TODO: ^ test the values

        let upstream = Publishers.Timer(every: .seconds(0.5), scheduler: scheduler).autoconnect()
            .flatMap { _ in Just(scheduler.now) }
        let cancellable = upstream
            .repeating(.seconds(1), delayed: false, scheduler: scheduler)
            .sink { output.append($0) }

        // 0s
        XCTAssertEqual(output.count, 0)

        scheduler.advance(by: 1) // 1s
        XCTAssertEqual(output.count, 2)

        scheduler.advance(by: 2) // 3s
        XCTAssertEqual(output.count, 6)

        scheduler.advance(by: 0.5) // 3.5s
        XCTAssertEqual(output.count, 7)

        cancellable.cancel()

        scheduler.advance(by: 2) // 5.5s
        XCTAssertEqual(output.count, 7)

        print(output)
    }
}
