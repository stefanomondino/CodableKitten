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
        HStack {
            ActorView(event: value)
            Spacer()
            Image(systemName: "eye")
        }
        .card()
    }
}
