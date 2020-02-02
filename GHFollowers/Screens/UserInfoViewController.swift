//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by Abdulaziz AlObaili on 01/02/2020.
//  Copyright © 2020 Abdulaziz AlObaili. All rights reserved.
//

import UIKit

protocol UserInfoViewControllerDelegate: class {
    
    func didTapGitHubProfile(for user: User)
    func didTapGetFollowers(for user: User)
    
    
}

class UserInfoViewController: UIViewController {
    
    let headerView = UIView()
    let itemView1 = UIView()
    let itemView2 = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    var itemViews = [UIView]()
    
    var username: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        layoutUI()
        getUserInfo()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self.configureUIElements(with: user)
                }
                case .failure(let error):
                    self.presentAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    func configureUIElements(with user: User) {
        let repoItemViewController = GFRepoItemViewController(user: user)
        repoItemViewController.delegate = self
        
        let followerItemViewController = GFFollowerItemViewController(user: user)
        followerItemViewController.delegate = self
        
        self.add(childViewController: repoItemViewController, to: self.itemView1)
        self.add(childViewController: followerItemViewController, to: self.itemView2)
        self.add(childViewController: GFUserInfoHeaderViewController(user: user), to: self.headerView)
        self.dateLabel.text = "User since \(user.createdAt.convertToDisplayFormat())"
    }
    
    func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        itemViews = [headerView, itemView1, itemView2, dateLabel]
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }
        
        // headerView
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        // itemView1
        NSLayoutConstraint.activate([
            itemView1.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemView1.heightAnchor.constraint(equalToConstant: itemHeight)
        ])
        
        // itemView2
        NSLayoutConstraint.activate([
            itemView2.topAnchor.constraint(equalTo: itemView1.bottomAnchor, constant: padding),
            itemView2.heightAnchor.constraint(equalToConstant: itemHeight)
        ])
        
        // dateLabel
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: itemView2.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func add(childViewController: UIViewController, to containerView: UIView) {
        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.frame = containerView.bounds
        childViewController.didMove(toParent: self)
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true)
    }
    

}

// MARK: - UserInfoViewControllerDelegate

extension UserInfoViewController: UserInfoViewControllerDelegate {
    
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentAlertOnMainThread(title: "Invalid URL", message: "The URL attached to this user is invalid.", buttonTitle: "OK")
            return
        }
        presentSafariViewController(with: url)
    }
    
    func didTapGetFollowers(for user: User) {
        //
    }
    
    
}
