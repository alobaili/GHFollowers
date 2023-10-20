//
//  FollowerView.swift
//  GHFollowers
//
//  Created by Abdulaziz Alobaili on 20/10/2023.
//  Copyright © 2023 Abdulaziz AlObaili. All rights reserved.
//

import SwiftUI

struct FollowerView: View {
    let follower: Follower

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: follower.avatarUrl)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Image("avatar-placeholder")
                    .resizable()
                    .scaledToFit()
            }
            .clipShape(Circle())

            Text(follower.login)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
    }
}

#Preview {
    FollowerView(follower: Follower(login: "alobaili", avatarUrl: ""))
}
