//
//  FavouriteCell.swift
//  GifFollowers
//
//  Created by Eshita Sharma on 02/03/25.
//

import UIKit

class FavouriteCell: UITableViewCell {
    static let reuseId = "FavouriteCell"
    
    let avatarImage = GifImageView(frame: .zero)
    let userNameLabel = GifTitleLabel(fontSize: 26, textAlignment: .left)
    let padding: CGFloat = 12
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(avatarImage)
        addSubview(userNameLabel)
        
        accessoryType = .disclosureIndicator
        
        NSLayoutConstraint.activate([
            avatarImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            avatarImage.widthAnchor.constraint(equalToConstant: 60),
            avatarImage.heightAnchor.constraint(equalToConstant: 60),
            
            userNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 24),
            userNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            userNameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setFavourite(favourite: Follower) {
        userNameLabel.text = favourite.login
        avatarImage.downloadImage(from: favourite.avatarUrl)
    }
}
