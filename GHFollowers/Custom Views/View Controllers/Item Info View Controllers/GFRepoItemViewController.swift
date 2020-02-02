//
//  GFRepoItemViewController.swift
//  GHFollowers
//
//  Created by Abdulaziz AlObaili on 02/02/2020.
//  Copyright © 2020 Abdulaziz AlObaili. All rights reserved.
//

import UIKit

class GFRepoItemViewController: GFItemInfoViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureItems()
    }
    
    private func configureItems() {
        itemInfoView1.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoView2.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }
    

}
