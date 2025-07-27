//
//  CacheManager.swift
//  TransactionTracker
//
//  Created by Subhajit Biswas on 27/07/25.
//

import Foundation

final class CacheManager {
    static let shared = CacheManager()
    private let userDefaults = UserDefaults.standard
    private init() {}
    
    private let defaultCacheDuration: TimeInterval = 5 * 60 // minutes
    
    func save<T: Codable>(data: T, forDataKey dataKey: String, timestampKey: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            userDefaults.set(encoded, forKey: dataKey)
            userDefaults.set(Date(), forKey: timestampKey)
        }
    }
    
    func load<T: Codable>(type: T.Type, forDataKey dataKey: String) -> T? {
        guard let data = userDefaults.data(forKey: dataKey) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
    
    func isCacheValid(forTimestampKey timestampKey: String, duration: TimeInterval? = nil) -> Bool {
        guard let timestamp = userDefaults.object(forKey: timestampKey) as? Date else { return false }
        let validity = duration ?? defaultCacheDuration
        return Date().timeIntervalSince(timestamp) < validity
    }
    
    func clear(dataKey: String, timestampKey: String) {
        userDefaults.removeObject(forKey: dataKey)
        userDefaults.removeObject(forKey: timestampKey)
    }
}
