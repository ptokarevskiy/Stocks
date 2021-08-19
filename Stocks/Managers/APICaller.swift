import Foundation

final class APICaller {
    static let shared = APICaller()

    private enum Constants {
        static let apiKey = "c47snsqad3icscifmh70"
        static let sandboxApiKey = "sandbox_c47snsqad3icscifmh7g"
        static let baseURL = "https://finnhub.io/api/v1/"
        static let day: TimeInterval = 3600 * 24
    }

    private init() {}

    // MARK: - Public

    public func search(query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        guard let safeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        let url = url(forEndpoint: .search, queryParams: ["q": safeQuery])

        request(url: url, expecting: SearchResponse.self, completion: completion)
    }

    public func news(for type: NewsViewController.NewsViewControllerType,
                     completion: @escaping (Result<[NewsStory], Error>) -> Void)
    {
        switch type {
        case .topStories:
            let url = url(forEndpoint: .topStories, queryParams: ["category": "general"])

            request(url: url, expecting: [NewsStory].self, completion: completion)

        case let .company(symbol: symbol):
            let today = Date()
            let lastFewDays = today.addingTimeInterval(-(Constants.day * 3))
            let url = url(forEndpoint: .companyNews,
                          queryParams: ["symbol": symbol,
                                        "from": DateFormatter.newsDateFormatter.string(from: lastFewDays),
                                        "to": DateFormatter.newsDateFormatter.string(from: today)])

            request(url: url, expecting: [NewsStory].self, completion: completion)
        }
    }

    public func marketData(for symbol: String,
                           numberOfDays: TimeInterval = 7,
                           completion: @escaping (Result<MarketDataResponce, Error>) -> Void)
    {
        let today = Date().addingTimeInterval(-(Constants.day * 2))
        let lastFewDays = today.addingTimeInterval(-(Constants.day * numberOfDays))
        let url = url(forEndpoint: .marketData, queryParams: ["symbol": symbol,
                                                              "resolution": "1",
                                                              "from": "\(Int(lastFewDays.timeIntervalSince1970))",
                                                              "to": "\(Int(today.timeIntervalSince1970))"])

        request(url: url, expecting: MarketDataResponce.self, completion: completion)
    }

    public func financialMetrics(for symbol: String,
                                 completion: @escaping (Result<FinancialMetricsResponse, Error>) -> Void)
    {
        let url = url(forEndpoint: .metrics, queryParams: ["symbol": symbol,
                                                           "metric": "all"])

        request(url: url, expecting: FinancialMetricsResponse.self, completion: completion)
    }

    // MARK: - Private

    private enum Endpoint: String {
        case search
        case topStories = "news"
        case companyNews = "company-news"
        case marketData = "stock/candle"
        case metrics = "stock/metric"
    }

    private enum APIError: Error {
        case unvalidURL
        case noDataReturn
    }

    private func url(forEndpoint endpoint: Endpoint, queryParams: [String: String] = [:]) -> URL? {
        var urlString = Constants.baseURL + endpoint.rawValue
        var queryItems = [URLQueryItem]()

        for (name, value) in queryParams {
            queryItems.append(.init(name: name, value: value))
        }

        queryItems.append(.init(name: "token", value: Constants.apiKey))
        urlString += "?" + queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")

        return URL(string: urlString)
    }

    private func request<T: Codable>(url: URL?, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = url else {
            completion(.failure(APIError.unvalidURL))

            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(APIError.noDataReturn))
                }

                return
            }

            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
