//
//  GFButton.swift
//  GHFollowers
//
//  Created by Abdulaziz AlObaili on 30/01/2020.
//  Copyright © 2020 Abdulaziz AlObaili. All rights reserved.
//

import UIKit

class GFButton: UIButton {

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(backgroundColor: UIColor, title: String) {
		super.init(frame: .zero)
		
		self.backgroundColor = backgroundColor
		self.setTitle(title, for: .normal)
		configure()
	}
	
	private func configure() {
		layer.cornerRadius = 10
		titleLabel?.textColor = .white
		titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
		translatesAutoresizingMaskIntoConstraints = false
	}
	

}
