//
//  ExtensibleIdentifier.swift
//  CodableKit
//
//  Created by Stefano Mondino on 11/09/24.
//

import Foundation

/// A generic, type-safe identifier that can be extended with a tag type.
/// Useful for creating distinct identifier types from the same underlying value type while retaining type safety and extensibility, compared to enums.
public struct ExtensibleIdentifier<Value: Hashable & Sendable & Codable, Tag>: Hashable, Sendable, Codable {
    
    /// The underlying value of the identifier.
    public var value: Value
    
    /// Creates a new identifier with the given value.
    /// - Parameter value: The value to wrap.
    public init(_ value: Value) {
        self.value = value
    }
    
    /// Decodes an identifier from a decoder.
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(Value.self)
        self.init(value)
    }
    
    /// Encodes the identifier to an encoder.
    /// - Parameter encoder: The encoder to write data to.
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
    
    /// Hashes the essential components of the identifier.
    /// - Parameter hasher: The hasher to use.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
        hasher.combine(ObjectIdentifier(Tag.self))
    }
    
    /// Compares two identifiers for equality.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
}

extension ExtensibleIdentifier where Value: CustomStringConvertible {
    /// A textual representation of the identifier.
    public var description: String { value.description }
}

extension ExtensibleIdentifier where Value: CustomDebugStringConvertible {
    /// A debug textual representation of the identifier.
    public var debugDescription: String { value.debugDescription }
}

extension ExtensibleIdentifier: RawRepresentable  {
    /// The raw value of the identifier.
    public var rawValue: Value { value }
    /// Creates an identifier from a raw value.
    public init?(rawValue: Value) {
        value = rawValue
    }
}

extension ExtensibleIdentifier {
    /// A property wrapper for defining static identifier cases.
    /// This is used to almost match the enum syntax while keeping the extensibility of the identifier.
    /// ## Example
    ///
    ///  ```swift
    ///   struct Event: Codable {
    ///     typealias EventCategory = ExtensibleIdentifier<String, Event>
    ///     var category: EventCategory
    ///   }
    ///
    ///   extension EventCategory {
    ///    @Case("talk") var talk
    ///    @Case("workshop") var workshop
    ///   }
    @propertyWrapper public struct Case {
        let key: Value
        /// Creates a new case with the given key.
        /// - Parameter key: The value for the case.
        public init(_ key: Value) {
            self.key = key
        }
        /// The wrapped identifier value.
        public var wrappedValue: ExtensibleIdentifier<Value, Tag> {
            return .init(key)
        }
    }
}

/// A typealias for a string-based extensible identifier.
public typealias StringIdentifier<Tag> = ExtensibleIdentifier<String, Tag>
/// A typealias for an integer-based extensible identifier.
public typealias IntIdentifier<Tag> = ExtensibleIdentifier<Int, Tag>
/// A typealias for a boolean-based extensible identifier.
public typealias BoolIdentifier<Tag> = ExtensibleIdentifier<Bool, Tag>
/// A typealias for a float-based extensible identifier.
public typealias FloatIdentifier<Tag> = ExtensibleIdentifier<Float, Tag>

extension ExtensibleIdentifier: ExpressibleByUnicodeScalarLiteral where Value == String {}
extension ExtensibleIdentifier: ExpressibleByExtendedGraphemeClusterLiteral where Value == String {}
extension ExtensibleIdentifier: ExpressibleByStringLiteral where Value == String {}
extension ExtensibleIdentifier: ExpressibleByStringInterpolation where Value == String {
    /// Creates an identifier from a string literal.
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension ExtensibleIdentifier: ExpressibleByIntegerLiteral where Value == Int {
    /// Creates an identifier from an integer literal.
    public init(integerLiteral value: IntegerLiteralType) {
        self.value = value
    }
}

extension ExtensibleIdentifier: ExpressibleByBooleanLiteral where Value == Bool {
    /// Creates an identifier from a boolean literal.
    public init(booleanLiteral value: Bool) {
        self.value = value
    }
}

extension ExtensibleIdentifier: ExpressibleByFloatLiteral where Value == Float {
    /// Creates an identifier from a float literal.
    public init(floatLiteral value: Float) {
        self.value = value
    }
}
