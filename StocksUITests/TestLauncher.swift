import XCTest

@objc(TestLauncher)
final class TestLauncher: NSObject {
    override init() {
        super.init()

        XCTestObservationCenter.shared.addTestObserver(XCUIApplicationObserver())
    }
}
