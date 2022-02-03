import Foundation

// MARK: - MarketDataResponse

// swiftlint:disable type_contents_order
struct MarketDataResponse: Codable {
    let openPrices: [Double]
    let closePrices: [Double]
    let highPrices: [Double]
    let lowPrices: [Double]
    let status: String // "ok" / "no_data"
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
        openPrices
            .enumerated()
            .map { index, price in
                CandleStick(date: Date(timeIntervalSince1970: timestamps[index]),
                            high: highPrices[index],
                            low: lowPrices[index],
                            open: price,
                            close: closePrices[index])
            }.sorted(by: { $0.date > $1.date })
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
