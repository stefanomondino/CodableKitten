//
//  File.swift
//  
//
//  Created by Stefano Mondino on 11/09/24.
//

import Foundation
import CodableKitten

protocol Animal: Polymorphic where Extractor == AnimalType {}

struct AnimalType: StringTypeExtractor, Encodable {
    enum CodingKeys: String, CodingKey {
        case value = "type"
    }
    
    typealias ObjectType = Animal
    let value: String
    init(_ value: String) {
        self.value = value
    }
}

extension AnimalType {
    static var cat: Self { "cat" }
    static var dog: Self { "dog" }
}

struct Dog: Animal {
    static var typeExtractor: AnimalType { .dog }
    let name: String
    let goodBoy: Bool
}

struct Cat: Animal {
    static var typeExtractor: AnimalType { .cat }
    let name: String
    let breed: String
}
