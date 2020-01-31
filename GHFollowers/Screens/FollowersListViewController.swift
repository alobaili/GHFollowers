//
//  FollowersListViewController.swift
//  GHFollowers
//
//  Created by Abdulaziz AlObaili on 31/01/2020.
//  Copyright © 2020 Abdulaziz AlObaili. All rights reserved.
//

import UIKit

class FollowersListViewController: UIViewController {
    
    var username: String!
    var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureCollectionView()
        getFollowers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemPink
        collectionView.register(FollowerCollectionViewCell.self, forCellWithReuseIdentifier: FollowerCollectionViewCell.reuseId)
    }
    
    func getFollowers() {
        NetworkManager.shared.getFollowers(for: username, page: 1) { (result) in
            switch result {
                case .success(let followers):
                    print(followers)
                case .failure(let error):
                    self.presentAlertOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    

}
