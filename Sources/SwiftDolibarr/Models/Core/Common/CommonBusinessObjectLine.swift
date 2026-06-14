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
//  CommonBusinessObjectLine.swift
//  SwiftDolibarr
//
//  Created by William Mead on 09/02/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// Base class for all Dolibarr business object line items.
///
/// Provides shared ``id``, ``rang`` (sort order), and ``arrayOptions``
/// (extra fields) properties with coding logic. Subclasses add
/// domain-specific line item fields.
///
/// - SeeAlso: ``CommonCommercialTransactionObjectLine``
/// - SeeAlso: ``DolibarrInterventionLine``
public class CommonBusinessObjectLine: Equatable, Hashable, Codable, DolibarrObject {

	// MARK: - Properties

	// Required

	/// Business object line ID
	public var id: String

	/// Business object line sort order
	public var rang: String

	// Optional

	/// Business object line extra fields
	///
	/// - Mapped Dolibarr property: **array_options**
	public var arrayOptions: [String: MultiType]?

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case id
		case rang
		case arrayOptions = "array_options"
	}

	// MARK: - Inits

	public init(
		id: String = "",
		rang: String = "",
		arrayOptions: [String: MultiType]? = nil
	) {
		self.id = id
		self.rang = rang
		self.arrayOptions = arrayOptions
	}

	public required init(from decoder: Decoder) throws {
		do {
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
			#endif
			let container = try decoder.container(keyedBy: CodingKeys.self)
			id = try container.decode(String.self, forKey: .id)
			rang = try container.decode(String.self, forKey: .rang)
			if let dictArrayOptions = try? container.decode([String: MultiType].self, forKey: .arrayOptions) {
				self.arrayOptions = Dictionary(
					uniqueKeysWithValues: dictArrayOptions.map { key, value in
						(key.hasPrefix("options_") ? String(key.dropFirst("options_".count)) : key, value)
					}
				)
			} else {
				self.arrayOptions = nil
			}
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logWithoutSignal("\(Self.self).init.decoded", category: .api)
			#endif
		} catch let error as DecodingError {
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logDecodingError(error, decodeContext: "\(Self.self).init")
			#endif
			throw error
		} catch {
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logErrorWithSignal(error, context: "\(Self.self).init", category: .api)
			#endif
			throw error
		}
	}

    public init(copying source: CommonBusinessObjectLine) {
        self.id = source.id
        self.rang = source.rang
        self.arrayOptions = source.arrayOptions
    }

    // MARK: - Methods

    public func copy(_ source: CommonBusinessObjectLine) {
        self.id = source.id
        self.rang = source.rang
        self.arrayOptions = source.arrayOptions
    }

	// MARK: - Protocol methods

	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(rang)
		hasher.combine(optional: arrayOptions)
	}

	public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfNotEmpty(id, forKey: .id)
		try container.encode(rang, forKey: .rang)
		try container.encodeIfPresent(arrayOptions, forKey: .arrayOptions)
	}

	static public func == (lhs: CommonBusinessObjectLine, rhs: CommonBusinessObjectLine) -> Bool {
		lhs.id == rhs.id
	}

}
