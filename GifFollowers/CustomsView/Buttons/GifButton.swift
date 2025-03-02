//
//  GifButton.swift
//  GifFollowers
//
//  Created by Eshita Sharma on 23/02/25.
//

import UIKit

class GifButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Custom code
        configure()
        
    }
    
    init(backgroudColour: UIColor,
         title: String) {
        super.init(frame: .zero)
        self.backgroundColor = backgroudColour
        self.setTitle(title, for: .normal)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
}
