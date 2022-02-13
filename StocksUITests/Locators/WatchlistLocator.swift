import XCTest

extension WatchlistScreen {
    // MARK: - Header

    enum Header: ElementResolver {
        static let searchBar: XCUIElement = resolveBy(identifier: "watchlist.search_field", boundBy: 0)
    }

    // MARK: - Content

    enum Content: ElementResolver {
        static let companyCells: XCUIElementQuery = resolveBy(identifier: "watchlist.company_cell")

        static func company(name: String) -> XCUIElement {
            companyCells.containing(.any, identifier: name).element
        }

        static func company(symbol: String) -> XCUIElement {
            companyCells.containing(.any, identifier: symbol).element
        }
    }
}
