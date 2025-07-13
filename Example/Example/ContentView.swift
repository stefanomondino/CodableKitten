//
//  ContentView.swift
//  Example
//
//  Created by Stefano Mondino on 13/07/25.
//

import SwiftUI

protocol Renderable {
    func buildView() -> any View
}

struct ContentView: View {
    enum ViewState {
        case loading
        case error(Error)
        case values([any GithubEvent])
    }
    @Environment(\.github) var github: GithubService
    @State var state: ViewState = .loading
        
    var body: some View {
        ZStack {
            switch state {
            case .loading:
                ProgressView("Loading...")
                    .progressViewStyle(.circular)
            case .error(let error):
                Text("Error: \(error.localizedDescription)")
            case let .values(events):
                ScrollView {
                    VStack {
                        ForEach(events, id: \.id) { event in
                            if let renderable = event as? Renderable {
                                AnyView(renderable.buildView())
                            }
                        }
                    }
                }
            }
        }
        .task { @MainActor in
            self.state = .loading
            do {
                state = .values(try await github.fetchEvents(for: "stefanomondino", repo: "CodableKitten"))
            } catch {
                state = .error(error)
            }
                
                
        }
    }
}

#Preview {
    ContentView()
}
