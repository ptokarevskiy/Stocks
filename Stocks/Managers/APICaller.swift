import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private struct Constants {
        static let apiKey = ""
        static let sandboxApiKey = ""
        static let baseURL = ""
    }

    private init() {}

    // MARK: - Public

    // MARK: - Private

    private enum Endpoint: String {
        case search
    }

    private enum APIError: Error {
        case unvalidURL
        case noDataReturn
    }

    private func url(forEndpoint endpoint: Endpoint, queryParams: [String: String] = [:]) -> URL? {
        nil
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
