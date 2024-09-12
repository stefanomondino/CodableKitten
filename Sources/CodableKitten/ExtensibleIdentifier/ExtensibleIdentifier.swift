//
//  ExtensibleIdentifier.swift
//  CodableKit
//
//  Created by Stefano Mondino on 11/09/24.
//

import Foundation

public protocol ExtensibleIdentifier: Hashable {
    associatedtype Tag
    associatedtype Value: Hashable
    var value: Value { get }
    init(_ value: Value)
}

extension ExtensibleIdentifier where Value: Decodable {
    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(Value.self)
        self.init(value)
    }
}
extension ExtensibleIdentifier where Value: Encodable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

extension ExtensibleIdentifier where Value: CustomStringConvertible {
    public var description: String { value.description }
}

extension ExtensibleIdentifier {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
        hasher.combine(ObjectIdentifier(Tag.self))
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
}

public struct StringIdentifier<Tag>: ExtensibleIdentifier, Codable, ExpressibleByStringInterpolation, CustomStringConvertible {
    public var value: String
    public init(_ value: String) {
        self.value = value
    }
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}

public struct IntIdentifier<Tag>: ExtensibleIdentifier, Codable, ExpressibleByIntegerLiteral, CustomStringConvertible {
    public var value: Int
    public init(_ value: Int) {
        self.value = value
    }
    public init(integerLiteral value: IntegerLiteralType) {
        self.value = value
    }
}
