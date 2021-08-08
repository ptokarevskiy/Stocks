import Foundation

final class PersistanceManager {
    static let shared = PersistanceManager()

    private let userDefaults: UserDefaults = .standard

    private struct Constants {}

    private init() {}

    // MARK: - Public

    var watchlist: [String] {
        []
    }

    public func addToWatchList() {}

    public func removeFromWatchlist() {}

    // MARK: - Private

    private var hasOnboarded: Bool {
        false
    }
}
