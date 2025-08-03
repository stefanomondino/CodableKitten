//
//  PushView.swift
//  Example
//
//  Created by Stefano Mondino on 13/07/25.
//

import Foundation
import SwiftUI

extension Github.Release: Renderable {
    func buildView() -> any View {
        ReleaseView(value: self)
    }
}

struct ReleaseView: View {
    let value: Github.Release
    
    var body: some View {
        HStack {
            ActorView(event: value)
            Spacer()
            Image(systemName: "tag")
        }
        .card()
    }
}
