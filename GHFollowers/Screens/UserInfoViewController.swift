//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by Abdulaziz AlObaili on 01/02/2020.
//  Copyright © 2020 Abdulaziz AlObaili. All rights reserved.
//

import UIKit

protocol UserInfoViewControllerDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

class UserInfoViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let headerView = UIView()
    let itemView1 = UIView()
    let itemView2 = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    var itemViews = [UIView]()
    
    var username: String!
    weak var delegate: UserInfoViewControllerDelegate!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureScrollView()
        layoutUI()
        getUserInfo()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }
    
    func getUserInfo() {
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                configureUIElements(with: user)
            } catch let error as GFError {
                presentAlert(
                    title: NSLocalizedString("Something went wrong", comment: "Error message title."),
                    message: error.localizedDescription,
                    buttonTitle: NSLocalizedString("OK", comment: "Button: OK.")
                )
            } catch {
                presentDefaultAlert()
            }
        }
    }
    
    func configureUIElements(with user: User) {
        let repoItemViewController = GFRepoItemViewController(user: user, delegate: self)
        let followerItemViewController = GFFollowerItemViewController(user: user, delegate: self)
        
        self.add(childViewController: repoItemViewController, to: self.itemView1)
        self.add(childViewController: followerItemViewController, to: self.itemView2)
        self.add(childViewController: GFUserInfoHeaderViewController(user: user), to: self.headerView)
        self.dateLabel.text = NSLocalizedString("User since", comment: "Example: User since Oct 2017")
                                + " "
                                + "\(user.createdAt.convertToMonthYearFormat())"
    }
    
    func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        itemViews = [headerView, itemView1, itemView2, dateLabel]
        
        for itemView in itemViews {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
            ])
        }
        
        // headerView
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210)
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
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
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

// MARK: - GFRepoItemViewControllerDelegate

extension UserInfoViewController: GFRepoItemViewControllerDelegate {
    
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentAlert(
                title: NSLocalizedString("Invalid URL", comment: "Error message title."),
                message: NSLocalizedString("Invalid URL Body", comment: "The URL attached to this user is invalid."),
                buttonTitle: NSLocalizedString("OK", comment: "Button: OK.")
            )
            return
        }
        presentSafariViewController(with: url)
    }
    
    
}

// MARK: - GFFollowerItemViewControllerDelegate

extension UserInfoViewController: GFFollowerItemViewControllerDelegate {
    
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            presentAlert(
                title: NSLocalizedString("No Followers", comment: "Error message title."),
                message: NSLocalizedString("No Followers Body", comment: "This user has no folloers. What a shame 😞"),
                buttonTitle: NSLocalizedString("So sad", comment: "Button for error message.")
            )
            return
        }
        delegate.didRequestFollowers(for: user.login)
        dismissViewController()
    }
    
    
}
