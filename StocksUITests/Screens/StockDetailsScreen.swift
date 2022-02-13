import XCTest

final class StockDetailsScreen: BaseScreen {
    @discardableResult
    func checkCompanySymbol(matches expectedSymbol: String) -> StockDetailsScreen {
        XCTContext.runActivity(named: "Check company symbol") { _ in
            XCTAssertEqual(NewsSection.companySymbol.label,
                           expectedSymbol)
        }

        return self
    }
}
