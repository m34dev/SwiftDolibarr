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
//  DolibarrQuote.swift
//  SwiftDolibarr
//
//  Created by William Mead on 11/08/2025.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A Dolibarr quote (commercial proposal) object.
///
/// Maps to the Dolibarr `/proposals` REST API endpoint. Inherits common commercial
/// transaction properties such as third-party ID, totals, and status from
/// ``CommonCommercialTransactionObject``.
///
/// ## Overview
///
/// Each quote has a ``status``, an array of ``DolibarrQuoteLine`` items,
/// and optional validity, delivery, payment, and shipping details.
///
/// - Note: Requires the **Propal** module to be activated in Dolibarr.
/// - SeeAlso: ``DolibarrQuoteLine``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrQuote: CommonCommercialTransactionObject {

	// MARK: - Properties

	// Required

	/// Quote lines
	public var lines: [DolibarrQuoteLine]

	// Optional

	/// Quote client reference
	///
	/// - Mapped Dolibarr property: **ref_client**
	public var clientRef: String?

	/// Quote creation date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **datep**
	public var dateP: Int

	/// Quote validation date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **datev**
	public var dateV: Int?

	/// Quote validity end date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **fin_validite**
	public var validityEndDate: Int?

	/// Quote delivery date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **delivery_date**
	public var deliveryDate: Int?

	/// Quote PDF model name
	///
	/// - Mapped Dolibarr property: **model_pdf**
	public var pdfModel: String?

	/// Quote last generated main document path
	///
	/// - Mapped Dolibarr property: **last_main_doc**
	public var lastMainDoc: String?

	/// Quote author user ID
	///
	/// - Mapped Dolibarr property: **user_author_id**
	public var userAuthorId: String

	/// Quote payment method ID
	///
	/// - Mapped Dolibarr property: **mode_reglement_id**
	public var paymentMethodId: String?

	/// Quote payment terms ID
	///
	/// - Mapped Dolibarr property: **cond_reglement_id**
	public var paymentTermsId: String?

	/// Quote availability ID
	///
	/// - Mapped Dolibarr property: **availability_id**
	public var availabilityId: String?

	/// Quote shipping method ID
	///
	/// - Mapped Dolibarr property: **shipping_method_id**
	public var shippingMethodId: String?

	/// Quote source reason ID
	///
	/// - Mapped Dolibarr property: **demand_reason_id**
	public var sourceReasonId: String?

	/// Quote external contact IDs
	///
	/// - Mapped Dolibarr property: **contacts_ids**
	public var externalContactIds: [String]?

	// Computed

	/// Associated quote status type
	override public var status: DolibarrObjectStatus {
		guard let status = DolibarrObjectStatus.quotes.first(where: { $0.code == statusCode }) else { return .unknown }
		return status
	}

	// MARK: - Enums

	enum Errors: String, Error {
		case createQuote = "Unable to create quote"
		case readQuote = "Unable to read quote"
		case readQuotes = "Unable to read quotes"
		case updateQuote = "Unable to update quote"
		case updateQuoteStatus = "Unable to update quote status"
		case routeNotFound = "Route not found"
		case readExternalContacts = "Unable to read external contacts"
	}

	enum CodingKeys: String, CodingKey {
		case lines
		case clientRef = "ref_client"
		case dateP = "datep"
		case dateV = "datev"
		case validityEndDate = "fin_validite"
		case deliveryDate = "delivery_date"
		case pdfModel = "model_pdf"
		case lastMainDoc = "last_main_doc"
		case userAuthorId = "user_author_id"
		case paymentMethodId = "mode_reglement_id"
		case paymentTermsId = "cond_reglement_id"
		case availabilityId = "availability_id"
		case shippingMethodId = "shipping_method_id"
		case sourceReasonId = "demand_reason_id"
		case externalContactIds = "contacts_ids"
	}

	// MARK: - Inits

	public init(
		lines: [DolibarrQuoteLine] = [],
		clientRef: String? = nil,
		dateP: Int = 0,
		dateV: Int? = nil,
		validityEndDate: Int? = nil,
		deliveryDate: Int? = nil,
		pdfModel: String? = nil,
		lastMainDoc: String? = nil,
		userAuthorId: String = "",
		paymentMethodId: String? = nil,
		paymentTermsId: String? = nil,
		availabilityId: String? = nil,
		shippingMethodId: String? = nil,
		sourceReasonId: String? = nil,
		externalContactIds: [String]? = nil,
		thirdPartyId: String = "",
		statusCode: String = "",
		ref: String = "",
		totalExclTax: String = "0.00",
		totalTax: String = "0.00",
		totalInclTax: String = "0.00",
		multicurrencyCode: String? = nil,
		id: String = "",
		arrayOptions: [String: MultiType]? = nil,
		notePublic: String? = nil,
		notePrivate: String? = nil
	) {
		self.lines = lines
		self.clientRef = clientRef
		self.dateP = dateP
		self.dateV = dateV
		self.validityEndDate = validityEndDate
		self.deliveryDate = deliveryDate
		self.pdfModel = pdfModel
		self.lastMainDoc = lastMainDoc
		self.userAuthorId = userAuthorId
		self.paymentMethodId = paymentMethodId
		self.paymentTermsId = paymentTermsId
		self.availabilityId = availabilityId
		self.shippingMethodId = shippingMethodId
		self.sourceReasonId = sourceReasonId
		self.externalContactIds = externalContactIds
		super.init(
			thirdPartyId: thirdPartyId,
			statusCode: statusCode,
			totalExclTax: totalExclTax,
			totalTax: totalTax,
			totalInclTax: totalInclTax,
			multicurrencyCode: multicurrencyCode,
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
			self.lines = try container.decode([DolibarrQuoteLine].self, forKey: .lines)
			self.clientRef = try container.decodeIfPresent(String.self, forKey: .clientRef)
			self.dateP = try container.decode(Int.self, forKey: .dateP)
			self.dateV = try container.decodeIfPresent(MultiType.self, forKey: .dateV)?.intValue
			self.validityEndDate = try container.decodeIfPresent(MultiType.self, forKey: .validityEndDate)?.intValue
			self.deliveryDate = try container.decodeIfPresent(MultiType.self, forKey: .deliveryDate)?.intValue
			self.pdfModel = try container.decodeIfPresent(String.self, forKey: .pdfModel)
			self.lastMainDoc = try container.decodeIfPresent(String.self, forKey: .lastMainDoc)
			self.userAuthorId = try container.decode(String.self, forKey: .userAuthorId)
			self.paymentMethodId = try container.decodeIfPresent(String.self, forKey: .paymentMethodId)
			self.paymentTermsId = try container.decodeIfPresent(String.self, forKey: .paymentTermsId)
			self.availabilityId = try container.decodeIfPresent(String.self, forKey: .availabilityId)
			self.shippingMethodId = try container.decodeIfPresent(String.self, forKey: .shippingMethodId)
			self.sourceReasonId = try container.decodeIfPresent(String.self, forKey: .sourceReasonId)
			self.externalContactIds = try container.decodeIfPresent([String].self, forKey: .externalContactIds)
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
    
    public init(copying source: DolibarrQuote) {
        self.lines = source.lines
        self.clientRef = source.clientRef
        self.dateP = source.dateP
        self.dateV = source.dateV
        self.validityEndDate = source.validityEndDate
        self.deliveryDate = source.deliveryDate
        self.pdfModel = source.pdfModel
        self.lastMainDoc = source.lastMainDoc
        self.userAuthorId = source.userAuthorId
        self.paymentMethodId = source.paymentMethodId
        self.paymentTermsId = source.paymentTermsId
        self.availabilityId = source.availabilityId
        self.shippingMethodId = source.shippingMethodId
        self.sourceReasonId = source.sourceReasonId
        self.externalContactIds = source.externalContactIds
        super.init(copying: source)
    }
    
    // MARK: - Methods
    
    public func copy(_ source: DolibarrQuote) {
        self.lines = source.lines
        self.clientRef = source.clientRef
        self.dateP = source.dateP
        self.dateV = source.dateV
        self.validityEndDate = source.validityEndDate
        self.deliveryDate = source.deliveryDate
        self.pdfModel = source.pdfModel
        self.lastMainDoc = source.lastMainDoc
        self.userAuthorId = source.userAuthorId
        self.paymentMethodId = source.paymentMethodId
        self.paymentTermsId = source.paymentTermsId
        self.availabilityId = source.availabilityId
        self.shippingMethodId = source.shippingMethodId
        self.sourceReasonId = source.sourceReasonId
        self.externalContactIds = source.externalContactIds
        super.copy(source)
    }

	// MARK: - Protocol methods

	override public func hash(into hasher: inout Hasher) {
		hasher.combine(lines)
		hasher.combine(optional: clientRef)
		hasher.combine(dateP)
		hasher.combine(optional: dateV)
		hasher.combine(optional: validityEndDate)
		hasher.combine(optional: deliveryDate)
		hasher.combine(optional: pdfModel)
		hasher.combine(optional: lastMainDoc)
		hasher.combine(userAuthorId)
		hasher.combine(optional: paymentMethodId)
		hasher.combine(optional: paymentTermsId)
		hasher.combine(optional: availabilityId)
		hasher.combine(optional: shippingMethodId)
		hasher.combine(optional: sourceReasonId)
		hasher.combine(optional: externalContactIds)
		super.hash(into: &hasher)
	}

	override public func isEqual(to other: CommonBusinessObject) -> Bool {
		guard let other = other as? DolibarrQuote else { return false }
		return lines == other.lines
		&& clientRef == other.clientRef
		&& dateP == other.dateP
		&& dateV == other.dateV
		&& validityEndDate == other.validityEndDate
		&& deliveryDate == other.deliveryDate
		&& pdfModel == other.pdfModel
		&& lastMainDoc == other.lastMainDoc
		&& userAuthorId == other.userAuthorId
		&& paymentMethodId == other.paymentMethodId
		&& paymentTermsId == other.paymentTermsId
		&& availabilityId == other.availabilityId
		&& shippingMethodId == other.shippingMethodId
		&& sourceReasonId == other.sourceReasonId
		&& externalContactIds == other.externalContactIds
		&& super.isEqual(to: other)
	}

	override public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(lines, forKey: .lines)
		try container.encodeIfPresent(clientRef, forKey: .clientRef)
		try container.encodeIfPresentAndNotZero(dateP, forKey: .dateP)
		try container.encodeIfPresent(dateV, forKey: .dateV)
		try container.encodeIfPresent(validityEndDate, forKey: .validityEndDate)
		try container.encodeIfPresent(deliveryDate, forKey: .deliveryDate)
		try container.encodeIfPresent(pdfModel, forKey: .pdfModel)
		try container.encodeIfPresent(lastMainDoc, forKey: .lastMainDoc)
		try container.encodeIfNotEmpty(userAuthorId, forKey: .userAuthorId)
		try container.encodeIfPresentAndNotEmpty(paymentMethodId, forKey: .paymentMethodId)
		try container.encodeIfPresentAndNotEmpty(paymentTermsId, forKey: .paymentTermsId)
		try container.encodeIfPresentAndNotEmpty(availabilityId, forKey: .availabilityId)
		try container.encodeIfPresentAndNotEmpty(shippingMethodId, forKey: .shippingMethodId)
		try container.encodeIfPresentAndNotEmpty(sourceReasonId, forKey: .sourceReasonId)
		try super.encode(to: encoder)
	}

}
