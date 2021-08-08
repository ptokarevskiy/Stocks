import Foundation

// MARK: - SearchResponse

struct SearchResponse: Codable {
    let count: Int
    let result: [SearchResult]
}

// MARK: - SearchResult

struct SearchResult: Codable {
    let description: String
    let displaySymbol: String
    let symbol: String
    let type: String
}
