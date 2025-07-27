//
//  APIClient.swift
//  TransactionTracker
//
//  Created by Subhajit Biswas on 25/07/25.
//

import Foundation

final class APIClient: APIService {
    
    private let session: URLSession
    private let baseURL: String
    
    init(baseURL: String = StringConstants.empty, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    func request<T: Decodable>(
        endpoint: APIEndpoint,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        var urlComponents = URLComponents(string: baseURL + endpoint.path)
        urlComponents?.queryItems = endpoint.queryItems
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = endpoint.body
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }

        task.resume()
    }
}
