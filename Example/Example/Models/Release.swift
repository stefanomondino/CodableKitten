//
//  Push.swift
//  Example
//
//  Created by Stefano Mondino on 13/07/25.
//
import CodableKitten
import Foundation

extension Github.EventType.ID {
    static var release: Self { "ReleaseEvent" }
}

extension Github {
    struct Release: Codable, Sendable, GithubEvent {
        static var typeExtractor: Github.EventType { .init(.push) }
        var id: String
        let actor: Github.Actor
        @StringDateValue<ISO8601SafeFormat> var createdAt: Date
    }
}
