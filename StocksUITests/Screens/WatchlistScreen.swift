import XCTest

final class WatchlistScreen: BaseScreen {
    @discardableResult
    func searchStock(by name: String) -> SearchResultScreen {
        XCTContext.runActivity(named: "Type <\(name)> into searchBar") { _ in
            Header.searchBar.tap()
            Header.searchBar.typeText(name)
        }

        return .init()
    }
}
