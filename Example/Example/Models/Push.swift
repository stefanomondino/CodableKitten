//
//  Push.swift
//  Example
//
//  Created by Stefano Mondino on 13/07/25.
//
import CodableKitten
import Foundation

extension Github.EventType.ID {
    static var push: Self { "PushEvent" }
}

extension Github {
    struct Push: Codable, Sendable, GithubEvent {
        struct Payload: Sendable, Codable {
            struct Commit: Sendable, Codable {
                struct Author: Sendable, Codable {
                    let name: String
                    let email: String
                }
                let sha: String
                let message: String
            }
                
            let size: Int
            let distinctSize: Int
            let ref: String
            let commits: [Commit]
            
        }
        static var typeExtractor: Github.EventType { .init(.push) }
        let actor: Github.Actor
        let id: String
        @StringDateValue<ISO8601SafeFormat> var createdAt: Date
        let payload: Payload
    }
}
