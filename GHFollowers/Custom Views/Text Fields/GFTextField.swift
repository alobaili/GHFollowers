//
//  GFTextField.swift
//  GHFollowers
//
//  Created by Abdulaziz AlObaili on 30/01/2020.
//  Copyright © 2020 Abdulaziz AlObaili. All rights reserved.
//

import UIKit

class GFTextField: UITextField {

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.clearButtonRect(forBounds: bounds)
        return originalRect.offsetBy(dx: -8, dy: 0)
    }
	
	private func configure() {
		translatesAutoresizingMaskIntoConstraints = false
		
		layer.cornerRadius = 10
		layer.borderWidth = 2
		layer.borderColor = UIColor.systemGray4.cgColor
		
		textColor = .label
		tintColor = .label
		textAlignment = .center
		font = UIFont.preferredFont(forTextStyle: .title2)
		adjustsFontSizeToFitWidth = true
		minimumFontSize = 12
		
		backgroundColor = .tertiarySystemBackground
		autocorrectionType = .no
        returnKeyType = .go
        clearButtonMode = .whileEditing
        autocapitalizationType = .none
		placeholder = "Enter a username"
	}

}
