//
//  GFTabBarController.swift
//  GHFollowers
//
//  Created by Abdulaziz AlObaili on 03/02/2020.
//  Copyright © 2020 Abdulaziz AlObaili. All rights reserved.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createSearchNavigationController(), createFavoritesNavigationController()]
    }
    
    func createSearchNavigationController() -> UINavigationController {
        let searchViewController = SearchViewController()
        searchViewController.title = NSLocalizedString("Search", comment: "Title of the search tab.")
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: searchViewController)
    }
    
    func createFavoritesNavigationController() -> UINavigationController {
        let favoritesListViewController = FavoritesListViewController()
        favoritesListViewController.title = NSLocalizedString("Favorites", comment: "Title of the favorites tab.")
        favoritesListViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favoritesListViewController)
    }
    

}
