//
//  GifItemInfoViewController.swift
//  GifFollowers
//
//  Created by Eshita Sharma on 02/03/25.
//

import UIKit

class GifItemInfoViewController: UIViewController {
    
    let stackView = UIStackView()
    let itemInfoView1 = GifItemInfoView(frame: .zero)
    let itemInfoView2 = GifItemInfoView(frame: .zero)
    let button = GifButton()
    
    let padding: CGFloat = 20
    
    var user: User!
    weak var delegate: UserInfoViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundView()
        layoutUI()
        configureStackView()
        configureActionButton()

    }
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureBackgroundView() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
        
    }
    
    private func layoutUI() {
        view.addSubview(stackView)
        view.addSubview(button)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(itemInfoView1)
        stackView.addArrangedSubview(itemInfoView2)
    }
    
    private func configureActionButton() {
        button.addTarget(self, action: #selector(actionButtontapped), for: .touchUpInside)
    }
    
    @objc func actionButtontapped() {
        
    }

}
