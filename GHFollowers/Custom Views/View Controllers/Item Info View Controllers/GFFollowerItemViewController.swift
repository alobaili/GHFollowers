//
//  GFFollowerItemViewController.swift
//  GHFollowers
//
//  Created by Abdulaziz AlObaili on 02/02/2020.
//  Copyright © 2020 Abdulaziz AlObaili. All rights reserved.
//

import UIKit

class GFFollowerItemViewController: GFItemInfoViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()
    }
    
    private func configureItems() {
        itemInfoView1.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoView2.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }

    
}
