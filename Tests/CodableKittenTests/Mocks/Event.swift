//
//  Event.swift
//  CodableKitten
//
//  Created by Stefano Mondino on 22/04/25.
//
import CodableKitten

struct Event: Codable, Sendable {
    typealias Category = ExtensibleIdentifier<String, Self>
    let title: String
    let category: Category
}

extension Event.Category {
    static var talk: Self { "talk" }
    static var workshop: Self { "workshop" }
}

