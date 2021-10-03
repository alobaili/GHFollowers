//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Abdulaziz AlObaili on 31/01/2020.
//  Copyright © 2020 Abdulaziz AlObaili. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
    func presentAlert(title: String, message: String, buttonTitle: String) {
        let alertViewController = GFAlertViewController(alertTitle: title, message: message, buttonTitle: buttonTitle)
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        present(alertViewController, animated: true)
    }

    func presentDefaultAlert() {
        let title = NSLocalizedString("Something went wrong", comment: "default error title")
        let message = NSLocalizedString(
            "We were unable to complete your task at this time; Please try again.",
            comment: "default error message"
        )
        let buttonTitle = NSLocalizedString("OK", comment: "default error button title")

        let alertViewController = GFAlertViewController(
            alertTitle: title,
            message: message,
            buttonTitle: buttonTitle
        )
        
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        present(alertViewController, animated: true)
    }
    
    func presentSafariViewController(with url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = .systemGreen
        present(safariViewController, animated: true)
    }
}
