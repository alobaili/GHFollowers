//
//  FollowersListViewController.swift
//  GHFollowers
//
//  Created by Abdulaziz AlObaili on 31/01/2020.
//  Copyright © 2020 Abdulaziz AlObaili. All rights reserved.
//

import UIKit

class FollowersListViewController: GFDataLoadingViewController {
    
    enum Section {
        case main
    }
    
    var username: String!
    var followers = [Follower]()
    var filteredFollowers = [Follower]()
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    var isLoadingMoreFollowers = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    let searchController = UISearchController()
    
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCollectionViewCell.self, forCellWithReuseIdentifier: FollowerCollectionViewCell.reuseId)
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = NSLocalizedString("Search for a username", comment: "Placeholder for search bar.")
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.isHidden = true
        navigationItem.searchController = searchController
    }
    
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers = true
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] (result) in
            guard let self = self else { return }
            
            self.dismissLoadingView()
            
            switch result {
                case .success(let followers):
                    self.updateUI(with: followers)
                case .failure(let error):
                    self.presentAlertOnMainThread(
                        title: NSLocalizedString("Bad stuff happened", comment: "Error message title."),
                        message: error.localizedDescription,
                        buttonTitle: NSLocalizedString("OK", comment: "Button: OK.")
                    )
            }
            
            self.isLoadingMoreFollowers = false
        }
    }
    
    func updateUI(with followers: [Follower]) {
        if followers.count < 100 {
            self.hasMoreFollowers = false
        }
        self.followers.append(contentsOf: followers)
        if self.followers.isEmpty {
            let message = NSLocalizedString("No Followers Body", comment: "This user doesn't have any followers. Go follow them 😀")
            DispatchQueue.main.async { self.showEmptyStateView(withMessage: message, in: self.view) }
            return
        }
        DispatchQueue.main.async {
            self.searchController.searchBar.isHidden = false
        }
        self.updateData(on: self.followers)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCollectionViewCell.reuseId, for: indexPath) as! FollowerCollectionViewCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot) }
    }
    
    @objc func addButtonTapped() {
        showLoadingView()
        NetworkManager.shared.getUserInfo(for: username) { [weak self] (result) in
            guard let self = self else { return }
            
            self.dismissLoadingView()
            
            switch result {
                case .success(let user):
                    self.addUserToFavorites(user: user)
                case .failure(let error):
                    self.presentAlertOnMainThread(
                        title: NSLocalizedString("Something went wrong", comment: "Error message title."),
                        message: error.localizedDescription,
                        buttonTitle: NSLocalizedString("OK", comment: "Button: OK.")
                    )
            }
        }
    }
    
    func addUserToFavorites(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        PersistenceManager.updateFavorite(favorite, actionType: .add) { [weak self] (error) in
            guard let self = self else { return }
            
            guard let error = error else {
                self.presentAlertOnMainThread(
                    title: NSLocalizedString("Success!", comment: "Success message title."),
                    message: NSLocalizedString("Success! Body", comment: "You have sucessfully favorited this user 🎉"),
                    buttonTitle: NSLocalizedString("Hooray!", comment: "Celebration button title for success message.")
                )
                return
            }
            
            self.presentAlertOnMainThread(
                title: NSLocalizedString("Something went wrong", comment: "Error message title."),
                message: error.localizedDescription,
                buttonTitle: NSLocalizedString("OK", comment: "Button: OK.")
            )
        }
    }
    

}

// MARK: - Collection view delegate

extension FollowersListViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let destinationViewController = UserInfoViewController()
        destinationViewController.username = follower.login
        destinationViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: destinationViewController)
        present(navigationController, animated: true)
    }
    
    
}

// MARK: - Search delegates

extension FollowersListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
    
    
}

// MARK: - UserInfoViewControllerDelegate

extension FollowersListViewController: UserInfoViewControllerDelegate {
    
    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        page = 1
        
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
    }
    
    
}
