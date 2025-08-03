//
//  File.swift
//  
//
//  Created by Stefano Mondino on 11/09/24.
//

import Foundation
import CodableKitten

protocol Animal: Polymorphic, Encodable where Extractor == AnimalType {}

struct AnimalType: TypeExtractor, Encodable {
    typealias ID = ExtensibleIdentifier<String, Self>
    enum CodingKeys: String, CodingKey {
        case value = "type"
    }
    
    typealias ObjectType = Animal
    let value: ID
    init(_ value: ID) {
        self.value = value
    }
}

extension AnimalType.ID {
    static var cat: Self { "cat" }
    static var dog: Self { "dog" }
}

struct Dog: Animal {
    static var typeExtractor: AnimalType { .init(.dog) }
    let type: AnimalType.ID
    let name: String
    let goodBoy: Bool
}

struct Cat: Animal {
    static var typeExtractor: AnimalType { .init(.cat) }
    let type: AnimalType.ID
    let name: String
    let breed: String
}
