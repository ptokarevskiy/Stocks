import Foundation

// - Date
extension DateFormatter {
    static let newsDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"

        return formatter
    }()

    static let prettyDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        return formatter
    }()
}

// - Numbers
extension NumberFormatter {
    static let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()

        formatter.locale = .current
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2

        return formatter
    }()

    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()

        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2

        return formatter
    }()
}
