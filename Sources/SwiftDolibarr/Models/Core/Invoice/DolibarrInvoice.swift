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
//  DolibarrInvoice.swift
//  SwiftDolibarr
//
//  Created by William Mead on 18/02/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A Dolibarr invoice object.
///
/// Maps to the Dolibarr `/invoices` REST API endpoint. Inherits common commercial
/// transaction properties such as third-party ID and totals from
/// ``CommonCommercialTransactionObject``.
///
/// ## Overview
///
/// Each invoice has a ``type`` (standard, replacement, credit note, etc.),
/// a ``status``, and an array of ``DolibarrInvoiceLine`` items. The ``close``
/// property provides the reason when an invoice has been closed.
///
/// - Note: Requires the **Facture** module to be activated in Dolibarr.
/// - SeeAlso: ``DolibarrInvoiceLine``
/// - SeeAlso: ``DolibarrInvoiceType``
/// - SeeAlso: ``DolibarrInvoiceClose``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrInvoice: CommonCommercialTransactionObject {

	// MARK: - Properties

	// Required

	/// Invoice date (Unix timestamp)
	public var date: Int

	/// Invoice type code
	///
	/// - Mapped Dolibarr property: **type**
	public var typeCode: String

	/// Invoice paid code
	///
	/// - Mapped Dolibarr property: **paye**
	public var paidCode: String

	/// Invoice lines
	public var lines: [DolibarrInvoiceLine]

	// Optional

	/// Invoice client reference
	///
	/// - Mapped Dolibarr property: **ref_client**
	public var clientRef: String?

	/// Invoice validation date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_validation**
	public var dateValidation: Int?

	/// Invoice author user ID
	///
	/// - Mapped Dolibarr property: **fk_user_author**
	public var userAuthorId: String?

	/// Invoice last generated main document path
	///
	/// - Mapped Dolibarr property: **last_main_doc**
	public var lastMainDoc: String?

	/// Invoice payment method ID
	///
	/// - Mapped Dolibarr property: **mode_reglement_id**
	public var paymentMethodId: String?

	/// Invoice payment terms ID
	///
	/// - Mapped Dolibarr property: **cond_reglement_id**
	public var paymentTermsId: String?

	/// Invoice source reason ID
	///
	/// - Mapped Dolibarr property: **demand_reason_id**
	public var sourceReasonId: String?

	/// Invoice external contact IDs
	///
	/// - Mapped Dolibarr property: **contacts_ids**
	public var externalContactIds: [String]?

	/// Invoice close code
	///
	/// - Mapped Dolibarr property: **close_code**
	public var closeCode: String?

	/// Invoice close note
	///
	/// - Mapped Dolibarr property: **close_note**
	public var closeNote: String?

	// Computed

	/// Associated invoice status type
	override public var status: DolibarrObjectStatus {
		guard let status = DolibarrObjectStatus.invoices.first(where: { $0.code == statusCode }) else { return .unknown }
		return status
	}

	/// Associated invoice type
	public var type: DolibarrInvoiceType {
		guard let type = DolibarrInvoiceType.allTypes.first(where: { $0.code == typeCode }) else { return .unknown }
		return type
	}

	/// Associated invoice close reason
	public var close: DolibarrInvoiceClose? {
		guard let close = DolibarrInvoiceClose.allClose.first(where: { $0.code == closeCode }) else { return .unknown }
		return close
	}

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case lines
		case clientRef = "ref_client"
		case userAuthorId = "fk_user_author"
		case date
		case dateValidation = "date_validation"
		case lastMainDoc = "last_main_doc"
		case paymentMethodId = "mode_reglement_id"
		case paymentTermsId = "cond_reglement_id"
		case sourceReasonId = "demand_reason_id"
		case externalContactIds = "contacts_ids"
		case typeCode = "type"
		case paidCode = "paye"
		case closeCode = "close_code"
		case closeNote = "close_note"
	}

	// MARK: - Inits

	public init(
		date: Int = 0,
		typeCode: String = "0",
		paidCode: String = "0",
		lines: [DolibarrInvoiceLine] = [],
		clientRef: String? = nil,
		dateValidation: Int? = nil,
		userAuthorId: String? = nil,
		lastMainDoc: String? = nil,
		paymentMethodId: String? = nil,
		paymentTermsId: String? = nil,
		sourceReasonId: String? = nil,
		externalContactIds: [String]? = nil,
		closeCode: String? = nil,
		closeNote: String? = nil,
		thirdPartyId: String = "",
		statusCode: String = "0",
		ref: String = "",
		totalExclTax: String = "0.00",
		totalTax: String = "0.00",
		totalInclTax: String = "0.00",
		multicurrencyCode: String? = nil,
		linkedObjectsIds: [String: [String: String]]? = nil,
		id: String = "",
		arrayOptions: [String: MultiType]? = nil,
		notePublic: String? = nil,
		notePrivate: String? = nil
	) {
		self.date = date
		self.typeCode = typeCode
		self.paidCode = paidCode
		self.lines = lines
		self.clientRef = clientRef
		self.dateValidation = dateValidation
		self.userAuthorId = userAuthorId
		self.lastMainDoc = lastMainDoc
		self.paymentMethodId = paymentMethodId
		self.paymentTermsId = paymentTermsId
		self.sourceReasonId = sourceReasonId
		self.externalContactIds = externalContactIds
		self.closeCode = closeCode
		self.closeNote = closeNote
		super.init(
			thirdPartyId: thirdPartyId,
			statusCode: statusCode,
			ref: ref,
			totalExclTax: totalExclTax,
			totalTax: totalTax,
			totalInclTax: totalInclTax,
			multicurrencyCode: multicurrencyCode,
			linkedObjectsIds: linkedObjectsIds,
			id: id,
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
			self.date = try container.decode(Int.self, forKey: .date)
			self.typeCode = try container.decode(String.self, forKey: .typeCode)
			self.paidCode = try container.decode(String.self, forKey: .paidCode)
			self.lines = try container.decode([DolibarrInvoiceLine].self, forKey: .lines)
			self.clientRef = try container.decodeIfPresent(String.self, forKey: .clientRef)
			self.dateValidation = try container.decodeIfPresent(MultiType.self, forKey: .dateValidation)?.intValue
			self.userAuthorId = try container.decodeIfPresent(String.self, forKey: .userAuthorId)
			self.lastMainDoc = try container.decodeIfPresent(String.self, forKey: .lastMainDoc)
			self.paymentMethodId = try container.decodeIfPresent(String.self, forKey: .paymentMethodId)
			self.paymentTermsId = try container.decodeIfPresent(String.self, forKey: .paymentTermsId)
			self.sourceReasonId = try container.decodeIfPresent(String.self, forKey: .sourceReasonId)
			self.externalContactIds = try container.decodeIfPresent([String].self, forKey: .externalContactIds)
			self.closeCode = try container.decodeIfPresent(String.self, forKey: .closeCode)
			self.closeNote = try container.decodeIfPresent(String.self, forKey: .closeNote)
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

    public init(copying source: DolibarrInvoice) {
        self.date = source.date
        self.typeCode = source.typeCode
        self.paidCode = source.paidCode
        self.lines = source.lines
        self.clientRef = source.clientRef
        self.dateValidation = source.dateValidation
        self.userAuthorId = source.userAuthorId
        self.lastMainDoc = source.lastMainDoc
        self.paymentMethodId = source.paymentMethodId
        self.paymentTermsId = source.paymentTermsId
        self.sourceReasonId = source.sourceReasonId
        self.externalContactIds = source.externalContactIds
        self.closeCode = source.closeCode
        self.closeNote = source.closeNote
        super.init(copying: source)
    }

    // MARK: - Methods

    public func copy(_ source: DolibarrInvoice) {
        self.date = source.date
        self.typeCode = source.typeCode
        self.paidCode = source.paidCode
        self.lines = source.lines
        self.clientRef = source.clientRef
        self.dateValidation = source.dateValidation
        self.userAuthorId = source.userAuthorId
        self.lastMainDoc = source.lastMainDoc
        self.paymentMethodId = source.paymentMethodId
        self.paymentTermsId = source.paymentTermsId
        self.sourceReasonId = source.sourceReasonId
        self.externalContactIds = source.externalContactIds
        self.closeCode = source.closeCode
        self.closeNote = source.closeNote
        super.copy(source)
    }

	// MARK: - Protocol methods

	override public func hash(into hasher: inout Hasher) {
		hasher.combine(date)
		hasher.combine(typeCode)
		hasher.combine(paidCode)
		hasher.combine(lines)
		hasher.combine(optional: clientRef)
		hasher.combine(optional: dateValidation)
		hasher.combine(optional: userAuthorId)
		hasher.combine(optional: lastMainDoc)
		hasher.combine(optional: paymentMethodId)
		hasher.combine(optional: paymentTermsId)
		hasher.combine(optional: sourceReasonId)
		hasher.combine(optional: externalContactIds)
		hasher.combine(optional: closeCode)
		hasher.combine(optional: closeNote)
		super.hash(into: &hasher)
	}

	override public func isEqual(to other: CommonBusinessObject) -> Bool {
		guard let other = other as? DolibarrInvoice else { return false }
		return date == other.date
		&& typeCode == other.typeCode
		&& paidCode == other.paidCode
		&& lines == other.lines
		&& clientRef == other.clientRef
		&& dateValidation == other.dateValidation
		&& userAuthorId == other.userAuthorId
		&& lastMainDoc == other.lastMainDoc
		&& paymentMethodId == other.paymentMethodId
		&& paymentTermsId == other.paymentTermsId
		&& sourceReasonId == other.sourceReasonId
		&& externalContactIds == other.externalContactIds
		&& closeCode == other.closeCode
		&& closeNote == other.closeNote
		&& super.isEqual(to: other)
	}

	override public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfNotZero(date, forKey: .date)
		try container.encode(typeCode, forKey: .typeCode)
		try container.encode(paidCode, forKey: .paidCode)
		try container.encode(lines, forKey: .lines)
		try container.encodeIfPresent(clientRef, forKey: .clientRef)
		try container.encodeIfPresent(dateValidation, forKey: .dateValidation)
		try container.encodeIfPresent(userAuthorId, forKey: .userAuthorId)
		try container.encodeIfPresent(lastMainDoc, forKey: .lastMainDoc)
		try container.encodeIfPresent(paymentMethodId, forKey: .paymentMethodId)
		try container.encodeIfPresent(paymentTermsId, forKey: .paymentTermsId)
		try container.encodeIfPresent(sourceReasonId, forKey: .sourceReasonId)
		try container.encodeIfPresent(externalContactIds, forKey: .externalContactIds)
		try container.encodeIfPresent(closeCode, forKey: .closeCode)
		try container.encodeIfPresent(closeNote, forKey: .closeNote)
		try super.encode(to: encoder)
	}

}
