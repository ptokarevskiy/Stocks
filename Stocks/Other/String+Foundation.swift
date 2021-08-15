import Foundation

extension String {
    static func string(from timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)

        return DateFormatter.prettyDateFormatter.string(from: date)
    }

    static func percentage(from double: Double) -> String {
        let formatter = NumberFormatter.percentFormatter

        return formatter.string(from: .init(value: double)) ?? "\(double)"
    }

    static func formatted(number: Double) -> String {
        let formatter = NumberFormatter.numberFormatter

        return formatter.string(from: .init(value: number)) ?? "\(number)"
    }
}
