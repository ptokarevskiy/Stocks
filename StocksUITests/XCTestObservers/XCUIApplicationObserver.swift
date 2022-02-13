import XCTest

private var mainApp: XCUIApplication!
private(set) var app: XCUIApplication!
private(set) var springboard: XCUIApplication!

// MARK: - XCUIApplicationObserver

final class XCUIApplicationObserver: NSObject, XCTestObservation {
    func testCaseWillStart(_ testCase: XCTestCase) {
        mainApp = .init(with: .mainApp)
        springboard = .init(with: .bundle(.springboard))

        app = mainApp
    }

    func testCaseDidFinish(_ testCase: XCTestCase) {
        mainApp = nil
        app = nil
        springboard = nil
    }

    func testBundleDidFinish(_ testBundle: Bundle) {
        XCTestObservationCenter.shared.removeTestObserver(self)
    }
}
