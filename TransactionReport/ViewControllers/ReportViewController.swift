//
//  ReportViewController.swift
//  TransactionTracker
//
//  Created by Subhajit Biswas on 25/07/25.
//

import UIKit

final class ReportViewController: UIViewController {
    // MARK: - UI Elements
    private let tableView = UITableView()
    private let generatePDFButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    // MARK: - ViewModel
    private var viewModel: ReportViewModelProtocol
    
    // MARK: - Init
    init(viewModel: ReportViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        activityIndicator.startAnimating()
        viewModel.fetchTransactions(forceRefresh: false)
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = StringConstants.Report.viewTitle
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .systemBackground
        
        // Add table view
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        // Add generatePDFButton
        generatePDFButton.setTitle(StringConstants.Report.generatePDFButtonTitle, for: .normal)
        generatePDFButton.backgroundColor = UIColor.systemTeal
        generatePDFButton.setTitleColor(.white, for: .normal)
        generatePDFButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        // UIFont.boldSystemFont(ofSize: 16)
        generatePDFButton.layer.cornerRadius = 12
        generatePDFButton.addTarget(self, action: #selector(generatePDFTapped), for: .touchUpInside)
        view.addSubview(generatePDFButton)
        generatePDFButton.translatesAutoresizingMaskIntoConstraints = false

        // Add activity indicator
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints
        NSLayoutConstraint.activate([
            // Generate button at bottom
            generatePDFButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            generatePDFButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            generatePDFButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                      constant: -16),
            generatePDFButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Table view above the button
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: generatePDFButton.topAnchor, constant: -12),

            // Activity indicator center
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func bindViewModel() {
        viewModel.onDataUpdate = { [weak self] source in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
                switch source {
                case .cached:
                    self?.showToast(message: StringConstants.Report.toastCachedDataMessage)
                case .live:
                    ()
                }
            }
        }
        
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.showErrorAlert(message)
            }
        }
        
        viewModel.onPDFGenerated = { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let pdfData):
                    let pdfURL = FileManager.default.temporaryDirectory.appendingPathComponent(
                        StringConstants.Report.pdfFileName)
                    do {
                        try pdfData.write(to: pdfURL)
                        print("PDF saved to: \(pdfURL)")
                        let activityVC = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
                        self?.present(activityVC, animated: true)
                    } catch {
                        print("Failed to write PDF: \(error)")
                    }
                case .failure(let error):
                    print("Failed to generate PDF: \(error)")
                    // Optionally show alert to user
                }
            }
        }
    }
    
    private func showErrorAlert(_ message: String) {
        let alert =
        UIAlertController(title: StringConstants.Report.errorAlertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringConstants.Report.errorAlertButton, style: .default))
        present(alert, animated: true)
    }
    
    @objc private func generatePDFTapped() {
        print("Generate PDF tapped")
        let pdfGenerator = TransactionReportPDFGenerator()
        let pdfData = pdfGenerator.generatePDF(with: viewModel.transactions)
        
        // Save or share the PDF
        let pdfURL =
        FileManager.default.temporaryDirectory.appendingPathComponent(StringConstants.Report.pdfFileName)

        do {
            try pdfData.write(to: pdfURL)
            print("PDF saved to: \(pdfURL)")
            
            let activityVC = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
            present(activityVC, animated: true)
        } catch {
            print("Failed to write PDF: \(error)")
        }
    }
    
    private func showToast(message: String) {
        Toast.show(message: StringConstants.Report.toastCachedDataMessage, in: self.view)
    }
    
    @objc private func handleRefresh() {
        viewModel.fetchTransactions(forceRefresh: true)
    }
}

// MARK: - UITableViewDataSource
extension ReportViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as? TransactionTableViewCell else {
            return UITableViewCell()
        }
        let transaction = viewModel.transactions[indexPath.row]
        cell.configure(with: transaction)
        return cell
    }
}
