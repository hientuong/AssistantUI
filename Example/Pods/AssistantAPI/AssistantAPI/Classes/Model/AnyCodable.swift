//
//  File.swift
//  AssistantAPI
//
//  Created by Cong Nguyen on 03/06/2022.
//

import Foundation

public enum AnyCodable {
    case string(value: String)
    case int(value: Int)
    case double(value: Double)
    case bool(value: Bool)
    case list(value: [AnyCodable])
    case any(value: Any)
    case null
    
    public var string: String? {
        switch self {
        case .string(let value):
            return value
        default:
            return nil
        }
    }
    
    public var int: Int? {
        switch self {
        case .int(let value):
            return value
        default:
            return nil
        }
    }
    
    public var double: Double? {
        switch self {
        case .double(let value):
            return value
        case .int(let value):
            return Double(value)
        default:
            return nil
        }
    }
    
    public var bool: Bool? {
        switch self {
        case .bool(let value):
            return value
        default:
            return nil
        }
    }
    
    public var list: [AnyCodable]? {
        switch self {
        case .list(let value):
            return value
        default:
            return nil
        }
    }
    
    public var number: NSNumber? {
        switch self {
        case .double(let value):
            return NSNumber(value: value)
        case .int(let value):
            return NSNumber(value: value)
        case .bool(let value):
            return NSNumber(value: value)
        default:
            return nil
        }
    }
}

extension AnyCodable: RawRepresentable {
    public typealias RawValue = Any
    public var rawValue: Any {
        switch self {
        case .string(let value):
            return value
        case .int(let value):
            return value
        case .double(let value):
            return value
        case .bool(let value):
            return value
        case .list(let value):
            return value
        case .any(let value):
            return value
        default:
            return NSNull()
        }
    }
    
    public init?(rawValue: Self.RawValue) {
        if let str = rawValue as? String {
            self = .string(value: str)
        } else if let int = rawValue as? Int {
            self = .int(value: int)
        } else if let double = rawValue as? Double {
            self = .double(value: double)
        } else if let bool = rawValue as? Bool {
            self = .bool(value: bool)
        } else if let list = rawValue as? [AnyCodable] {
            self = .list(value: list)
        } else {
            self = .any(value: rawValue)
        }
    }
}

extension AnyCodable: Codable {
    public enum CodingKeys: String, CodingKey {
        case value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let value = try container.decode(AnyCodable.self, forKey: .value)
        
        switch value {
        case .string(let value):
            self = .string(value: value)
        case .int(let value):
            self = .int(value: value)
        case .double(let value):
            self = .double(value: value)
        case .bool(let value):
            self = .bool(value: value)
        case .list(let value):
            self = .list(value: value)
        default:
            if case let AnyCodable.any(value) = value {
                self = .any(value: value)
            } else {
                self = .null
            }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .string(let value):
            try container.encode(value, forKey: .value)
        case .int(let value):
            try container.encode(value, forKey: .value)
        case .double(let value):
            try container.encode(value, forKey: .value)
        case .bool(let value):
            try container.encode(value, forKey: .value)
        case .list(let value):
            try container.encode(value, forKey: .value)
        default:
            if case let AnyCodable.any(value) = self {
                try container.encode("\(value)", forKey: .value)
            }
        }
    }
}

