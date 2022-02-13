import XCTest

extension SearchResultScreen {
    enum Content: ElementResolver {
        static let resultCells: XCUIElementQuery = resolveBy(identifier: "search_results.company_cell")

        static func companyCell(with name: String) -> XCUIElement {
            resultCells.containing(.any, identifier: name).element
        }
    }
}
