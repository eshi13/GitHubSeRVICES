//
//  SearchViewController.swift
//  GifFollowers
//
//  Created by Eshita Sharma on 23/02/25.
//

import UIKit

class SearchViewController: UIViewController {

    let logoImageView = UIImageView()
    let userNameTextField = GifTextField()
    let callActionButton = GifButton(backgroudColour: .systemGreen, title: "Get followers")
    
    var isUsernameEntered: Bool {
        !userNameTextField.text!.isEmpty
    }
    
    // only gets first time the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureUserNameTextField()
        configureCallActionButton()
        createDismissKeyboard()
    }
    
    //gets called everytime the view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "gh-logo")
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
        
    }
    
    func configureUserNameTextField() {
        view.addSubview(userNameTextField)
        userNameTextField.delegate = self
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
    func configureCallActionButton() {
        view.addSubview(callActionButton)
        callActionButton.addTarget(self, action: #selector(pushFollowersScene), for: .touchUpInside)
        NSLayoutConstraint.activate([
            callActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func createDismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushFollowersScene() {
        guard let username = userNameTextField.text,
              isUsernameEntered
        else { presentGifAlertOnMainThread(title: "Empty Username",
                                           message: "Please enter a username. We want to know who we are looking for.😊",
                                           buttonTitle: "OK")
            return
        }
        let followerListVc = FollowerListViewController()
        followerListVc.username = username
        followerListVc.title = username
        navigationController?.pushViewController(followerListVc, animated: true)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowersScene()
        return true
    }
}
