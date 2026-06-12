// Copyright 2026 M34D - William Mead
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// 	http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//
//  MultiType.swift
//  SwiftDolibarr
//
//  Created by William Mead on 06/05/2025.
//

import Foundation

/// A type-erased value that can decode JSON strings, integers, or doubles.
///
/// The Dolibarr REST API sometimes returns the same field as different
/// JSON types. `MultiType` handles this by attempting each type in order
/// during decoding and providing typed accessors: ``stringValue``,
/// ``intValue``, and ``doubleValue``.
public enum MultiType: Codable, Hashable {

    // MARK: - Cases

    case string(String)
    case int(Int)
	case double(Double)

    // MARK: - Properties

    public var stringValue: String {
        switch self {
        case .string(let value):
            return value
        case .int(let value):
            return String(value)
        case .double(let value):
			return String(value)
        }
    }

    public var intValue: Int? {
        switch self {
        case .string(let value):
            return Int(value)
        case .int(let value):
            return value
        case .double(let value):
			return Int(value)
        }
    }

	public var doubleValue: Double? {
		switch self {
		case .string(let value):
			return Double(value)
		case .int(let value):
			return Double(value)
		case .double(let value):
			return value
		}
	}

    // MARK: - Inits

    public init() {
        self = .string("")
    }

    public init(_ value: String) {
        self = .string(value)
    }

    public init(_ value: Int) {
        self = .int(value)
    }

    public init(_ value: Double) {
        self = .double(value)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(String.self) {
            self = .string(value)
            return
		} else if let value = try? container.decode(Int.self) {
			self = .int(value)
			return
		} else if let value = try? container.decode(Double.self) {
			self = .double(value)
			return
        } else {
            self = .string("")
            return
        }
    }

    // MARK: - Protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        case .double(let value):
			try container.encode(value)
        }
    }

}
