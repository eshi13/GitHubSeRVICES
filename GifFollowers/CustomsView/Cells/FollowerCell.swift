//
//  FollowerCell.swift
//  GifFollowers
//
//  Created by Eshita Sharma on 28/02/25.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    static let reuseId = "FollowerCell"
    
    let avatarImage = GifImageView(frame: .zero)
    let userNameLabel = GifTitleLabel(fontSize: 16, textAlignment: .center)
    let padding: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(avatarImage)
        addSubview(userNameLabel)
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            avatarImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            avatarImage.heightAnchor.constraint(equalTo: avatarImage.widthAnchor),
            
            userNameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 12),
            userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            userNameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func setFollower(follower: Follower) {
        userNameLabel.text = follower.login
        avatarImage.downloadImage(from: follower.avatarUrl)
    }
}
