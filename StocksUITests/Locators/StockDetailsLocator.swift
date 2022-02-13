import XCTest

extension StockDetailsScreen {
    enum NewsSection: ElementResolver {
        static let companySymbol: XCUIElement = resolveBy(identifier: "news_header_view.company_symbol", boundBy: 0)
        static let addToWatchListButton: XCUIElement = resolveBy(identifier: "news_header_view.add_to_watchlist_button")
    }
}
