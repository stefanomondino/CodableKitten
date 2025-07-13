//
//  Event.swift
//  Example
//
//  Created by Stefano Mondino on 13/07/25.
//

import CodableKitten
import Foundation

struct Github: Sendable {
    struct Actor: Codable, Sendable {
        enum CodingKeys: String, CodingKey {
            case id
            case login
            case avatarURL = "avatar_url"
        }
        let id: Int64
        let login: String
        let avatarURL: URL?
    }
}


protocol GithubEvent: Polymorphic, Identifiable where Extractor == Github.EventType {
    var actor: Github.Actor { get }
    var id: String { get }
}

extension Github {
    struct EventType: TypeExtractor {
        typealias ID = ExtensibleIdentifier<String, Self>
        typealias ObjectType = GithubEvent
        let type: ID
        init(_ type: ID) {
            self.type = type
        }
    }
}

