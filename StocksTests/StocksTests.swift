@testable import Stocks
import XCTest

class StocksTests: XCTestCase {
    func testCandleStickDataConversion() {
        let doubles: [Double] = Array(repeating: 12.5, count: 10)
        let timestamps: [TimeInterval] = (1 ... 12)
            .map { Date().addingTimeInterval(3_600 * TimeInterval($0)).timeIntervalSince1970 }
            .shuffled()

        let marketData = MarketDataResponse(openPrices: doubles,
                                            closePrices: doubles,
                                            highPrices: doubles,
                                            lowPrices: doubles,
                                            status: "success",
                                            timestamps: timestamps)
        let candleSticks = marketData.candleSticks

        XCTAssertEqual(candleSticks.count, marketData.openPrices.count)
        XCTAssertEqual(candleSticks.count, marketData.closePrices.count)
        XCTAssertEqual(candleSticks.count, marketData.highPrices.count)
        XCTAssertEqual(candleSticks.count, marketData.lowPrices.count)
    }
}
