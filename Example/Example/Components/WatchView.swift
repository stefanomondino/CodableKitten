//
//  PushView.swift
//  Example
//
//  Created by Stefano Mondino on 13/07/25.
//

import Foundation
import SwiftUI

extension Github.Watch: Renderable {
    func buildView() -> any View {
        WatchView(value: self)
    }
}

struct WatchView: View {
    let value: Github.Watch
    
    var body: some View {
        HStack(alignment: .center) {
            if let avatar = value.actor.avatarURL {
                AsyncImage(url: avatar) { image in
                    if let value = image.image {
                        value.resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(height: 40)
                        .clipShape(Circle())
                    }
                }
            }
            Text(value.actor.login)
        }
    }
}
