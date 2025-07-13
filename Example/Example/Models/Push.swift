//
//  Push.swift
//  Example
//
//  Created by Stefano Mondino on 13/07/25.
//
import CodableKitten

extension Github.EventType.ID {
    static var push: Self { "PushEvent" }
}

extension Github {
    struct Push: Codable, Sendable, GithubEvent {
        static var typeExtractor: Github.EventType { .init(.push) }
        let actor: Github.Actor
        var id: String
    }
}
