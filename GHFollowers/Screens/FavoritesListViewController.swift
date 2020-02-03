//
//  FavoritesListViewController.swift
//  GHFollowers
//
//  Created by Abdulaziz AlObaili on 30/01/2020.
//  Copyright © 2020 Abdulaziz AlObaili. All rights reserved.
//

import UIKit

class FavoritesListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemBlue
        
        PersistenceManager.retrieveFavorites { (result) in
            switch result {
                case .success(let favorites):
                print(favorites)
                case .failure(let error):
                break
            }
        }
    }
	

}
