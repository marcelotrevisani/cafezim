import XCTest
import CafezimCore

final class MenuBarViewTests: XCTestCase {

    // MARK: - DurationMode hoursForMode mapping

    func testDurationModeValues() {
        // Verify all duration modes map to expected values
        let cases: [(MenuBarView.DurationMode, Double?)] = [
            (.indefinite, nil),
            (.thirtyMinutes, 0.5),
            (.oneHour, 1),
            (.twoHours, 2),
            (.fourHours, 4),
            (.eightHours, 8),
        ]

        for (mode, expected) in cases {
            XCTAssertEqual(expected, MenuBarView.hoursForMode(mode), "Mode \(mode.rawValue) should map to \(String(describing: expected))")
        }
    }

    func testDurationModeRawValues() {
        XCTAssertEqual(MenuBarView.DurationMode.indefinite.rawValue, "Indefinitely")
        XCTAssertEqual(MenuBarView.DurationMode.thirtyMinutes.rawValue, "30 minutes")
        XCTAssertEqual(MenuBarView.DurationMode.oneHour.rawValue, "1 hour")
        XCTAssertEqual(MenuBarView.DurationMode.twoHours.rawValue, "2 hours")
        XCTAssertEqual(MenuBarView.DurationMode.fourHours.rawValue, "4 hours")
        XCTAssertEqual(MenuBarView.DurationMode.eightHours.rawValue, "8 hours")
        XCTAssertEqual(MenuBarView.DurationMode.custom.rawValue, "Custom hours...")
    }

    func testAllDurationModesExist() {
        XCTAssertEqual(MenuBarView.DurationMode.allCases.count, 7)
    }

    // MARK: - Helpers

    /// Mirror of the view's hoursForMode logic for testing
    private func hoursForMode(_ mode: MenuBarView.DurationMode) -> Double? {
        switch mode {
        case .indefinite: return nil
        case .thirtyMinutes: return 0.5
        case .oneHour: return 1
        case .twoHours: return 2
        case .fourHours: return 4
        case .eightHours: return 8
        case .custom: return nil // can't test custom input here
        }
    }
}
