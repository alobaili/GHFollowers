//
//  FavoritesListViewController.swift
//  GHFollowers
//
//  Created by Abdulaziz AlObaili on 30/01/2020.
//  Copyright © 2020 Abdulaziz AlObaili. All rights reserved.
//

import UIKit

class FavoritesListViewController: GFDataLoadingViewController {
    
    let tableView = UITableView()
    var favorites = [Follower]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
		
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getFavorites()
    }

    override func updateContentUnavailableConfiguration(
        using state: UIContentUnavailableConfigurationState
    ) {
        super.updateContentUnavailableConfiguration(using: state)

        if favorites.isEmpty {
            var configuration = UIContentUnavailableConfiguration.empty()
            configuration.image = .init(systemName: "star")
            configuration.text = String(localized: "No Favourites", comment: "Empty state message.")
            configuration.secondaryText = String(
                localized: "Add a favorite on the follower list screen",
                comment: "Empty state secondary message."
            )
            contentUnavailableConfiguration = configuration
        } else {
            contentUnavailableConfiguration = nil
        }
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = NSLocalizedString("Favorites", comment: "Faforites screen title (appears in the navigation bar).")
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExtraCells()

        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.reuseId)
    }
    
    func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] (result) in
            guard let self else { return }
            
            switch result {
                case .success(let favorites):
                    self.updateUI(with: favorites)
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.presentAlert(
                            title: NSLocalizedString("Something went wrong", comment: "Error message title."),
                            message: error.localizedDescription,
                            buttonTitle: NSLocalizedString("OK", comment: "Button: OK.")
                        )
                    }
            }
        }
    }

    func updateUI(with favorites: [Follower]) {
        self.favorites = favorites
        setNeedsUpdateContentUnavailableConfiguration()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.view.bringSubviewToFront(self.tableView)
        }
    }
	

}

extension FavoritesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.reuseId) as! FavoriteTableViewCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destinationViewController = FollowersListViewController(username: favorite.login)
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        PersistenceManager.updateFavorite(
            favorites[indexPath.row],
            actionType: .remove
        ) { [weak self] (error) in
            guard let self else { return }
            
            guard let error else {
                self.favorites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                setNeedsUpdateContentUnavailableConfiguration()

                return
            }

            DispatchQueue.main.async {
                self.presentAlert(
                    title: NSLocalizedString("Unable to remove", comment: "Error message title for removing favorite."),
                    message: error.localizedDescription,
                    buttonTitle: NSLocalizedString("OK", comment: "Button: OK.")
                )
            }
        }
    }
    
    
}
