import Foundation

// MARK: - FinancialMetricsResponse

struct FinancialMetricsResponse: Codable {
    struct Metrics: Codable {
        let averageTradingVolume: Float
        let high: Double
        let low: Double
        let lowDate: String
        let priceReturnDaily: Float
        let beta: Float

        enum CodingKeys: String, CodingKey {
            case averageTradingVolume = "10DayAverageTradingVolume"
            case high = "52WeekHigh"
            case low = "52WeekLow"
            case lowDate = "52WeekLowDate"
            case priceReturnDaily = "52WeekPriceReturnDaily"
            case beta
        }
    }

    let metric: Metrics
}
