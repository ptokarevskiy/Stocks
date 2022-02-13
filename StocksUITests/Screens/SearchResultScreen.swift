import XCTest

final class SearchResultScreen: BaseScreen {
    @discardableResult
    func openDetailsForStock(named name: String) -> StockDetailsScreen {
        XCTContext.runActivity(named: "Tap company cell with label <\(name)>") { _ in
            _ = Content.resultCells.element(boundBy: 0).waitForExistence(timeout: .long)
            Content.companyCell(with: name).firstMatch.tap()
        }

        return .init()
    }
}
