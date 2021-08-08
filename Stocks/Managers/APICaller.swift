import Foundation

final class APICaller {
    static let shared = APICaller()

    private enum Constants {
        static let apiKey = "c47snsqad3icscifmh70"
        static let sandboxApiKey = "sandbox_c47snsqad3icscifmh7g"
        static let baseURL = "https://finnhub.io/api/v1/"
    }

    private init() {}

    // MARK: - Public

    public func search(query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        guard let safeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        request(url: url(forEndpoint: .search, queryParams: ["q": safeQuery]),
                expecting: SearchResponse.self,
                completion: completion)
    }

    // MARK: - Private

    private enum Endpoint: String {
        case search
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

        queryItems.append(.init(name: "token", value: Constants.sandboxApiKey))
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
