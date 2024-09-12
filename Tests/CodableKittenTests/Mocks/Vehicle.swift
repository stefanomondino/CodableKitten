//
//  File.swift
//  
//
//  Created by Stefano Mondino on 11/09/24.
//

import Foundation
import CodableKitten

struct VehicleType: StringTypeExtractor {
    typealias ObjectType = Vehicle
    enum CodingKeys: String, CodingKey {
        case value = "type"
    }
    var value: String
}

protocol Vehicle: Polymorphic where Extractor == VehicleType {}

struct Car: Vehicle {
    static var keyType: VehicleType { .car }
    let brand: String
}

struct Boat: Vehicle {
    static var keyType: VehicleType { .boat }
    let engineCount: Int
}

struct Bike: Vehicle {
    static var keyType: VehicleType { .bike }
    let isElectric: Bool
}

extension VehicleType {
    static var car: Self { "car" }
    static var boat: Self { "boat" }
    static var bike: Self { "bike" }
}

struct SingleResponse: Decodable {
    @OptionalPolymorph<VehicleType> var nilValue: (any Vehicle)?
    @OptionalPolymorphArray<VehicleType> var nilArrayValue: [any Vehicle]?
    @Polymorph<VehicleType> var vehicle: any Vehicle
    @PolymorphArray<VehicleType> var otherVehicles: [any Vehicle]
}
