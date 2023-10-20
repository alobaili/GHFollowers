//
//  FollowerCollectionViewCell.swift
//  GHFollowers
//
//  Created by Abdulaziz AlObaili on 31/01/2020.
//  Copyright © 2020 Abdulaziz AlObaili. All rights reserved.
//

import SwiftUI

class FollowerCollectionViewCell: UICollectionViewCell {
    static let reuseId = "FollowerCollectionViewCell"
    
    func set(follower: Follower) {
        contentConfiguration = UIHostingConfiguration {
            FollowerView(follower: follower)
        }
    }
}
