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
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
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

	// Audit (read-only: never encoded, not part of equality)

	/// Business object creation date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_creation**, or **datec**, **date_c** (legacy)
	public var creationTimestamp: Int?

	/// Business object last modification date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_modification**, or **date_m**, **tms** (legacy)
	public var modificationTimestamp: Int?

	/// Business object validation date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_validation**, or **date_valid** (legacy)
	public var validationTimestamp: Int?

	/// ID of the user who created the business object
	///
	/// - Mapped Dolibarr property: **user_creation_id**, or **user_author_id**, **fk_user_author**, **fk_user_creat** (legacy)
	public var creationUserId: String?

	/// ID of the user who last modified the business object
	///
	/// - Mapped Dolibarr property: **user_modification_id**, or **fk_user_modif** (legacy)
	public var modificationUserId: String?

	/// ID of the user who validated the business object
	///
	/// - Mapped Dolibarr property: **user_validation_id**, or **fk_user_valid** (legacy)
	public var validationUserId: String?

	// Computed

	/// Associated business object status type
	public var status: DolibarrObjectStatus {
		return .unknown
	}

	/// Business object creation date
	///
	/// Subclasses with object-specific creation fields override this and fall back to `super`.
	public var dateCreated: Date? {
		Self.date(from: creationTimestamp)
	}

	/// Business object last modification date
	///
	/// Subclasses with object-specific modification fields override this and fall back to `super`.
	public var dateModified: Date? {
		Self.date(from: modificationTimestamp)
	}

	/// Business object validation date
	///
	/// Subclasses with object-specific validation fields override this and fall back to `super`.
	public var dateValidated: Date? {
		Self.date(from: validationTimestamp)
	}

	/// ID of the user who created the business object
	///
	/// Subclasses with object-specific author fields override this and fall back to `super`.
	public var createdByUserId: String? {
		creationUserId
	}

	/// ID of the user who last modified the business object
	///
	/// Subclasses with object-specific fields override this and fall back to `super`.
	public var modifiedByUserId: String? {
		modificationUserId
	}

	/// ID of the user who validated the business object
	///
	/// Subclasses with object-specific fields override this and fall back to `super`.
	public var validatedByUserId: String? {
		validationUserId
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

	/// Audit keys exposed by Dolibarr's `CommonObject`, with their legacy variants.
	///
	/// Decoded only, so that create and update payloads never send them back.
	enum AuditCodingKeys: String, CodingKey {
		case dateCreation = "date_creation"
		case dateCreationLegacy = "datec"
		case dateCreationProject = "date_c"
		case dateModification = "date_modification"
		case dateModificationProject = "date_m"
		case dateModificationLegacy = "tms"
		case dateValidation = "date_validation"
		case dateValidationLegacy = "date_valid"
		case userCreationId = "user_creation_id"
		case userAuthorId = "user_author_id"
		case userAuthorIdLegacy = "fk_user_author"
		case userCreationIdLegacy = "fk_user_creat"
		case userModificationId = "user_modification_id"
		case userModificationIdLegacy = "fk_user_modif"
		case userValidationId = "user_validation_id"
		case userValidationIdLegacy = "fk_user_valid"
	}

	// MARK: - Inits

	public init(
		id: String = "",
		statusCode: String = "",
		entityId: String? = nil,
		arrayOptions: [String: MultiType]? = nil,
		notePublic: String? = nil,
		notePrivate: String? = nil,
		creationTimestamp: Int? = nil,
		modificationTimestamp: Int? = nil,
		validationTimestamp: Int? = nil,
		creationUserId: String? = nil,
		modificationUserId: String? = nil,
		validationUserId: String? = nil
	) {
		self.id = id
		self.statusCode = statusCode
		self.entityId = entityId
		self.arrayOptions = arrayOptions
		self.notePublic = notePublic
		self.notePrivate = notePrivate
		self.creationTimestamp = creationTimestamp
		self.modificationTimestamp = modificationTimestamp
		self.validationTimestamp = validationTimestamp
		self.creationUserId = creationUserId
		self.modificationUserId = modificationUserId
		self.validationUserId = validationUserId
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
			let auditContainer = try decoder.container(keyedBy: AuditCodingKeys.self)
			self.creationTimestamp = Self.firstTimestamp(in: auditContainer, forKeys: [.dateCreation, .dateCreationLegacy, .dateCreationProject])
			self.modificationTimestamp = Self.firstTimestamp(in: auditContainer, forKeys: [.dateModification, .dateModificationProject, .dateModificationLegacy])
			self.validationTimestamp = Self.firstTimestamp(in: auditContainer, forKeys: [.dateValidation, .dateValidationLegacy])
			self.creationUserId = Self.firstUserId(
				in: auditContainer,
				forKeys: [.userCreationId, .userAuthorId, .userAuthorIdLegacy, .userCreationIdLegacy]
			)
			self.modificationUserId = Self.firstUserId(in: auditContainer, forKeys: [.userModificationId, .userModificationIdLegacy])
			self.validationUserId = Self.firstUserId(in: auditContainer, forKeys: [.userValidationId, .userValidationIdLegacy])
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
		self.creationTimestamp = source.creationTimestamp
		self.modificationTimestamp = source.modificationTimestamp
		self.validationTimestamp = source.validationTimestamp
		self.creationUserId = source.creationUserId
		self.modificationUserId = source.modificationUserId
		self.validationUserId = source.validationUserId
	}

	// MARK: - Methods
	
	public func copy(_ source: CommonBusinessObject) {
		self.id = source.id
		self.statusCode = source.statusCode
		self.entityId = source.entityId
		self.arrayOptions = source.arrayOptions
		self.notePublic = source.notePublic
		self.notePrivate = source.notePrivate
		self.creationTimestamp = source.creationTimestamp
		self.modificationTimestamp = source.modificationTimestamp
		self.validationTimestamp = source.validationTimestamp
		self.creationUserId = source.creationUserId
		self.modificationUserId = source.modificationUserId
		self.validationUserId = source.validationUserId
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

	/// Value equality used by ``==``.
	///
	/// Read-only audit fields (``creationTimestamp``, ``modificationUserId``…) are
	/// not compared: they are never encoded, so an object must stay equal to its
	/// encode/decode round trip and to an edited copy whose content is unchanged.
	///
	/// `==` is static and cannot be overridden, so subclasses that override
	/// `hash(into:)` must also override this method to compare the same fields
	/// and call `super`, keeping equal objects' hashes equal.
	public func isEqual(to other: CommonBusinessObject) -> Bool {
		type(of: self) == type(of: other)
		&& id == other.id
		&& statusCode == other.statusCode
		&& entityId == other.entityId
		&& arrayOptions == other.arrayOptions
		&& notePublic == other.notePublic
		&& notePrivate == other.notePrivate
	}

	public static func == (lhs: CommonBusinessObject, rhs: CommonBusinessObject) -> Bool {
		lhs.isEqual(to: rhs)
	}

	// MARK: - Audit helpers

	/// Converts an optional Unix timestamp to a date, treating `0` as missing.
	static func date(from timestamp: Int?) -> Date? {
		guard let timestamp, timestamp > 0 else { return nil }
		return Date(timeIntervalSince1970: TimeInterval(timestamp))
	}

	/// Normalises a user ID, treating empty strings and `"0"` as missing.
	static func userId(_ value: String?) -> String? {
		guard let value, !value.isEmpty, value != "0" else { return nil }
		return value
	}

	/// First positive timestamp found among `keys`; tolerates numbers, numeric strings, empty strings and nulls.
	static func firstTimestamp<Key: CodingKey>(in container: KeyedDecodingContainer<Key>, forKeys keys: [Key]) -> Int? {
		for key in keys {
			if let value = (try? container.decodeIfPresent(MultiType.self, forKey: key))??.intValue, value > 0 {
				return value
			}
		}
		return nil
	}

	/// First non-empty, non-zero user ID found among `keys`; tolerates numbers, strings, nulls and nested objects.
	static func firstUserId<Key: CodingKey>(in container: KeyedDecodingContainer<Key>, forKeys keys: [Key]) -> String? {
		for key in keys {
			if let value = (try? container.decodeIfPresent(MultiType.self, forKey: key))??.stringValue,
			   !value.isEmpty, value != "0" {
				return value
			}
		}
		return nil
	}

}
