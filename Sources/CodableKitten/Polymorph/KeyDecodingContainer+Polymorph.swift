//
//  File.swift
//  
//
//  Created by Stefano Mondino on 13/09/24.
//

import Foundation

public extension KeyedDecodingContainer {

    func decode<Extractor, Value>(_ type: Polymorph<Extractor, Value>.Type, forKey key: K) throws -> Polymorph<Extractor, Value> where Value: ExpressibleByNilLiteral {
        if let value = try self.decodeIfPresent(type, forKey: key) {
            return value
        }
        return Polymorph()
    }
}
