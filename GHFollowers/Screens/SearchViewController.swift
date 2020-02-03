//
//  SearchViewController.swift
//  GHFollowers
//
//  Created by Abdulaziz AlObaili on 30/01/2020.
//  Copyright © 2020 Abdulaziz AlObaili. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
	
	let logoImageView = UIImageView()
	let usernameTextField = GFTextField()
	let callToActionButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")
    var logoImageViewTopConstraint: NSLayoutConstraint!
    
    var isUsernameEntered: Bool { return !usernameTextField.text!.isEmpty }
	
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureUsernameTextField()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
        usernameTextField.text = nil
		navigationController?.setNavigationBarHidden(true, animated: animated)
	}
    
    func createDismissKeyboardTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func pushFollowersListViewController() {
        guard isUsernameEntered else {
            presentAlertOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know who to look for 😀", buttonTitle: "OK")
            return
        }
        
        usernameTextField.resignFirstResponder()
        let followersListViewController = FollowersListViewController(username: usernameTextField.text!)
        navigationController?.pushViewController(followersListViewController, animated: true)
    }
    
    // MARK: Subviews Configuration
	
	func configureLogoImageView() {
		view.addSubview(logoImageView)
		logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.ghLogo
        
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        
        logoImageViewTopConstraint = logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant)
		
		NSLayoutConstraint.activate([
            logoImageViewTopConstraint,
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
		])
	}
    
    func configureUsernameTextField() {
        view.addSubview(usernameTextField)
        usernameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureCallToActionButton() {
        view.addSubview(callToActionButton)
        callToActionButton.addTarget(self, action: #selector(pushFollowersListViewController), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
	

}

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowersListViewController()
        
        return true
    }
    
    
}
