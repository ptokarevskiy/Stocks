import Foundation

final class PersistenceManager {
    private enum Constants {
        static let onboardedKey = "hasOnboarded"
        static let watchlistKey = "watchlist"
    }

    static let shared = PersistenceManager()

    private let userDefaults: UserDefaults = .standard
    private var hasOnboarded: Bool {
        userDefaults.bool(forKey: Constants.onboardedKey)
    }

    var watchlist: [String] {
        if !hasOnboarded {
            userDefaults.set(true, forKey: Constants.onboardedKey)
            setUpDefaults()
        }

        return userDefaults.stringArray(forKey: Constants.watchlistKey) ?? []
    }

    private init() {}

    // MARK: - Public

    public func watchListContains(symbol: String) -> Bool {
        watchlist.contains(symbol)
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

    private func setUpDefaults() {
        let defaultStocks: [String: String] = [
            "AAPL": "Apple Inc.",
            "MSFT": "Microsoft Corporation",
            "GOOG": "Alphabet",
            "AMZN": "Amazon.com Inc.",
            "FB": "Meta Inc.",
            "NVDA": "Nvidia Inc."
        ]

        let symbols = defaultStocks.map(\.key)
        userDefaults.set(symbols, forKey: Constants.watchlistKey)

        for (symbol, name) in defaultStocks {
            userDefaults.set(name, forKey: symbol)
        }
    }
}
