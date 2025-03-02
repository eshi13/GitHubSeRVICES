//
//  GifImageView.swift
//  GifFollowers
//
//  Created by Eshita Sharma on 28/02/25.
//

import UIKit

class GifImageView: UIImageView {
    
    let cache = NetworkManager.shared.cache
    
    let placeholderImage = UIImage(named: "avatar-placeholder")!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    func downloadImage(from urlString: String) {
        
        if let image = cache.object(forKey: NSString(string: urlString)) {
            self.image = image
            return
        }
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error)  in
            if error != nil { return }
            guard let reponse = response as? HTTPURLResponse,
                  reponse.statusCode == 200 else { return }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            self.cache.setObject(image, forKey: NSString(string: urlString))
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }

}
