{% include "Includes/Header.stencil" %}

@propertyWrapper
public struct NullCodable<Value> {
    
    public enum EncodingOption {
        case encodeNull, `default`
    }
    
    public struct EncodingOptionWrapper {
        
        public var encodingOption: EncodingOption
        
    }
    
    enum CodingKeys: String, CodingKey {
        case wrappedValue
    }
    
    public var wrappedValue: Value?
    
    public var projectedValue: EncodingOptionWrapper = .init(encodingOption: .default)
    
    public init(wrappedValue: Value?) {
        self.wrappedValue = wrappedValue
    }
    
}

extension NullCodable: Encodable where Value: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch wrappedValue {
        case .some(let value): try container.encode(value)
        case .none: try container.encodeNil()
        }
    }
    
}

extension NullCodable: Decodable where Value: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            wrappedValue = try container.decode(Value.self)
        }
    }
    
}

extension KeyedEncodingContainer {

    public mutating func encodeIfPresent<Value>(
        _ value: NullCodable<Value>,
        forKey key: KeyedDecodingContainer<K>.Key
    ) throws where Value : Encodable {
        if value.projectedValue.encodingOption == .default {
            try encodeIfPresent(value.wrappedValue, forKey: key)
        } else {
            try encode(value.wrappedValue, forKey: key)
        }
    }
    
    public mutating func encodeAnyIfPresent<Value>(
        _ value: NullCodable<Value>,
        forKey key: KeyedDecodingContainer<K>.Key
    ) throws {
        if value.projectedValue.encodingOption == .default {
            try encodeAnyIfPresent(value.wrappedValue, forKey: key)
        } else {
            try encode(AnyCodable(value.wrappedValue), forKey: key)
        }
    }
    
}

extension KeyedDecodingContainer {
    
    public func decode<Value>(
        _ type: NullCodable<Value>.Type,
        forKey key: KeyedDecodingContainer<K>.Key
    ) throws -> NullCodable<Value> where Value: Decodable {
        return try decodeIfPresent(NullCodable<Value>.self, forKey: key) ?? NullCodable<Value>(wrappedValue: nil)
    }
    
}
