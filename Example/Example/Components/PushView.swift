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
        PushView(value: self)
    }
}

struct PushView: View {
    let value: Github.Push
    
    var body: some View {
        HStack {
            ActorView(event: value)
            Spacer()
            Image(systemName: "arrow.up")
                
        }
        .card()
    }
}

extension View {
    func card(background: Color = .white) -> some View {
        self
            .padding()
            .background(background)
            .clipShape(.capsule)
            .overlay {
                Capsule()
                    .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
            }
            .contentShape(.capsule)
    }
}
