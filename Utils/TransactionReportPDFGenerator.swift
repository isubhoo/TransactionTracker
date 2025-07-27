//
// TransactionReportPDFGenerator.swift
//  TransactionTracker
//
//  Created by Subhajit Biswas on 25/07/25.
//

import UIKit
import PDFKit

final class TransactionReportPDFGenerator {

    private let logoImage = UIImage(named: "xyz_bank")
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd MMM yyyy, hh:mm a"
        return df
    }()

    let rowFont = UIFont.systemFont(ofSize: 10)

    let topMargin: CGFloat = 40
    let sideMargin: CGFloat = 40
    let bottomMargin: CGFloat = 40
    var yOffset: CGFloat = 225

    func generatePDF(with transactions: [Transaction]) -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: StringConstants.TransactionReport.creator,
            kCGPDFContextAuthor: "OmniCard"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 595.2
        let pageHeight = 841.8
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        var pageNumber = 1

        let data = renderer.pdfData { context in
            context.beginPage()
            drawPageNumber(pageNumber, in: context, pageRect: pageRect)

            var yPosition: CGFloat = topMargin
            let usableWidth = pageRect.width - (sideMargin * 2)

            // MARK: - User Info & Logo
            let userDetails = StringConstants.TransactionReport.userDetails
            let userInfoHeight: CGFloat = CGFloat(userDetails.count) * 20

            if let logo = logoImage {
                let logoWidth: CGFloat = 110
                let logoHeight: CGFloat = 40
                let logoX = pageRect.width - sideMargin - logoWidth
                let logoY = yPosition
                let logoRect = CGRect(x: logoX, y: logoY, width: logoWidth, height: logoHeight)
                logo.draw(in: logoRect)
            }

            for (index, detail) in userDetails.enumerated() {
                let detailY = yPosition + CGFloat(index) * 20
                drawText(detail, at: CGPoint(x: sideMargin, y: detailY), font: UIFont.systemFont(ofSize: 12))
            }

            yPosition += max(userInfoHeight, 50) + 10

            drawText(StringConstants.TransactionReport.sectionTitle, at: CGPoint(x: sideMargin, y: yPosition), font: UIFont.boldSystemFont(ofSize: 13))
            yPosition += 25

            // MARK: - Table Header
            let tableHeaders = StringConstants.TransactionReport.tableHeaders
            let originalColumnWidths: [CGFloat] = [90, 90, 130, 80, 90, 90]
            let totalOriginalWidth = originalColumnWidths.reduce(0, +)
            let columnWidths = originalColumnWidths.map {
                $0 * ((pageRect.width - sideMargin * 2) / totalOriginalWidth)
            }

            drawTableRow(headers: tableHeaders, values: nil, yPosition: &yPosition, columnWidths: columnWidths, isHeader: true)

            // MARK: - Table Rows
            for txn in transactions {
                let date = txn.transactionDate.formattedDateForPDF()
                let narration = txn.transactionCategory
                let txnID = txn.transactionID
                let status = txn.status
                let credit =
                txn.transactionType.uppercased() == "CREDIT" ? String(txn.amount) : StringConstants.empty
                let debit =
                txn.transactionType.uppercased() == "DEBIT" ? String(txn.amount) : StringConstants.empty

                let values = [date, narration, txnID, status, credit, debit]

                // Calculate row height
                var heights: [CGFloat] = []
                for (i, value) in values.enumerated() {
                    let width = columnWidths[i]
                    let boundingBox = value.boundingRect(
                        with: CGSize(width: width, height: .infinity),
                        options: .usesLineFragmentOrigin,
                        attributes: [.font: rowFont],
                        context: nil
                    )
                    heights.append(boundingBox.height + 10)
                }

                let rowHeight = heights.max() ?? 30

                // Page break if needed
                if yOffset + rowHeight > pageHeight - bottomMargin {
                    context.beginPage()
                    pageNumber += 1
                    drawPageNumber(pageNumber, in: context, pageRect: pageRect)
                    yOffset = topMargin

                    // Re-draw table header on new page
                    drawTableRow(headers: tableHeaders, values: nil, yPosition: &yOffset, columnWidths: columnWidths, isHeader: true)
                }

                // Draw row
                var xOffset = sideMargin
                for (i, value) in values.enumerated() {
                    let rect = CGRect(x: xOffset, y: yOffset, width: columnWidths[i], height: rowHeight)
                    let cgContext = context.cgContext
                    cgContext.setLineWidth(1)
                    cgContext.setStrokeColor(UIColor.black.cgColor)
                    cgContext.stroke(rect)

                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineBreakMode = .byWordWrapping
                    paragraphStyle.alignment = .center

                    let attributes: [NSAttributedString.Key: Any] = [
                        .font: rowFont,
                        .paragraphStyle: paragraphStyle
                    ]

                    value.draw(in: rect.insetBy(dx: 5, dy: 5), withAttributes: attributes)

                    xOffset += columnWidths[i]
                }

                yOffset += rowHeight
            }
        }

        return data
    }

    // MARK: - Draw Text
    private func drawText(_ text: String, at point: CGPoint, font: UIFont, color: UIColor = .black) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color
        ]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        attributedText.draw(at: point)
    }

    // MARK: - Draw Page Number
    private func drawPageNumber(_ page: Int, in context: UIGraphicsPDFRendererContext, pageRect: CGRect) {
        let pageNumberText = "\(StringConstants.TransactionReport.pageTitlePrefix) \(page)"
        let font = UIFont.systemFont(ofSize: 10)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let textSize = pageNumberText.size(withAttributes: attributes)
        let x = (pageRect.width - textSize.width) / 2
        let y = pageRect.height - bottomMargin + 10
        pageNumberText.draw(at: CGPoint(x: x, y: y), withAttributes: attributes)
    }

    // MARK: - Draw Table Row
    private func drawTableRow(headers: [String]?, values: [String]?, yPosition: inout CGFloat, columnWidths: [CGFloat], isHeader: Bool) {
        let height: CGFloat = 30
        var currentX = sideMargin

        for (index, width) in columnWidths.enumerated() {
            let rect = CGRect(x: currentX, y: yPosition, width: width, height: height)
            let context = UIGraphicsGetCurrentContext()
            context?.setLineWidth(0.5)
            context?.stroke(rect)

            if isHeader, let headers = headers {
                UIColor.darkGray.setFill()
                context?.fill(rect)

                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center

                let headerAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 11),
                    .foregroundColor: UIColor.white,
                    .paragraphStyle: paragraphStyle
                ]

                let headerRect = rect.insetBy(dx: 5, dy: 8)
                headers[index].draw(in: headerRect, withAttributes: headerAttributes)
            } else if let values = values {
                drawText(values[index], at: CGPoint(x: currentX + 5, y: yPosition + 8), font: .systemFont(ofSize: 11))
            }

            currentX += width
        }

        yPosition += height
    }
}
