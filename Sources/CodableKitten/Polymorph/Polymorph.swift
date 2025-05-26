@propertyWrapper
public struct Polymorph<Extractor: TypeExtractor, Value: Sendable>: Codable, Sendable {
    private var value: Value?
    public var wrappedValue: Value {
        get {
            return value.unsafelyUnwrapped
        }
        set {
            value = newValue
        }
    }
    
    public init(_ type: Extractor.Type = Extractor.self, _ value: Value.Type = Value.self) {}
    public init(_ value: Value) {
        self.value = value
    }

    public init(from decoder: any Decoder) throws  {
        if Extractor.ObjectType.self == Value.self {
            guard let value: Extractor.ObjectType = try Extractor.extract(from: decoder) else {
                throw Error.missingMapping
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
            throw Error.misconfiguredMapping
        }
    }
    
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
            throw Error.misconfiguredMapping
        }
    }
}
