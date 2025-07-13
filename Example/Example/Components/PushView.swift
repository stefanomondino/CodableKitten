//
//  PushView.swift
//  Example
//
//  Created by Stefano Mondino on 13/07/25.
//

import Foundation
import SwiftUI

extension Github.Push: Renderable {
    func buildView() -> any View {
        PushView(push: self)
    }
}

struct PushView: View {
    let push: Github.Push
    
    var body: some View {
        HStack(alignment: .center) {
            if let avatar = push.actor.avatarURL {
                AsyncImage(url: avatar) { image in
                    if let value = image.image {
                        value.resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(height: 40)
                        .clipShape(Circle())
                    }
                }
            }
            Text(push.actor.login)
        }
    }
}
