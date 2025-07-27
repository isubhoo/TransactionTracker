//
//  ReportViewModel.swift
//  TransactionTracker
//
//  Created by Subhajit Biswas on 25/07/25.
//

import Foundation

enum TransactionDataSource {
    case cached
    case live
}

protocol ReportViewModelProtocol {
    var transactions: [Transaction] { get }
    var onDataUpdate: ((TransactionDataSource) -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    var onPDFGenerated: ((Result<Data, Error>) -> Void)? { get set }
    func fetchTransactions(forceRefresh: Bool)
}

final class ReportViewModel: ReportViewModelProtocol {
    // MARK: - Dependencies
    private let apiService: APIService
    private let endpoint: APIEndpoint
    var onPDFGenerated: ((Result<Data, Error>) -> Void)?
    
    // MARK: - State
    private(set) var transactions: [Transaction] = []
    var onDataUpdate: ((TransactionDataSource) -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Init
    init(apiService: APIService) {
        self.apiService = apiService
        self.endpoint = APIEndpoint(
            path: "/history",
            method: .get,
            headers: nil,
            queryItems: nil,
            body: nil
        )
    }
    
    // MARK: - Fetch Data
    func fetchTransactions(forceRefresh: Bool) {
        let dataKey = StringConstants.ReportViewModel.cachedTransactionsKey
        let timestampKey = StringConstants.ReportViewModel.cacheTimestampKey
        
        if CacheManager.shared.isCacheValid(forTimestampKey: timestampKey, duration: 300), !forceRefresh,
           let cachedData: [Transaction] = CacheManager.shared.load(type: [Transaction].self,
                                                                    forDataKey: dataKey)  {
            self.transactions = cachedData
            self.onDataUpdate?(.cached)
            
//        } else {
//            apiService.request(endpoint: endpoint) { [weak self] (result: Result<[Transaction], APIError>) in
//                guard let self = self else { return }
//                switch result {
//                case .success(let response):
//                    self.transactions = response
//                    CacheManager.shared.save(data: transactions,forDataKey: dataKey,
//                                             timestampKey: timestampKey)
//                    self.onDataUpdate?(.live)
//                case .failure(let error):
//                    self.onError?(self.mapError(error))
//                }
//            }
//        }
            
        } else {
            let dummyTransactions = [
                Transaction(
                    transactionDate: "2025-07-24T15:14:58.332+0000",
                    transactionCategory: "Pay to Friend",
                    transactionID: "TRX24072025204458329C47",
                    status: "COMPLETED",
                    amount: "500",
                    transactionType: "CREDIT"
                ),
                Transaction(
                    transactionDate: "2025-07-24T15:14:58.332+0000",
                    transactionCategory: "Pay to Friend",
                    transactionID: "TRX24072025204458329C47",
                    status: "COMPLETED",
                    amount: "50",
                    transactionType: "CREDIT"
                ),
                Transaction(
                    transactionDate: "2025-07-24T15:14:58.332+0000",
                    transactionCategory: "Pay to Friend",
                    transactionID: "TRX24072025204458329C47",
                    status: "COMPLETED",
                    amount: "50",
                    transactionType: "CREDIT"
                ),
                Transaction(
                    transactionDate: "2025-07-24T15:14:58.332+0000",
                    transactionCategory: "Pay to Friend",
                    transactionID: "TRX24072025204458329C47",
                    status: "COMPLETED",
                    amount: "50",
                    transactionType: "CREDIT"
                ),
                Transaction(
                    transactionDate: "2025-07-24T15:14:58.332+0000",
                    transactionCategory: "Pay to Friend",
                    transactionID: "TRX24072025204458329C47",
                    status: "COMPLETED",
                    amount: "50",
                    transactionType: "CREDIT"
                ),
                Transaction(
                    transactionDate: "2025-07-24T15:14:58.332+0000",
                    transactionCategory: "Pay to Friend",
                    transactionID: "TRX24072025204458329C47",
                    status: "COMPLETED",
                    amount: "50",
                    transactionType: "CREDIT"
                ),
                Transaction(
                    transactionDate: "2025-07-24T15:14:58.332+0000",
                    transactionCategory: "Pay to Friend",
                    transactionID: "TRX24072025204458329C47",
                    status: "COMPLETED",
                    amount: "50",
                    transactionType: "DEBIT"
                ),
                Transaction(
                    transactionDate: "2025-07-24T15:14:58.332+0000",
                    transactionCategory: "Pay to Friend",
                    transactionID: "TRX24072025204458329C47",
                    status: "COMPLETED",
                    amount: "50",
                    transactionType: "CREDIT"
                ),
                Transaction(
                    transactionDate: "2025-07-24T15:14:58.332+0000",
                    transactionCategory: "Pay to Friend",
                    transactionID: "TRX24072025204458329C47",
                    status: "COMPLETED",
                    amount: "50",
                    transactionType: "DEBIT"
                ),
                Transaction(
                    transactionDate: "2025-07-24T15:14:58.332+0000",
                    transactionCategory: "Pay to Friend",
                    transactionID: "TRX24072025204458329C47",
                    status: "COMPLETED",
                    amount: "50",
                    transactionType: "CREDIT"
                ),
                Transaction(
                    transactionDate: "2025-07-24T15:14:58.332+0000",
                    transactionCategory: "Pay to Friend",
                    transactionID: "TRX24072025204458329C47",
                    status: "COMPLETED",
                    amount: "50",
                    transactionType: "DEBIT"
                ),
                Transaction(
                    transactionDate: "2025-07-24T15:14:58.332+0000",
                    transactionCategory: "Pay to Friend",
                    transactionID: "TRX24072025204458329C47",
                    status: "COMPLETED",
                    amount: "50",
                    transactionType: "CREDIT"
                ),
                Transaction(
                    transactionDate: "2025-07-24T15:14:58.332+0000",
                    transactionCategory: "Pay to Friend",
                    transactionID: "TRX24072025204458329C47",
                    status: "COMPLETED",
                    amount: "50",
                    transactionType: "DEBIT"
                ),
                Transaction(
                    transactionDate: "2025-07-24T15:14:58.332+0000",
                    transactionCategory: "Pay to Friend",
                    transactionID: "TRX24072025204458329C47",
                    status: "COMPLETED",
                    amount: "50",
                    transactionType: "CREDIT"
                ),
                Transaction(
                    transactionDate: "2025-07-24T15:14:58.332+0000",
                    transactionCategory: "Pay to Friend",
                    transactionID: "TRX24072025204458329C47",
                    status: "COMPLETED",
                    amount: "50",
                    transactionType: "DEBIT"
                ),
                Transaction(
                    transactionDate: "2025-07-24T15:14:58.332+0000",
                    transactionCategory: "Pay to Friend",
                    transactionID: "TRX24072025204458329C47",
                    status: "COMPLETED",
                    amount: "50",
                    transactionType: "CREDIT"
                ),
                Transaction(
                    transactionDate: "2025-07-24T15:14:58.332+0000",
                    transactionCategory: "Pay to Friend",
                    transactionID: "TRX24072025204458329C47",
                    status: "COMPLETED",
                    amount: "50",
                    transactionType: "DEBIT"
                ),
                Transaction(
                    transactionDate: "2025-07-24T15:14:58.332+0000",
                    transactionCategory: "Pay to Friend",
                    transactionID: "TRX24072025204458329C47",
                    status: "COMPLETED",
                    amount: "50",
                    transactionType: "CREDIT"
                ),
                Transaction(
                    transactionDate: "2025-07-24T15:14:58.332+0000",
                    transactionCategory: "Pay to Friend",
                    transactionID: "TRX24072025204458329C47",
                    status: "COMPLETED",
                    amount: "50",
                    transactionType: "DEBIT"
                ),
                Transaction(
                    transactionDate: "2025-07-24T15:14:58.332+0000",
                    transactionCategory: "Pay to Friend",
                    transactionID: "TRX24072025204458329C47",
                    status: "COMPLETED",
                    amount: "50",
                    transactionType: "CREDIT"
                ),
                Transaction(
                    transactionDate: "2025-07-24T15:14:58.332+0000",
                    transactionCategory: "Pay to Friend",
                    transactionID: "TRX24072025204458329C47",
                    status: "COMPLETED",
                    amount: "50",
                    transactionType: "CREDIT"
                )
            ]
            self.transactions = dummyTransactions
            CacheManager.shared.save(data: transactions,forDataKey: dataKey, timestampKey: timestampKey)
            self.onDataUpdate?(.live)
        }
    }
    
    private func mapError(_ error: APIError) -> String {
        switch error {
        case .invalidURL:
            return StringConstants.ReportViewModel.errorInvalidURL
        case .requestFailed(let err):
            return StringConstants.ReportViewModel.errorRequestFailedPrefix + err.localizedDescription
        case .invalidResponse:
            return StringConstants.ReportViewModel.errorInvalidResponse
        case .decodingError(let err):
            return StringConstants.ReportViewModel.errorDecodingPrefix + err.localizedDescription
        }
    }
    
    func generatePDFReport() {
        guard !transactions.isEmpty else {
            onPDFGenerated?(.failure(PDFGenerationError.noTransactions))
            return
        }
        
        let pdfGenerator = TransactionReportPDFGenerator()
        let pdfData = pdfGenerator.generatePDF(with: transactions)
        onPDFGenerated?(.success(pdfData))
    }
}

enum PDFGenerationError: Error {
    case noTransactions
}
