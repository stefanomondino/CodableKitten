//
//  Push.swift
//  Example
//
//  Created by Stefano Mondino on 13/07/25.
//
import CodableKitten
import Foundation
extension Github.EventType.ID {
    static var watch: Self { "WatchEvent" }
}

extension Github {
    struct Watch: Codable, Sendable, GithubEvent {
        static var typeExtractor: Github.EventType { .init(.watch) }
        let actor: Github.Actor
        var id: String
        @StringDateValue<ISO8601SafeFormat> var createdAt: Date
    }
}
