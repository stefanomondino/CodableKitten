//
//  File.swift
//  
//
//  Created by Stefano Mondino on 13/09/24.
//

import Foundation

public extension KeyedDecodingContainer {
    func decode<T>(_ type: OptionalPolymorph<T>.Type, forKey key: K) throws -> OptionalPolymorph<T> {
        if let value = try self.decodeIfPresent(type, forKey: key) {
            return value
        }

        return OptionalPolymorph()
    }
    func decode<T>(_ type: OptionalPolymorphArray<T>.Type, forKey key: K) throws -> OptionalPolymorphArray<T> {
        if let value = try self.decodeIfPresent(type, forKey: key) {
            return value
        }

        return OptionalPolymorphArray()
    }
}
