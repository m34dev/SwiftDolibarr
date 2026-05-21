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
//  DolibarrIntervention.swift
//  SwiftDolibarr
//
//  Created by William Mead on 06/12/2024.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A Dolibarr intervention (field service) object.
///
/// Maps to the Dolibarr `/interventions` REST API endpoint. An intervention
/// is linked to a third party via ``thirdPartyId`` and can optionally be associated
/// with a project or contract.
///
/// ## Overview
///
/// Each intervention has a ``status``, optional ``DolibarrInterventionLine`` items,
/// start/end dates, and duration.
///
/// - Note: Requires the **Fichinter** module to be activated in Dolibarr.
/// - SeeAlso: ``DolibarrInterventionLine``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrIntervention: CommonBusinessObject {

	// MARK: - Properties

	// Required

	/// Associated third party ID
	///
	/// - Mapped Dolibarr property: **socid**
	public var thirdPartyId: String

	/// Intervention reference
	public var ref: String

	/// Intervention lines
	public var lines: [DolibarrInterventionLine]

	// Optional

	/// Associated contract ID
	///
	/// - Mapped Dolibarr property: **fk_contrat**
	public var contractId: String?

	/// Associated project ID
	///
	/// - Mapped Dolibarr property: **fk_project**
	public var projectId: String?

	/// Intervention start date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **dateo**
	public var dateStart: Int?

	/// Intervention end date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **datee**
	public var dateEnd: Int?

	/// Intervention duration in seconds
	///
	/// - Mapped Dolibarr property: **duration**
	public var durationSeconds: String?

	/// Intervention description
	public var description: String?

	/// Intervention client reference
	///
	/// - Mapped Dolibarr property: **ref_client**
	public var clientRef: String?

	/// Intervention last generated main document path
	///
	/// - Mapped Dolibarr property: **last_main_doc**
	public var lastMainDoc: String?

	/// Intervention external contact IDs
	///
	/// - Mapped Dolibarr property: **contacts_ids**
	public var externalContactIds: [[String: MultiType]]?

	/// Intervention internal contact IDs
	///
	/// - Mapped Dolibarr property: **contacts_ids_internal**
	public var internalContactIds: [[String: MultiType]]?

	/// Intervention creation date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **datec**
	public var dateCreate: Int?

	/// Intervention modification date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **datem**
	public var dateModify: Int?

	/// Intervention validation date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **datev**
	public var dateValidate: Int?
    
    /// Intervention closed date (Unix timestamp)
    ///
    /// - Mapped Dolibarr property: **datet**
    public var dateClose: Int?

	// Computed

	/// Associated intervention status type
	override public var status: DolibarrObjectStatus {
		guard let status = DolibarrObjectStatus.interventions.first(where: { $0.code == statusCode }) else { return .unknown }
		return status
	}

	/// Intervention creation date
	public var dateCreated: Date? {
		guard let dateCreate else { return nil }
		return Date(timeIntervalSince1970: TimeInterval(dateCreate))
	}

	/// Intervention modification date
	public var dateModified: Date? {
		guard let dateModify else { return nil }
		return Date(timeIntervalSince1970: TimeInterval(dateModify))
	}

	/// Intervention validation date
	public var dateValidated: Date? {
		guard let dateValidate else { return nil }
		return Date(timeIntervalSince1970: TimeInterval(dateValidate))
	}
    
    /// Intervention validation date
    public var dateClosed: Date? {
        guard let dateClose else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(dateClose))
    }

	/// Intervention start date
	public var dateStarted: Date? {
		guard let dateStart else { return nil }
		return Date(timeIntervalSince1970: TimeInterval(dateStart))
	}

	/// Intervention end date
	public var dateEnded: Date? {
		guard let dateEnd else { return nil }
		return Date(timeIntervalSince1970: TimeInterval(dateEnd))
	}

	/// Intervention duration as a `Duration`
	public var duration: Duration? {
		guard let durationSeconds, let seconds = Double(durationSeconds) else { return nil }
		return .seconds(seconds)
	}

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case thirdPartyId = "socid"
		case ref
		case contractId = "fk_contrat"
		case projectId = "fk_project"
		case dateStart = "dateo"
		case dateEnd = "datee"
		case durationSeconds = "duration"
		case description
		case clientRef = "ref_client"
		case lastMainDoc = "last_main_doc"
		case lines
		case externalContactIds = "contacts_ids"
		case internalContactIds = "contacts_ids_internal"
		case dateCreate = "datec"
		case dateModify = "datem"
		case dateValidate = "datev"
        case dateClose = "datet"
	}

	// MARK: - Inits

	public init(
		thirdPartyId: String = "",
		ref: String = "",
		lines: [DolibarrInterventionLine] = [],
		contractId: String? = nil,
		projectId: String? = nil,
		dateStart: Int? = nil,
		dateEnd: Int? = nil,
		durationSeconds: String? = nil,
		description: String? = nil,
		clientRef: String? = nil,
		lastMainDoc: String? = nil,
		externalContactIds: [[String: MultiType]]? = nil,
		internalContactIds: [[String: MultiType]]? = nil,
		dateCreate: Int? = nil,
		dateModify: Int? = nil,
		dateValidate: Int? = nil,
        dateClose: Int? = nil,
		id: String = "",
		statusCode: String = "",
		arrayOptions: [String: MultiType]? = nil,
		notePublic: String? = nil,
		notePrivate: String? = nil
	) {
		self.thirdPartyId = thirdPartyId
		self.ref = ref
		self.lines = lines
		self.contractId = contractId
		self.projectId = projectId
		self.dateStart = dateStart
		self.dateEnd = dateEnd
		self.durationSeconds = durationSeconds
		self.description = description
		self.clientRef = clientRef
		self.lastMainDoc = lastMainDoc
		self.externalContactIds = externalContactIds
		self.internalContactIds = internalContactIds
		self.dateCreate = dateCreate
		self.dateModify = dateModify
		self.dateValidate = dateValidate
        self.dateClose = dateClose
		super.init(
			id: id,
			statusCode: statusCode,
			arrayOptions: arrayOptions,
			notePublic: notePublic,
			notePrivate: notePrivate
		)
	}

	public required init(from decoder: any Decoder) throws {
		do {
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
			#endif
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.thirdPartyId = try container.decode(String.self, forKey: .thirdPartyId)
			self.ref = try container.decode(String.self, forKey: .ref)
			self.lines = try container.decode([DolibarrInterventionLine].self, forKey: .lines)
			self.contractId = try container.decodeIfPresent(String.self, forKey: .contractId)
			self.projectId = try container.decodeIfPresent(String.self, forKey: .projectId)
			self.dateStart = try container.decodeIfPresent(MultiType.self, forKey: .dateStart)?.intValue
			self.dateEnd = try container.decodeIfPresent(MultiType.self, forKey: .dateEnd)?.intValue
			self.durationSeconds = try container.decodeIfPresent(String.self, forKey: .durationSeconds)
			self.description = try container.decodeIfPresent(String.self, forKey: .description)
			self.clientRef = try container.decodeIfPresent(String.self, forKey: .clientRef)
			self.lastMainDoc = try container.decodeIfPresent(String.self, forKey: .lastMainDoc)
			self.externalContactIds = try container.decodeIfPresent([[String: MultiType]].self, forKey: .externalContactIds)
			self.internalContactIds = try container.decodeIfPresent([[String: MultiType]].self, forKey: .internalContactIds)
			self.dateCreate = try container.decodeIfPresent(Int.self, forKey: .dateCreate)
			self.dateModify = try container.decodeIfPresent(Int.self, forKey: .dateModify)
            self.dateValidate = try container.decodeIfPresent(MultiType.self, forKey: .dateValidate)?.intValue
            self.dateClose = try container.decodeIfPresent(MultiType.self, forKey: .dateClose)?.intValue
			try super.init(from: decoder)
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
    
    public init(copying source: DolibarrIntervention) {
        self.thirdPartyId = source.thirdPartyId
        self.ref = source.ref
        self.lines = source.lines
        self.contractId = source.contractId
        self.projectId = source.projectId
        self.dateStart = source.dateStart
        self.dateEnd = source.dateEnd
        self.durationSeconds = source.durationSeconds
        self.description = source.description
        self.clientRef = source.clientRef
        self.lastMainDoc = source.lastMainDoc
        self.externalContactIds = source.externalContactIds
        self.internalContactIds = source.internalContactIds
        self.dateCreate = source.dateCreate
        self.dateModify = source.dateModify
        self.dateValidate = source.dateValidate
        self.dateClose = source.dateClose
        super.init(copying: source)
    }
    
    // MARK: - Methids
    
    public func copy(_ source: DolibarrIntervention) {
        self.thirdPartyId = source.thirdPartyId
        self.ref = source.ref
        self.lines = source.lines
        self.contractId = source.contractId
        self.projectId = source.projectId
        self.dateStart = source.dateStart
        self.dateEnd = source.dateEnd
        self.durationSeconds = source.durationSeconds
        self.description = source.description
        self.clientRef = source.clientRef
        self.lastMainDoc = source.lastMainDoc
        self.externalContactIds = source.externalContactIds
        self.internalContactIds = source.internalContactIds
        self.dateCreate = source.dateCreate
        self.dateModify = source.dateModify
        self.dateValidate = source.dateValidate
        self.dateClose = source.dateClose
        super.copy(source)
    }

	// MARK: - Protocol methods

	override public func hash(into hasher: inout Hasher) {
		hasher.combine(thirdPartyId)
		hasher.combine(ref)
		hasher.combine(lines)
		hasher.combine(optional: contractId)
		hasher.combine(optional: projectId)
		hasher.combine(optional: dateStart)
		hasher.combine(optional: dateEnd)
		hasher.combine(optional: durationSeconds)
		hasher.combine(optional: description)
		hasher.combine(optional: clientRef)
		hasher.combine(optional: lastMainDoc)
		hasher.combine(optional: externalContactIds)
		hasher.combine(optional: internalContactIds)
		hasher.combine(optional: dateCreate)
		hasher.combine(optional: dateModify)
		hasher.combine(optional: dateValidate)
        hasher.combine(optional: dateClose)
		super.hash(into: &hasher)
	}

	override public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfNotEmpty(thirdPartyId, forKey: .thirdPartyId)
		try container.encodeIfNotEmpty(ref, forKey: .ref)
		try container.encodeIfPresent(contractId, forKey: .contractId)
		try container.encodeIfPresent(projectId, forKey: .projectId)
		try container.encodeIfPresent(dateStart, forKey: .dateStart)
		try container.encodeIfPresent(dateEnd, forKey: .dateEnd)
		try container.encodeIfPresent(durationSeconds, forKey: .durationSeconds)
		try container.encodeIfPresent(description, forKey: .description)
		try container.encodeIfPresent(clientRef, forKey: .clientRef)
		try container.encodeIfPresent(lastMainDoc, forKey: .lastMainDoc)
		try container.encodeIfPresent(dateCreate, forKey: .dateCreate)
		try container.encodeIfPresent(dateModify, forKey: .dateModify)
		try container.encodeIfPresent(dateValidate, forKey: .dateValidate)
        try container.encodeIfPresent(dateClose, forKey: .dateClose)
		try super.encode(to: encoder)
	}

}
