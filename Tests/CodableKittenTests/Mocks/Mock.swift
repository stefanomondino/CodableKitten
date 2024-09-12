//
//  Mocks.swift
//  CodableKitTests
//
//  Created by Stefano Mondino on 11/09/24.
//

import Foundation

struct Mock: ExpressibleByStringInterpolation {
    
    static var vehicles: Self { "vehicles" }
    static var vehicle: Self { "vehicle" }
    static var animal: Self { "animal" }
    static var vehicleResponseWithProperties: Self { "vehicleResponseWithProperties" }
    static var watchablesWithNestedTypes: Self { "watchablesWithNestedTypes" }
    
    enum Error: Swift.Error {
        case dataNotFound(String)
    }
    
    init(stringLiteral value: String) {
        filename = value
    }
    
    let filename: String
    
    func data() throws -> Data {
        guard let url = Bundle.module.url(forResource: filename, withExtension: "json", subdirectory: "JSON") else {
            throw Error.dataNotFound(filename)
        }
        return try Data(contentsOf: url)
    }
    
    func object<Value: Decodable>(of type: Value.Type = Value.self, decoder: JSONDecoder = .init()) throws -> Value {
        try decoder.decode(Value.self, from: data())
    }
}
