/// A property wrapper that enables polymorphic encoding and decoding of values using a type extractor.
///
/// `Polymorph` allows you to wrap a value whose concrete type is determined at runtime,
/// supporting polymorphic serialization and deserialization. It uses a `TypeExtractor`
/// to extract and encode the correct type from a decoder or into an encoder.
///
/// - Parameters:
///   - Extractor: A type conforming to `TypeExtractor` that knows how to extract and encode the object type.
///   - Value: The value type to be wrapped, which must be `Sendable`.
///
/// Usage:
/// ```swift
/// @Polymorph<AnimalTypeExtractor, any Animal> var animal
/// @Polymorph<AnimalTypeExtractor, [any Animal]> var animals
/// @Polymorph<AnimalTypeExtractor, (any Animal)?> var animal
/// @Polymorph<AnimalTypeExtractor, [any Animal]?> var animals
/// ```
///
/// The wrapper supports single objects, optionals, arrays, and optional arrays of the extracted type.

@propertyWrapper
public struct Polymorph<Extractor: TypeExtractor, Value: Sendable>: Decodable, Sendable {
    private var value: Value?
    public var wrappedValue: Value {
        get {
            return value.unsafelyUnwrapped
        }
        set {
            value = newValue
        }
    }
    /// Initialize for regular use as property wrapper
    public init(_ type: Extractor.Type = Extractor.self, _ value: Value.Type = Value.self) {}
    
    /// Initialize with a specific value, useful for testing or direct instantiation.
    public init(_ value: Value) {
        self.value = value
    }
    
    public init(from decoder: any Decoder) throws  {
        if Extractor.ObjectType.self == Value.self {
            guard let value: Extractor.ObjectType = try Extractor.extract(from: decoder) else {
                throw DecodingError.valueNotFound(Value.self,
                                                  .init(codingPath: [],
                                                        debugDescription: "Expected a value of type \(Value.self) but found nil. Did you register the concrete type on the decoder?"))
            }
            self.value = value as? Value
        } else if Value.self == Optional<Extractor.ObjectType>.self {
            let value: Optional<Extractor.ObjectType> = try Extractor.extract(from: decoder)
            self.value = value as? Value
        } else if Value.self == [Extractor.ObjectType].self {
            let value: [Extractor.ObjectType]? = try Extractor.extract(from: decoder)
            self.value = value as? Value
        } else if Value.self == Optional<[Extractor.ObjectType]>.self {
            let value: [Extractor.ObjectType]? = try Extractor.extract(from: decoder)
            self.value = value as? Value
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: [],
                                                    debugDescription: "Attempted to decode a Polymorph with a Value type that does not match the expected ObjectType from the Extractor."))
        }
    }
}
/// Adds Encodable conformance to `Polymorph` when the wrapped value is encodable.
/// Note: Currently as of Swift 6.2 there's no way to conditionally conform a property wrapper to `Encodable` based on the wrapped value type, because Polymorph will use a generic protocol as Value (example: any Animal) which is not declarable as encodable.
extension Polymorph: Encodable {
    public func encode(to encoder: any Encoder) throws {
        if let value = wrappedValue as? Extractor.ObjectType {
            try Extractor.encode(value: value, into: encoder)
        } else if let value = wrappedValue as? Optional<Extractor.ObjectType> {
            if let value {
                try Extractor.encode(value: value, into: encoder)
            } else {
                var container = encoder.singleValueContainer()
                try container.encodeNil()
            }
        } else if let values = wrappedValue as? [Extractor.ObjectType] {
            try Extractor.encode(values: values, into: encoder)
        } else if let values = wrappedValue as? [Extractor.ObjectType]? {
            if let values {
                try Extractor.encode(values: values, into: encoder)
            } else {
                var container = encoder.singleValueContainer()
                try container.encodeNil()
            }
        } else {
            throw EncodingError.invalidValue(self, .init(codingPath: [], debugDescription: "Unable to encode Polymorph with Value type \(Value.self)."))
        }
    }
}
