//  ContentView.swift
//  Example
//
//  Created by Stefano Mondino on 13/07/25.
//

import SwiftUI

struct StyledTextField: View {
    let title: String
    @Binding var text: String
    var body: some View {
        TextField(title, text: $text)
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
            )
            .textFieldStyle(PlainTextFieldStyle())
    }
}

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
    
    @State private var author: String = "stefanomondino"
    @State private var repo: String = "codablekitten"
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 8) {
                StyledTextField(title: "Author", text: $author)
                StyledTextField(title: "Repository", text: $repo)
                Button("Search") {
                    Task { await fetchEvents() }
                }
            }.padding()
            
            ZStack {
                switch state {
                case .loading:
                    Color.clear
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
                        }.padding(8)
                    }
                }
            }
        }
        .task {
            await fetchEvents()
        }
    }
    
    @MainActor func fetchEvents() async {
        self.state = .loading
        do {
            let events = try await github.fetchEvents(for: author, repo: repo)
            self.state = .values(events)
        } catch {
            self.state = .error(error)
        }
    }
}

#Preview {
    ContentView()
}
