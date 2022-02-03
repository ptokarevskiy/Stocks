import Foundation

extension Array where Element == CandleStick {
    func getPercentage() -> Double {
        guard let latestDate = self[safe: 0]?.date else {
            return 0.0
        }

        guard let latestClose = first?.close,
              let priorClose = first(where: { !Calendar.current.isDate($0.date, inSameDayAs: latestDate) })?.close else {
            return 0.0
        }

        let difference = 1 - (priorClose / latestClose)

        return difference
    }
}
