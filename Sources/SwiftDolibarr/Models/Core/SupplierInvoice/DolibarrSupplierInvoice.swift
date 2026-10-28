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
//  DolibarrSupplierInvoice.swift
//  SwiftDolibarr
//
//  Created by William Mead on 15/09/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A Dolibarr supplier invoice object.
///
/// Maps to the Dolibarr `/supplierinvoices` REST API endpoint. Inherits common commercial
/// transaction properties such as third-party ID and totals from
/// ``CommonCommercialTransactionObject``.
///
/// ## Overview
///
/// Each supplier invoice has a ``type`` (standard, replacement, credit note, deposit),
/// a ``status``, and an array of ``DolibarrSupplierInvoiceLine`` items. The ``close``
/// property provides the reason when a supplier invoice has been closed. The inherited
/// ``thirdPartyId`` represents the **supplier's** third-party ID.
///
/// - Note: Requires the **Supplier invoice (Facture fournisseur)** module to be activated in Dolibarr.
/// - SeeAlso: ``DolibarrSupplierInvoiceLine``
/// - SeeAlso: ``DolibarrInvoiceType``
/// - SeeAlso: ``DolibarrSupplierInvoiceClose``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrSupplierInvoice: CommonCommercialTransactionObject {

	// MARK: - Properties

	// Required

	/// Supplier invoice date (Unix timestamp)
	public var date: Int

	/// Supplier invoice type code
	///
	/// - Mapped Dolibarr property: **type**
	public var typeCode: String

	/// Supplier invoice paid code
	///
	/// - Mapped Dolibarr property: **paye**
	public var paidCode: String

	/// Supplier invoice lines
	public var lines: [DolibarrSupplierInvoiceLine]

	// Optional

	/// Supplier's own reference for this invoice
	///
	/// - Mapped Dolibarr property: **ref_supplier**
	public var supplierRef: String?

	/// Supplier invoice creation date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **datec**
	public var dateCreation: Int?

	/// Supplier invoice validation date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_validation**
	public var dateValidation: Int?

	/// Supplier invoice payment due date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_echeance**
	public var dueDate: Int?

	/// Supplier invoice last generated main document path
	///
	/// - Mapped Dolibarr property: **last_main_doc**
	public var lastMainDoc: String?

	/// Supplier invoice author user ID
	///
	/// - Mapped Dolibarr property: **user_creation_id**
	public var userAuthorId: String?

	/// Supplier invoice payment method ID
	///
	/// - Mapped Dolibarr property: **mode_reglement_id**
	public var paymentMethodId: String?

	/// Supplier invoice payment terms ID
	///
	/// - Mapped Dolibarr property: **cond_reglement_id**
	public var paymentTermsId: String?

	/// Supplier invoice close code
	///
	/// - Mapped Dolibarr property: **close_code**
	public var closeCode: String?

	/// Supplier invoice close note
	///
	/// - Mapped Dolibarr property: **close_note**
	public var closeNote: String?

	// Computed

	/// Associated supplier invoice status type
	override public var status: DolibarrObjectStatus {
		guard let status = DolibarrObjectStatus.supplierInvoices.first(where: { $0.code == statusCode }) else { return .unknown }
		return status
	}

	/// Associated supplier invoice type
	public var type: DolibarrInvoiceType {
		guard let type = DolibarrInvoiceType.allTypes.first(where: { $0.code == typeCode }) else { return .unknown }
		return type
	}

	/// Associated supplier invoice close reason
	public var close: DolibarrSupplierInvoiceClose? {
		guard let close = DolibarrSupplierInvoiceClose.allClose.first(where: { $0.code == closeCode }) else { return .unknown }
		return close
	}

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case lines
		case supplierRef = "ref_supplier"
		case userAuthorId = "user_creation_id"
		case date
		case dateCreation = "datec"
		case dateValidation = "date_validation"
		case dueDate = "date_echeance"
		case lastMainDoc = "last_main_doc"
		case paymentMethodId = "mode_reglement_id"
		case paymentTermsId = "cond_reglement_id"
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
		lines: [DolibarrSupplierInvoiceLine] = [],
		supplierRef: String? = nil,
		dateCreation: Int? = nil,
		dateValidation: Int? = nil,
		dueDate: Int? = nil,
		lastMainDoc: String? = nil,
		userAuthorId: String? = nil,
		paymentMethodId: String? = nil,
		paymentTermsId: String? = nil,
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
		self.supplierRef = supplierRef
		self.dateCreation = dateCreation
		self.dateValidation = dateValidation
		self.dueDate = dueDate
		self.lastMainDoc = lastMainDoc
		self.userAuthorId = userAuthorId
		self.paymentMethodId = paymentMethodId
		self.paymentTermsId = paymentTermsId
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
			self.typeCode = try container.decode(MultiType.self, forKey: .typeCode).stringValue
			self.paidCode = try container.decode(MultiType.self, forKey: .paidCode).stringValue
			self.lines = try container.decode([DolibarrSupplierInvoiceLine].self, forKey: .lines)
			self.supplierRef = try container.decodeIfPresent(String.self, forKey: .supplierRef)
			self.dateCreation = try container.decodeIfPresent(MultiType.self, forKey: .dateCreation)?.intValue
			self.dateValidation = try container.decodeIfPresent(MultiType.self, forKey: .dateValidation)?.intValue
			self.dueDate = try container.decodeIfPresent(MultiType.self, forKey: .dueDate)?.intValue
			self.lastMainDoc = try container.decodeIfPresent(String.self, forKey: .lastMainDoc)
			self.userAuthorId = try container.decodeIfPresent(String.self, forKey: .userAuthorId)
			self.paymentMethodId = try container.decodeIfPresent(String.self, forKey: .paymentMethodId)
			self.paymentTermsId = try container.decodeIfPresent(String.self, forKey: .paymentTermsId)
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

    public init(copying source: DolibarrSupplierInvoice) {
        self.date = source.date
        self.typeCode = source.typeCode
        self.paidCode = source.paidCode
        self.lines = source.lines
        self.supplierRef = source.supplierRef
        self.dateCreation = source.dateCreation
        self.dateValidation = source.dateValidation
        self.dueDate = source.dueDate
        self.lastMainDoc = source.lastMainDoc
        self.userAuthorId = source.userAuthorId
        self.paymentMethodId = source.paymentMethodId
        self.paymentTermsId = source.paymentTermsId
        self.closeCode = source.closeCode
        self.closeNote = source.closeNote
        super.init(copying: source)
    }

    // MARK: - Methods

    public func copy(_ source: DolibarrSupplierInvoice) {
        self.date = source.date
        self.typeCode = source.typeCode
        self.paidCode = source.paidCode
        self.lines = source.lines
        self.supplierRef = source.supplierRef
        self.dateCreation = source.dateCreation
        self.dateValidation = source.dateValidation
        self.dueDate = source.dueDate
        self.lastMainDoc = source.lastMainDoc
        self.userAuthorId = source.userAuthorId
        self.paymentMethodId = source.paymentMethodId
        self.paymentTermsId = source.paymentTermsId
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
		hasher.combine(optional: supplierRef)
		hasher.combine(optional: dateCreation)
		hasher.combine(optional: dateValidation)
		hasher.combine(optional: dueDate)
		hasher.combine(optional: lastMainDoc)
		hasher.combine(optional: userAuthorId)
		hasher.combine(optional: paymentMethodId)
		hasher.combine(optional: paymentTermsId)
		hasher.combine(optional: closeCode)
		hasher.combine(optional: closeNote)
		super.hash(into: &hasher)
	}

	override public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfNotZero(date, forKey: .date)
		try container.encode(typeCode, forKey: .typeCode)
		try container.encode(paidCode, forKey: .paidCode)
		try container.encode(lines, forKey: .lines)
		try container.encodeIfPresent(supplierRef, forKey: .supplierRef)
		try container.encodeIfPresentAndNotZero(dateCreation, forKey: .dateCreation)
		try container.encodeIfPresentAndNotZero(dateValidation, forKey: .dateValidation)
		try container.encodeIfPresentAndNotZero(dueDate, forKey: .dueDate)
		try container.encodeIfPresent(lastMainDoc, forKey: .lastMainDoc)
		try container.encodeIfPresent(userAuthorId, forKey: .userAuthorId)
		try container.encodeIfPresent(paymentMethodId, forKey: .paymentMethodId)
		try container.encodeIfPresent(paymentTermsId, forKey: .paymentTermsId)
		try container.encodeIfPresent(closeCode, forKey: .closeCode)
		try container.encodeIfPresent(closeNote, forKey: .closeNote)
		try super.encode(to: encoder)
	}

}
