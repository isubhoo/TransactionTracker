//
//  Transaction.swift
//  TransactionTracker
//
//  Created by Subhajit Biswas on 25/07/25.
//

import Foundation

struct Transaction: Codable {
    let transactionDate: String
    let transactionCategory: String
    let transactionID: String
    let status: String
    let amount: String
    let transactionType: String
}
