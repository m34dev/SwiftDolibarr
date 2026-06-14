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
//  CommonBusinessObject.swift
//  SwiftDolibarr
//
//  Created by William Mead on 11/11/2025.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// Base class for all Dolibarr business objects.
///
/// Provides shared properties and coding logic for ``id``, ``statusCode``,
/// ``entityId``, ``arrayOptions``, and public/private notes. Subclasses
/// override the computed ``status`` property to return domain-specific statuses.
///
/// ## Overview
///
/// This class serves as the foundation for concrete business objects such as
/// ``DolibarrThirdParty``, ``DolibarrProduct``, and ``DolibarrWarehouse``.
///
/// - SeeAlso: ``DolibarrBusinessObject``
/// - SeeAlso: ``CommonCommercialTransactionObject``
public class CommonBusinessObject: Equatable, Codable, DolibarrBusinessObject {
    
	// MARK: - Properties

	/// Business object ID
	public var id: String

	/// Business object status code
	///
	/// - Mapped Dolibarr property: **status** or **statut** (legacy)
	public var statusCode: String

	/// Business object entity ID
	///
	/// - Mapped Dolibarr property: **entity**
	public var entityId: String?

	/// Business object extra fields
	///
	/// - Mapped Dolibarr property: **array_options**
	public var arrayOptions: [String: MultiType]?

	/// Business object public note
	///
	/// - Mapped Dolibarr property: **note_public**
	public var notePublic: String?

	/// Business object private note
	///
	/// - Mapped Dolibarr property: **note_private**
	public var notePrivate: String?

	// Computed

	/// Associated business object status type
	public var status: DolibarrObjectStatus {
		return .unknown
	}

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case id
		case statusCode = "status"
		case statusCodeLegacy = "statut"
		case entityId = "entity"
		case arrayOptions = "array_options"
		case notePublic = "note_public"
		case notePrivate = "note_private"
	}

	// MARK: - Inits

	public init(
		id: String = "",
		statusCode: String = "",
		entityId: String? = nil,
		arrayOptions: [String: MultiType]? = nil,
		notePublic: String? = nil,
		notePrivate: String? = nil
	) {
		self.id = id
		self.statusCode = statusCode
		self.entityId = entityId
		self.arrayOptions = arrayOptions
		self.notePublic = notePublic
		self.notePrivate = notePrivate
	}

	public required init(from decoder: any Decoder) throws {
		do {
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
			#endif
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.id = try container.decode(String.self, forKey: .id)
			if let status = try? container.decode(MultiType.self, forKey: .statusCode), !status.stringValue.isEmpty {
				self.statusCode = status.stringValue
			} else if let status = try? container.decode(MultiType.self, forKey: .statusCodeLegacy),
				!status.stringValue.isEmpty {
				self.statusCode = status.stringValue
			} else {
				self.statusCode = ""
			}
			self.entityId = try container.decodeIfPresent(String.self, forKey: .entityId)
			if let dictArrayOptions = try? container.decode([String: MultiType].self, forKey: .arrayOptions) {
				self.arrayOptions = Dictionary(
					uniqueKeysWithValues: dictArrayOptions.map { key, value in
						(key.hasPrefix("options_") ? String(key.dropFirst("options_".count)) : key, value)
					}
				)
			} else {
				self.arrayOptions = nil
			}
			self.notePublic = try container.decodeIfPresent(String.self, forKey: .notePublic)
			self.notePrivate = try container.decodeIfPresent(String.self, forKey: .notePrivate)
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
    
    public init(copying source: CommonBusinessObject) {
        self.id = source.id
        self.statusCode = source.statusCode
        self.entityId = source.entityId
        self.arrayOptions = source.arrayOptions
        self.notePublic = source.notePublic
        self.notePrivate = source.notePrivate
    }
    
    // MARK: - Methods
    
    public func copy(_ source: CommonBusinessObject) {
        self.id = source.id
        self.statusCode = source.statusCode
        self.entityId = source.entityId
        self.arrayOptions = source.arrayOptions
        self.notePublic = source.notePublic
        self.notePrivate = source.notePrivate
    }

	// MARK: - Protocol methods

	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(statusCode)
		hasher.combine(optional: entityId)
        hasher.combine(optional: arrayOptions)
		hasher.combine(optional: notePublic)
		hasher.combine(optional: notePrivate)
	}

	public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfNotEmpty(id, forKey: .id)
		try container.encodeIfNotEmpty(statusCode, forKey: .statusCode)
		try container.encodeIfPresentAndNotEmpty(entityId, forKey: .entityId)
        try container.encodeIfPresent(arrayOptions, forKey: .arrayOptions)
		try container.encodeIfPresent(notePublic, forKey: .notePublic)
		try container.encodeIfPresent(notePrivate, forKey: .notePrivate)
	}

	public static func == (lhs: CommonBusinessObject, rhs: CommonBusinessObject) -> Bool {
		lhs.id == rhs.id
	}

}
