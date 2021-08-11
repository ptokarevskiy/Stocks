import Foundation

extension String {
    static func string(from timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)

        return DateFormatter.prettyDateFormatter.string(from: date)
    }
}
