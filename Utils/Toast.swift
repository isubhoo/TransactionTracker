//
//  Toast.swift
//  TransactionTracker
//
//  Created by Subhajit Biswas on 27/07/25.
//

import UIKit

final class Toast {
    
    static func show(message: String, in view: UIView, duration: TimeInterval = 4.0) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = .white
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true

        let padding: CGFloat = 20
        let width = view.frame.size.width - 2 * padding
        let height: CGFloat = 36
        toastLabel.frame = CGRect(x: padding, y: view.frame.size.height - 140, width: width, height: height)

        view.addSubview(toastLabel)

        UIView.animate(withDuration: duration, delay: 0.2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}

