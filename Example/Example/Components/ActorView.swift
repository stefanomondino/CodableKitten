//
//  ActorView.swift
//  Example
//
//  Created by Stefano Mondino on 13/07/25.
//

import Foundation
import SwiftUI
import CodableKitten

struct ActorView: View {
    var event: any GithubEvent
    var body: some View {
        
            HStack(alignment: .center) {
                if let avatar = event.actor.avatarURL {
                    AsyncImage(url: avatar) { phase in
                        switch phase {
                        case let .success(image): image.resizable()
                        default: Color.gray
                        }
                    }
                    .aspectRatio(1, contentMode: .fit)
                    .frame(height: 44)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    }
                    
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(event.actor.login)
                    Text(event.createdAt.formatted(date: .abbreviated, time: .shortened))
                        .font(.footnote)
                }
                Spacer()
            }
    }
}

#Preview {
    ActorView(event: Github.Release(id: "",
                                    actor: .init(id: 0,
                                                         login: "stefanomondino",
                                                         avatarURL: .init(string: "https://avatars.githubusercontent.com/u/1691903")),
                                    createdAt: .init(1234567890)))
}
