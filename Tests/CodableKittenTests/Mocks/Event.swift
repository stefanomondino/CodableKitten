//
//  Event.swift
//  CodableKitten
//
//  Created by Stefano Mondino on 22/04/25.
//
import CodableKitten

struct Event: Codable {
    typealias Category = ExtensibleIdentifier<String, Self>
    let title: String
    let category: Category
}

extension Event.Category {
    @Case("talk") static var talk
    @Case("workshop") static var workshop
}
