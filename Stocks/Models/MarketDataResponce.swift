import Foundation

// MARK: - MarketDataResponce

struct MarketDataResponce: Codable {
    let openPrices: [Double]
    let closePrices: [Double]
    let highPrices: [Double]
    let lowPrices: [Double]
    let status: String // Enum? "ok" / "no_data"
    let timestamps: [TimeInterval]

    enum CodingKeys: String, CodingKey {
        case openPrices = "o"
        case closePrices = "c"
        case highPrices = "h"
        case lowPrices = "l"
        case status = "s"
        case timestamps = "t"
    }

    var candleSticks: [CandleStick] {
        var result = [CandleStick]()

        for index in 0 ..< openPrices.count {
            result.append(.init(date: Date(timeIntervalSince1970: timestamps[index]),
                                high: highPrices[index],
                                low: lowPrices[index],
                                open: openPrices[index],
                                close: closePrices[index]))
        }

        let sorted = result.sorted(by: { $0.date > $1.date })

        return sorted
    }
}

// MARK: - CandleStick

struct CandleStick: Codable {
    let date: Date
    let high: Double
    let low: Double
    let open: Double
    let close: Double
}
