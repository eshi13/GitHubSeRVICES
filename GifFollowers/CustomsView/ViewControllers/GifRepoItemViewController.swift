//
//  GifRepoItemViewController.swift
//  GifFollowers
//
//  Created by Eshita Sharma on 02/03/25.
//

import UIKit

class GifRepoItemViewController: GifItemInfoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        itemInfoView1.setItemInfoType(infoType: .repos, withCount: user.publicRepos)
        itemInfoView2.setItemInfoType(infoType: .gists, withCount: user.publicGists)
        button.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
    
    override func actionButtontapped() {
        delegate.didTapGitHubProfile(user: user)
    }
}
