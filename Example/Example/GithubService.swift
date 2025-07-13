//
//  GithubService.swift
//  Example
//
//  Created by Stefano Mondino on 13/07/25.
//

import Foundation
import CodableKitten

actor GithubService {
    private let baseURL = URL(string: "https://api.github.com")!
    private let session: URLSession
    private let decoder = JSONDecoder()
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder.set(types: [Github.Push.self, Github.Release.self, Github.Watch.self],
                         for: Github.EventType.self)
    }
    func fetchEvents(for username: String, repo: String) async throws -> [any GithubEvent] {
        let request = URLRequest(url: baseURL.appendingPathComponent("repos/\(username)/\(repo)/events"))
        let (data, response) = try await session.data(for: request)
        let propertyWrapper = try decoder.decode(Polymorph<Github.EventType, [any GithubEvent]>.self, from: data)
        return propertyWrapper.wrappedValue
    }

}
