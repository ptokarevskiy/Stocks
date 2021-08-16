import Foundation

final class PersistenceManager {
    static let shared = PersistenceManager()

    private let userDefaults: UserDefaults = .standard

    private enum Constants {
        static let onboardedKey = "hasOnboarded"
        static let watchlistKey = "watchlist"
    }

    private init() {}

    // MARK: - Public

    var watchlist: [String] {
        if !hasOnboarded {
            userDefaults.set(true, forKey: Constants.onboardedKey)
            setUpDefaults()
        }

        return userDefaults.stringArray(forKey: Constants.watchlistKey) ?? []
    }

    public func addToWatchList(symbol: String, companyName: String) {
        var newList = watchlist

        newList.append(symbol)

        userDefaults.set(newList, forKey: Constants.watchlistKey)
        userDefaults.set(companyName, forKey: symbol)

        NotificationCenter.default.post(name: .didAddToWatchlist, object: nil)
    }

    public func removeFromWatchlist(symbol: String) {
        let newList = watchlist.filter { $0 != symbol }

        userDefaults.set(nil, forKey: symbol)
        userDefaults.set(newList, forKey: Constants.watchlistKey)
    }

    // MARK: - Private

    private var hasOnboarded: Bool {
        userDefaults.bool(forKey: Constants.onboardedKey)
    }

    private func setUpDefaults() {
        let map: [String: String] = [
            "AAPL": "Apple Inc.",
            "MSFT": "Microsoft Corporation",
            "SNAP": "Snap Inc.",
            "GOOG": "Alphabet",
            "AMZN": "Amazon.com Inc.",
            "FB": "Facebook Inc.",
            "NVDA": "Nvidia Inc.",
            "NKE": "Nike",
            "PINS": "Pinterest Inc.",
        ]

        let symbols = map.keys.map { $0 }
        userDefaults.set(symbols, forKey: Constants.watchlistKey)

        for (symbol, name) in map {
            userDefaults.set(name, forKey: symbol)
        }
    }
}
