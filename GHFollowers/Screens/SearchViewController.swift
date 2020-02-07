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
	let callToActionButton = GFButton(
        backgroundColor: .systemGreen,
        title: NSLocalizedString("Get Followers", comment: "Button: Go to followers list of a GitHub user.")
    )
    let changeLanguageButton = UIButton()
    
    var isUsernameEntered: Bool { return !usernameTextField.text!.isEmpty }
	
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureUsernameTextField()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
        configureChangeLanguageButton()
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
            presentAlertOnMainThread(
                title: NSLocalizedString("Empty Username", comment: "Error message title."),
                message: NSLocalizedString("Empty Username Body", comment: "Please enter a username. We need to know who to look for 😀"),
                buttonTitle: NSLocalizedString("OK", comment: "Button: OK.")
            )
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
		
		NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant),
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
    
    func configureChangeLanguageButton() {
        view.addSubview(changeLanguageButton)
        changeLanguageButton.translatesAutoresizingMaskIntoConstraints = false
        changeLanguageButton.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
        changeLanguageButton.setImage(UIImage(systemName: "globe"), for: .normal)
        changeLanguageButton.tintColor = .systemGreen
        
        NSLayoutConstraint.activate([
            changeLanguageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            changeLanguageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            changeLanguageButton.widthAnchor.constraint(equalToConstant: 50),
            changeLanguageButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func changeLanguage() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
	

}

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowersListViewController()
        
        return true
    }
    
    
}
