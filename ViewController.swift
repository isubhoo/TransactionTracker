//
//  ViewController.swift
//  TransactionTracker
//
//  Created by Subhajit Biswas on 25/07/25.
//

import UIKit

class ViewController: UIViewController {
    
    // Lazy button creation
    private lazy var openReportButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(StringConstants.Home.viewReportButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemTeal
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 6
        button.addTarget(self, action: #selector(openReportTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = StringConstants.Home.viewTitle
        setupButton()
    }

    private func setupButton() {
        view.addSubview(openReportButton)
        openReportButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            openReportButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openReportButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            openReportButton.widthAnchor.constraint(equalToConstant: 260),
            openReportButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func openReportTapped() {
        let apiService = APIClient(baseURL: "https://iosserver.free.beeceptor.com")
        let viewModel = ReportViewModel(apiService: apiService)
        let reportVC = ReportViewController(viewModel: viewModel)
        navigationItem.backButtonTitle = StringConstants.Home.viewTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.pushViewController(reportVC, animated: true)
    }
}

