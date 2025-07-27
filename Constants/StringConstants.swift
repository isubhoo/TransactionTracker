//
//  StringConstants.swift
//  TransactionTracker
//
//  Created by Subhajit Biswas on 25/07/25.
//

import Foundation

enum StringConstants {
    static let empty = ""
    
    enum Home {
        static let viewTitle = "Home"
        static let viewReportButtonTitle = "View Transaction Report"
    }
    
    enum TransactionReport {
        static let creator = "Transaction Report"
        static let author = "OmniCard"
        static let sectionTitle = "Transaction Report : 01-Jan-2025 to 01-Apr-2025"
        static let pageTitlePrefix = "Page"
        static let tableHeaders = ["Date", "Narration", "Transaction ID", "Status", "Credit", "Debit"]
        static let userDetails = [
            "Name: bbb bbbb",
            "Email: bbb@tmaul.com",
            "Mobile Number: 7456000050",
            "Card Number: **** **** **** 6217",
            "Card Type: PERSONAL",
            "Address: Delhi"
        ]
    }
    
    enum TransactionTableViewCell {
        static let transactionTableViewCellIdentifier = "TransactionTableViewCell"
        static let arrowUpRight = "arrow.up.right"
        static let arrowDownLeft = "arrow.down.left"
        static let debit = "DEBIT"
        static let rupeeSymbol = "₹"
        static let initCoderError = "init(coder:) has not been implemented"
    }
    
    enum Report {
        static let viewTitle = "Transactions"
        static let generatePDFButtonTitle = "Generate PDF"
        static let toastCachedDataMessage = "Data loaded from cache"
        static let errorAlertTitle = "Error"
        static let errorAlertButton = "OK"
        static let pdfFileName = "TransactionReport.pdf"
    }
    
    enum ReportViewModel {
        static let cachedTransactionsKey = "cachedTransactions"
        static let cacheTimestampKey = "cacheTimestamp"
        static let pdfFileName = "TransactionReport.pdf"
        static let errorInvalidURL = "Invalid URL"
        static let errorRequestFailedPrefix = "Request failed: "
        static let errorInvalidResponse = "Invalid response from server"
        static let errorDecodingPrefix = "Failed to decode data: "
    }
}

