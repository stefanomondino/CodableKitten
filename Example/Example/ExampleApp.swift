//
//  ExampleApp.swift
//  Example
//
//  Created by Stefano Mondino on 13/07/25.
//

import SwiftUI

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension EnvironmentValues {
    @Entry var github: GithubService = GithubService()
}
