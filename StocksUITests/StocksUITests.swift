import XCTest

class StocksUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false

        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        app = nil

        try super.tearDownWithError()
    }

    func testLaunch() throws {
        app.launch()
    }
}
