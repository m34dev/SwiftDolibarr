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
//  MulticompanyEntity.swift
//  SwiftDolibarr
//
//  Created by William Mead on 07/07/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class MulticompanyEntity: Hashable, Codable, DolibarrObject {


	// MARK: - Properties

	/// Entity ID
	public var id: String

	/// Entity label
	public var label: String

	/// Entity description
	public var description: String

	/// Entity country ID
	///
	/// - Mapped Dolibarr property: **country_id**
	public var countryId: String

	/// Entity country code
	///
	/// - Mapped Dolibarr property: **country_code**
	public var countryCode: String

	/// Entity currency code
	///
	/// - Mapped Dolibarr property: **currency_code**
	public var currencyCode: String

	/// Entity visible state
	public var visible: String

	/// Entity active state
	public var active: String

	/// Entity extra fields
	///
	/// - Mapped Dolibarr property: **array_options**
	public var arrayOptions: [String: MultiType]?

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case id
		case label
		case description
		case countryId = "country_id"
		case countryCode = "country_code"
		case currencyCode = "currency_code"
		case visible
		case active
		case arrayOptions = "array_options"
	}

	// MARK: - Inits

	public init(
		id: String = "",
		label: String = "",
		description: String = "",
		countryId: String = "",
		countryCode: String = "",
		currencyCode: String = "",
		visible: String = "",
		active: String = "",
		arrayOptions: [String: MultiType]? = nil
	) {
		self.id = id
		self.label = label
		self.description = description
		self.countryId = countryId
		self.countryCode = countryCode
		self.currencyCode = currencyCode
		self.visible = visible
		self.active = active
		self.arrayOptions = arrayOptions
	}

	public init(from decoder: any Decoder) throws {
		do {
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
			#endif
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.id = try container.decode(MultiType.self, forKey: .id).stringValue
			self.label = try container.decode(String.self, forKey: .label)
			self.description = try container.decode(String.self, forKey: .description)
			self.countryId = try container.decode(MultiType.self, forKey: .countryId).stringValue
			self.countryCode = try container.decode(String.self, forKey: .countryCode)
			self.currencyCode = try container.decode(String.self, forKey: .currencyCode)
			self.visible = try container.decode(MultiType.self, forKey: .visible).stringValue
			self.active = try container.decode(MultiType.self, forKey: .active).stringValue
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

	// MARK: - Protocol methods

	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(label)
		hasher.combine(description)
		hasher.combine(countryId)
		hasher.combine(countryCode)
		hasher.combine(currencyCode)
		hasher.combine(visible)
		hasher.combine(active)
		hasher.combine(optional: arrayOptions)
	}

	public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfNotEmpty(id, forKey: .id)
		try container.encodeIfNotEmpty(label, forKey: .label)
		try container.encodeIfNotEmpty(description, forKey: .description)
		try container.encodeIfNotEmpty(countryId, forKey: .countryId)
		try container.encodeIfNotEmpty(countryCode, forKey: .countryCode)
		try container.encodeIfNotEmpty(currencyCode, forKey: .currencyCode)
		try container.encodeIfNotEmpty(visible, forKey: .visible)
		try container.encodeIfNotEmpty(active, forKey: .active)
		try container.encodeIfPresent(arrayOptions, forKey: .arrayOptions)
	}

	public static func == (lhs: MulticompanyEntity, rhs: MulticompanyEntity) -> Bool {
		lhs.id == rhs.id
		&& lhs.label == rhs.label
		&& lhs.description == rhs.description
		&& lhs.countryId == rhs.countryId
		&& lhs.countryCode == rhs.countryCode
		&& lhs.currencyCode == rhs.currencyCode
		&& lhs.visible == rhs.visible
		&& lhs.active == rhs.active
		&& lhs.arrayOptions == rhs.arrayOptions
	}

}
