//
//  UIViewController+Ext.swift
//  GifFollowers
//
//  Created by Eshita Sharma on 25/02/25.
//

import UIKit

extension UIViewController {
    func presentGifAlertOnMainThread(title: String,
                                     message: String,
                                     buttonTitle: String) {
        
        DispatchQueue.main.async {
            let alertVC = GifAlertViewController(alertTitle: title,
                                                 message: message,
                                                 buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
        
    }
}
