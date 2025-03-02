//
//  FavouritesListViewController.swift
//  GifFollowers
//
//  Created by Eshita Sharma on 23/02/25.
//

import UIKit

class FavouritesListViewController: UIViewController {
    
    let tableView = UITableView()
    var favourites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureViewController()
        configureTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getFavourites()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func getFavourites() {
        PersistenceManager.retrieveFavourite {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let follower):
                if follower.isEmpty {
                    showEmptyState(with: "Oops there are no favourites ??", in: self.view)
                } else {
                    self.favourites = follower
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.bringSubviewToFront(self.tableView)
                    }
                }
            case .failure(let error):
                presentGifAlertOnMainThread(title: "Not getting favourites",
                                            message: error.rawValue,
                                            buttonTitle: "OK")
            }
        }
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 80
        tableView.register(FavouriteCell.self, forCellReuseIdentifier: FavouriteCell.reuseId)
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension FavouritesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteCell.reuseId, for: indexPath) as! FavouriteCell
        let favourite = favourites[indexPath.row]
        cell.setFavourite(favourite: favourite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favourite = favourites[indexPath.row]
        let destVC = FollowerListViewController()
        destVC.username = favourite.login
        destVC.title = favourite.login
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)  {
        guard editingStyle == .delete else { return }
        let favourite = favourites[indexPath.row]
        favourites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        PersistenceManager.updateWith(favourite: favourite, actionType: .remove) { error in
            guard let error = error else { return }
            self.presentGifAlertOnMainThread(title: "Something went wrong",
                                        message: error.rawValue,
                                        buttonTitle: "OK")
        }
    }
}
