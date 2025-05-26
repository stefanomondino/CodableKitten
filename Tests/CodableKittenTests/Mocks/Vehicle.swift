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
    init(_ value: String) {
        self.value = value
    }
}

protocol Vehicle: Polymorphic where Extractor == VehicleType {
    var name: String { get }
}

struct Car: Vehicle {
    static var typeExtractor: VehicleType { .car }
    let brand: String
    let name: String
}

struct Boat: Vehicle {
    static var typeExtractor: VehicleType { .boat }
    let engineCount: Int
    let name: String
}

struct Bike: Vehicle {
    static var typeExtractor: VehicleType { .bike }
    let isElectric: Bool
    let name: String
}

extension VehicleType {
    static var car: Self { "car" }
    static var boat: Self { "boat" }
    static var bike: Self { "bike" }
}

struct SingleResponse: Decodable {
    @Polymorph<VehicleType, Vehicle?> var nilValue
    @Polymorph<VehicleType, [Vehicle]?> var nilArrayValue
    @Polymorph<VehicleType, Vehicle> var vehicle
    @Polymorph<VehicleType, [Vehicle]> var otherVehicles
}
