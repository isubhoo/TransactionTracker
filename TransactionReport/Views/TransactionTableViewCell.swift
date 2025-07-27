//
//  TransactionTableViewCell.swift
//  TransactionTracker
//
//  Created by Subhajit Biswas on 27/07/25.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    static let identifier = StringConstants.TransactionTableViewCell.transactionTableViewCellIdentifier

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .right
        return label
    }()
    
    // Stack Views
    private let infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(infoStack)
        contentView.addSubview(amountLabel)
        
        infoStack.addArrangedSubview(categoryLabel)
        infoStack.addArrangedSubview(dateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = 16
        iconImageView.frame = CGRect(x: padding, y: 10, width: 40, height: 40)
        infoStack.frame = CGRect(x: iconImageView.frame.maxX + 12, y: 10, width: contentView.frame.width - 140, height: 40)
        amountLabel.frame = CGRect(x: contentView.frame.width - 110, y: 10, width: 90, height: 40)
    }

    func configure(with transaction: Transaction) {
        categoryLabel.text = transaction.transactionCategory
        dateLabel.text = transaction.transactionDate.formattedDateForPDF()

        let isDebit = transaction.transactionType.uppercased() == StringConstants.TransactionTableViewCell.debit
        
        // Amount Label Setup
        amountLabel.textColor = isDebit ? .systemRed : .systemGreen
        amountLabel.text =
        (isDebit ? "-\(StringConstants.TransactionTableViewCell.rupeeSymbol)" : "+\(StringConstants.TransactionTableViewCell.rupeeSymbol)") + transaction.amount


        // SF Symbol Name
        let arrowImageName = isDebit ? StringConstants.TransactionTableViewCell.arrowUpRight :
        StringConstants.TransactionTableViewCell.arrowDownLeft

        // Set Image with Template Rendering Mode
        let image = UIImage(systemName: arrowImageName)?.withRenderingMode(.alwaysTemplate)
        iconImageView.image = image

        // Tint and Background Color
        iconImageView.tintColor = isDebit ? .systemRed : .systemGreen
        iconImageView.backgroundColor = isDebit
            ? UIColor.systemRed.withAlphaComponent(0.1)
            : UIColor.systemGreen.withAlphaComponent(0.1)
    }
}

