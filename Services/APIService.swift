//
//  APIService.swift
//  TransactionTracker
//
//  Created by Subhajit Biswas on 25/07/25.
//

import Foundation

// MARK: - APIService Protocol
protocol APIService {
    func request<T: Decodable>(
        endpoint: APIEndpoint,
        completion: @escaping (Result<T, APIError>) -> Void
    )
}

// MARK: - HTTP Method Enum
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    // We can add more as needed
}

// MARK: - API Endpoint
struct APIEndpoint {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]?
    let queryItems: [URLQueryItem]?
    let body: Data?
}

// MARK: - API Error Enum
enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
}


