//
//  FollowerListViewController.swift
//  GifFollowers
//
//  Created by Eshita Sharma on 24/02/25.
//

import UIKit

protocol FollowerListViewControllerDelegate: AnyObject {
    func didRequestFollowers(username: String)
}

class FollowerListViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var username: String!
    var page: Int = 1
    var followers: [Follower] = []
    var filteredFollower: [Follower] = []
    var hasMoreFollowers = true
    var isSearching = false
    
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
        configureSearchController()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                         target: self,
                                         action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self]result in
            
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let followers):

                if followers.count < 100 { self.hasMoreFollowers = false }
                self.followers.append(contentsOf: followers)
                if followers.isEmpty {
                    DispatchQueue.main.async {
                        self.showEmptyState(with: "There are no followers for this user. Go follow them 😃", in: self.view)
                        return
                    }
                }
                self.updateData(on: self.followers)
            case .failure(let error):
                self.presentGifAlertOnMainThread(title: "Bad Stuff Happend", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseId, for: indexPath) as! FollowerCell
            cell.setFollower(follower: follower)
            return cell
        })
    }
    
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    @objc func addButtonTapped() {
        showLoadingView()
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let user):
                let follower = Follower(login: user.login, avatarUrl: user.avatarUrl)
                PersistenceManager.updateWith(favourite: follower, actionType: .add) { [weak self ]error in
                    guard let self = self else { return }
                    guard let error = error else {
                        self.presentGifAlertOnMainThread(title: "Success",
                                                         message: "Hooray user added to favourites.🍾",
                                                         buttonTitle: "Okay")
                        return
                    }
                    self.presentGifAlertOnMainThread(title: "Oops something went wrong",
                                                     message: error.rawValue,
                                                     buttonTitle: "Ok")
                }
            case .failure(let error):
                presentGifAlertOnMainThread(title: "Something went wrong!!",
                                            message: error.rawValue,
                                            buttonTitle: "Ok")
            }
        }
    }
}

extension FollowerListViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > (contentHeight - height) {
            guard hasMoreFollowers  else { return }
            page = page + 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollower : followers
        let follower = activeArray[indexPath.item]
        
        let destinationVC = UserInfoViewController(username: follower.login)
        destinationVC.delegate = self
        let navigationController = UINavigationController(rootViewController: destinationVC)
        present(navigationController, animated: true)
    }
    
}

extension FollowerListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text,
              !filter.isEmpty
        else { return }
        isSearching = true
        filteredFollower = followers.filter({
            $0.login.lowercased().contains(filter.lowercased())
        })
        updateData(on: filteredFollower)
    }
}


extension FollowerListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: self.followers)
    }
}

extension FollowerListViewController: FollowerListViewControllerDelegate {
    func didRequestFollowers(username: String) {
        self.username = username
        title = username
        followers.removeAll()
        filteredFollower.removeAll()
        page = 1
        hasMoreFollowers = true
        updateData(on: followers)
        //collectionView.setContentOffset(.zero, animated: true)
        getFollowers(username: username, page: page)
    }
}
