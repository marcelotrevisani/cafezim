import XCTest
import CafezimCore

final class SleepManagerTests: XCTestCase {

    var manager: SleepManager!

    override func setUp() {
        super.setUp()
        manager = SleepManager()
    }

    override func tearDown() {
        manager.deactivate()
        manager = nil
        super.tearDown()
    }

    // MARK: - Activation / Deactivation

    func testInitialState() {
        XCTAssertFalse(manager.isActive)
        XCTAssertNil(manager.durationHours)
        XCTAssertNil(manager.activatedAt)
        XCTAssertNil(manager.timeRemaining)
    }

    func testActivateIndefinitely() {
        manager.activate(hours: nil)

        XCTAssertTrue(manager.isActive)
        XCTAssertNil(manager.durationHours)
        XCTAssertNotNil(manager.activatedAt)
        XCTAssertNil(manager.timeRemaining, "Indefinite mode should have no time remaining")
    }

    func testActivateWithDuration() {
        manager.activate(hours: 2)

        XCTAssertTrue(manager.isActive)
        XCTAssertEqual(manager.durationHours, 2)
        XCTAssertNotNil(manager.activatedAt)
        XCTAssertNotNil(manager.timeRemaining)
    }

    func testDeactivate() {
        manager.activate(hours: nil)
        XCTAssertTrue(manager.isActive)

        manager.deactivate()

        XCTAssertFalse(manager.isActive)
        XCTAssertNil(manager.activatedAt)
    }

    func testDoubleActivateIsNoOp() {
        manager.activate(hours: 1)
        let firstActivation = manager.activatedAt

        manager.activate(hours: 2)

        XCTAssertEqual(manager.activatedAt, firstActivation, "Second activate should be ignored")
        XCTAssertEqual(manager.durationHours, 1, "Duration should not change on double activate")
    }

    func testDoubleDeactivateIsNoOp() {
        manager.deactivate()
        XCTAssertFalse(manager.isActive, "Deactivating when inactive should be safe")
    }

    // MARK: - Time Remaining

    func testTimeRemainingDecreases() {
        manager.activate(hours: 1)

        guard let remaining = manager.timeRemaining else {
            XCTFail("Expected time remaining for timed activation")
            return
        }

        // Should be close to 3600 seconds (1 hour), allow 5 seconds tolerance
        XCTAssertLessThanOrEqual(abs(remaining - 3600), 5)
    }

    func testTimeRemainingIsNilWhenInactive() {
        XCTAssertNil(manager.timeRemaining)
    }

    func testTimeRemainingIsNilForIndefinite() {
        manager.activate(hours: nil)
        XCTAssertNil(manager.timeRemaining)
    }

    // MARK: - Assertion ID

    func testAssertionIDSetOnActivate() {
        manager.activate(hours: nil)
        XCTAssertNotEqual(manager.assertionID, 0, "Assertion ID should be set after activation")
    }

    func testAssertionIDResetOnDeactivate() {
        manager.activate(hours: nil)
        manager.deactivate()
        XCTAssertEqual(manager.assertionID, 0, "Assertion ID should be reset after deactivation")
    }

    // MARK: - Default Duration

    func testDefaultActivationIsIndefinite() {
        manager.activate()
        XCTAssertNil(manager.durationHours, "Default activation should be indefinite")
    }

    // MARK: - Various Durations

    func testActivateHalfHour() {
        manager.activate(hours: 0.5)

        XCTAssertTrue(manager.isActive)
        XCTAssertEqual(manager.durationHours, 0.5)
        guard let remaining = manager.timeRemaining else {
            XCTFail("Expected time remaining")
            return
        }
        XCTAssertLessThanOrEqual(abs(remaining - 1800), 5)
    }

    func testActivateEightHours() {
        manager.activate(hours: 8)

        XCTAssertTrue(manager.isActive)
        XCTAssertEqual(manager.durationHours, 8)
        guard let remaining = manager.timeRemaining else {
            XCTFail("Expected time remaining")
            return
        }
        XCTAssertLessThanOrEqual(abs(remaining - 28800), 5)
    }
}
