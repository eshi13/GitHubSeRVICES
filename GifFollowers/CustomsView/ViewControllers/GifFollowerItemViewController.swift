//
//  GifFollowerItemViewController.swift
//  GifFollowers
//
//  Created by Eshita Sharma on 02/03/25.
//

import UIKit

class GifFollowerItemViewController: GifItemInfoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        itemInfoView1.setItemInfoType(infoType: .followers, withCount: user.followers)
        itemInfoView2.setItemInfoType(infoType: .following, withCount: user.following)
        button.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtontapped() {
        delegate.didTapGetFollowers(user: user)
    }
}
