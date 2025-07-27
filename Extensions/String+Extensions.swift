//
//  String+Extensions.swift
//  TransactionTracker
//
//  Created by Subhajit Biswas on 27/07/25.
//

import Foundation

extension String {
    func formattedDateForPDF() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM yyyy, hh:mm a"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let date = inputFormatter.date(from: self) {
            return outputFormatter.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
}
