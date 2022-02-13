import XCTest

class StocksUITests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testOpenCompanyDetailsViaSearch() throws {
        app.launch()
        
        let companySymbol = "DBX"

        WatchlistScreen()
            .searchStock(by: companySymbol)
            .openDetailsForStock(named: companySymbol)
        
        StockDetailsScreen()
            .checkCompanySymbol(matches: companySymbol)
    }
}
