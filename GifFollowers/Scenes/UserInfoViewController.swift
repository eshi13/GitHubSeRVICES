//
//  UserInfoViewController.swift
//  GifFollowers
//
//  Created by Eshita Sharma on 01/03/25.
//

import UIKit
import SafariServices

protocol UserInfoViewControllerDelegate: AnyObject {
    func didTapGitHubProfile(user: User)
    func didTapGetFollowers(user: User)
}

class UserInfoViewController: UIViewController {
    
    let headerView = UIView()
    let itemView1 = UIView()
    let itemView2 = UIView()
    var itemViews: [UIView] = []
    let dateLabel = GifBodyLabel(textAlignment: .center)

    var username: String!
    weak var delegate: FollowerListViewControllerDelegate!
    let padding: CGFloat = 20
    let itemHeight: CGFloat = 140
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureViewController()
        layoutUI()
        getUserData()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    func getUserData() {
        NetworkManager.shared.getUserInfo(for: self.username) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.configureUIElements(user: user)
                }
            case .failure(let error):
                presentGifAlertOnMainThread(title: "Oops something went wrong",
                                            message: error.rawValue,
                                            buttonTitle: "OK")
            }
        }
    }
    
    func configureUIElements(user: User) {
        self.add(childVC: GifUserInfoHeaderViewController(user: user), to: self.headerView)
        
        let repoItemVc = GifRepoItemViewController(user: user)
        repoItemVc.delegate = self
        self.add(childVC: repoItemVc, to: self.itemView1)
        
        let followerItemVC = GifFollowerItemViewController(user: user)
        followerItemVC.delegate = self
        self.add(childVC: followerItemVC, to: self.itemView2)
        
        
        self.dateLabel.text = "GitHub since: \(user.createdAt.convertToDisplayFormat())"
    }
    
    func layoutUI() {
        itemViews = [headerView, itemView1, itemView2, dateLabel]

        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemView1.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemView1.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemView2.topAnchor.constraint(equalTo: itemView1.bottomAnchor, constant: padding),
            itemView2.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemView2.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}

extension UserInfoViewController: UserInfoViewControllerDelegate {
    func didTapGitHubProfile(user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            
            self.presentGifAlertOnMainThread(title: "Oops something went wrong",
                                             message: "User may not be a valid user anymore",
                                             buttonTitle: "OK")
            return
        }
        presentSafariVC(withUrl: url)
    }
    
    func didTapGetFollowers(user: User) {
        guard user.followers != 0 else {
            presentGifAlertOnMainThread(title: "User has no followers",
                                        message: "Go follow this user..😄",
                                        buttonTitle: "OK")
            return
        }
        delegate.didRequestFollowers(username: user.login)
        dismissVC()
    }
    
    
}
