//
//  FollowerListViewController.swift
//  GifFollowers
//
//  Created by Eshita Sharma on 24/02/25.
//

import UIKit

class FollowerListViewController: UIViewController {
    
    var userName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
