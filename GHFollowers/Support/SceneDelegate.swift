//
//  SceneDelegate.swift
//  GHFollowers
//
//  Created by Abdulaziz AlObaili on 29/01/2020.
//  Copyright © 2020 Abdulaziz AlObaili. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?


	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		
		window = UIWindow(frame: windowScene.coordinateSpace.bounds)
		window?.windowScene = windowScene
		window?.rootViewController = GFTabBarController()
		window?.makeKeyAndVisible()
        
        configureNavigationBar()
	}
    
    func configureNavigationBar() {
        UINavigationBar.appearance().tintColor = .systemGreen
    }


}

