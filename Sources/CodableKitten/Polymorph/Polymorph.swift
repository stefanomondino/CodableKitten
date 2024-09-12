
@propertyWrapper
public struct Polymorph<Extractor: TypeExtractor>: Decodable {
    private var value: Extractor.ObjectType?
    public var wrappedValue: Extractor.ObjectType {
        get {
            return value.unsafelyUnwrapped
        }
        set {
            value = newValue
        }
    }
    public init(_ type: Extractor.Type = Extractor.self) {}
    public init(_ value: Extractor.ObjectType) {
        self.value = value
    }
    public init(from decoder: any Decoder) throws {
        guard let value: Extractor.ObjectType = try Extractor.extract(from: decoder) else {
            throw Error.missingMapping
        }
        self.value = value
    }
 
    public func value<Value: Polymorphic>(of _: Value.Type = Value.self) -> Value? where Value.Extractor == Extractor {
        wrappedValue as? Value
    }
}

extension Polymorph: Encodable where Extractor.ObjectType: Encodable {
    public func encode(to encoder: any Encoder) throws {
        try Extractor.encode(value: wrappedValue, into: encoder)
//            var container = encoder.singleValueContainer()
//            try container.encode(wrappedValue)
    }
}

@propertyWrapper
public struct OptionalPolymorph<Extractor: TypeExtractor>: Decodable {
    private var value: Extractor.ObjectType?
    public var wrappedValue: Extractor.ObjectType? {
        get {
            return value
        }
        set {
            value = newValue
        }
    }
    public init(_ type: Extractor.Type = Extractor.self) {}
    public init(_ value: Extractor.ObjectType) {
        self.value = value
    }
    public init(from decoder: any Decoder) throws {
        self.value = try Extractor.extract(from: decoder)
    }
    public func value<Value: Polymorphic>(of _: Value.Type = Value.self) -> Value? where Value.Extractor == Extractor {
        wrappedValue as? Value
    }
}

extension OptionalPolymorph: Encodable where Extractor.ObjectType: Encodable {
    public func encode(to encoder: any Encoder) throws {
        if let wrappedValue {
            try Extractor.encode(value: wrappedValue, into: encoder)
        } else {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
}


@propertyWrapper
public struct PolymorphArray<Extractor: TypeExtractor>: Decodable {
    private var value: [Extractor.ObjectType]
    public var wrappedValue: [Extractor.ObjectType] {
        get {
            return value
        }
        set {
            value = newValue
        }
    }
    public init(_ type: Extractor.Type = Extractor.self) {
        value = []
    }
    
    public init(_ value: [Extractor.ObjectType]) {
        self.value = value
    }
    
    public init(from decoder: any Decoder) throws {
        self.value = try Extractor.extract(from: decoder) ?? []
    }
}

extension PolymorphArray: Encodable {
    public func encode(to encoder: any Encoder) throws {
        try Extractor.encode(values: wrappedValue, into: encoder)
    }
}

@propertyWrapper
public struct OptionalPolymorphArray<Extractor: TypeExtractor>: Decodable {
    private var value: [Extractor.ObjectType]?
    public var wrappedValue: [Extractor.ObjectType]? {
        get {
            return value
        }
        set {
            value = newValue
        }
    }
    public init(_ type: Extractor.Type = Extractor.self) {
    }
    
    public init(_ value: [Extractor.ObjectType]?) {
        self.value = value
    }
    
    public init(from decoder: any Decoder) throws {
        self.value = try Extractor.extract(from: decoder)
    }
}

extension OptionalPolymorphArray: Encodable where Extractor.ObjectType: Encodable {
        public func encode(to encoder: any Encoder) throws {
           
            if let values = wrappedValue {
                try Extractor.encode(values: values, into: encoder)
            } else {
                var container = encoder.unkeyedContainer()
                try container.encodeNil()
            }
    }
}
