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
//  DolibarrOrder.swift
//  SwiftDolibarr
//
//  Created by William Mead on 18/01/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A Dolibarr order object.
///
/// Maps to the Dolibarr `/orders` REST API endpoint. Inherits common commercial
/// transaction properties such as third-party ID, totals, and status from
/// ``CommonCommercialTransactionObject``.
///
/// ## Overview
///
/// Each order has a ``status``, an array of ``DolibarrOrderLine`` items,
/// and optional delivery, payment, and shipping details.
///
/// - Note: Requires the **Commande** module to be activated in Dolibarr.
/// - SeeAlso: ``DolibarrOrderLine``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrOrder: CommonCommercialTransactionObject {

	// MARK: - Properties

	// Required

	/// Order lines
	public var lines: [DolibarrOrderLine]

	// Optional

	/// Order client reference
	///
	/// - Mapped Dolibarr property: **ref_client**
	public var clientRef: String?

	/// Order creation date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_creation**
	public var dateCreation: Int?

	/// Order date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date**
	public var dateOrder: Int?

	/// Order validation date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_validation**
	public var dateValidation: Int?

	/// Order delivery date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **delivery_date**
	public var deliveryDate: Int?

	/// Order PDF model name
	///
	/// - Mapped Dolibarr property: **model_pdf**
	public var pdfModel: String?

	/// Order last generated main document path
	///
	/// - Mapped Dolibarr property: **last_main_doc**
	public var lastMainDoc: String?

	/// Order author user ID
	///
	/// - Mapped Dolibarr property: **user_author_id**
	public var userAuthorId: String?

	/// Order payment method ID
	///
	/// - Mapped Dolibarr property: **mode_reglement_id**
	public var paymentMethodId: String?

	/// Order payment terms ID
	///
	/// - Mapped Dolibarr property: **cond_reglement_id**
	public var paymentTermsId: String?

	/// Order availability ID
	///
	/// - Mapped Dolibarr property: **availability_id**
	public var availabilityId: String?

	/// Order shipping method ID
	///
	/// - Mapped Dolibarr property: **shipping_method_id**
	public var shippingMethodId: String?

	/// Order source reason ID
	///
	/// - Mapped Dolibarr property: **demand_reason_id**
	public var sourceReasonId: String?

	/// Order external contact IDs
	///
	/// - Mapped Dolibarr property: **contacts_ids**
	public var externalContactIds: [String]?

	// Computed

	/// Associated order status type
	override public var status: DolibarrObjectStatus {
		guard let status = DolibarrObjectStatus.orders.first(where: { $0.code == statusCode }) else { return .unknown }
		return status
	}

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case lines
		case clientRef = "ref_client"
		case dateCreation = "date_creation"
		case dateOrder = "date"
		case dateValidation = "date_validation"
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
		lines: [DolibarrOrderLine] = [],
		clientRef: String? = nil,
		dateCreation: Int? = nil,
		dateOrder: Int? = nil,
		dateValidation: Int? = nil,
		deliveryDate: Int? = nil,
		pdfModel: String? = nil,
		lastMainDoc: String? = nil,
		userAuthorId: String? = nil,
		paymentMethodId: String? = nil,
		paymentTermsId: String? = nil,
		availabilityId: String? = nil,
		shippingMethodId: String? = nil,
		sourceReasonId: String? = nil,
		externalContactIds: [String]? = nil,
		thirdPartyId: String = "",
		statusCode: String = "0",
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
		self.dateCreation = dateCreation
		self.dateOrder = dateOrder
		self.dateValidation = dateValidation
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
			Logger.logWithoutSignal("\(Self.self).init.decode", level: .info, category: .api)
			#endif
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.clientRef = try container.decodeIfPresent(String.self, forKey: .clientRef)
			self.dateCreation = try container.decodeIfPresent(Int.self, forKey: .dateCreation)
			self.dateOrder = try container.decodeIfPresent(Int.self, forKey: .dateOrder)
			self.dateValidation = try container.decodeIfPresent(MultiType.self, forKey: .dateValidation)?.intValue
			self.deliveryDate = try container.decodeIfPresent(MultiType.self, forKey: .deliveryDate)?.intValue
			self.pdfModel = try container.decodeIfPresent(String.self, forKey: .pdfModel)
			self.lastMainDoc = try container.decodeIfPresent(String.self, forKey: .lastMainDoc)
			self.userAuthorId = try container.decodeIfPresent(String.self, forKey: .userAuthorId)
			self.paymentMethodId = try container.decodeIfPresent(String.self, forKey: .paymentMethodId)
			self.paymentTermsId = try container.decodeIfPresent(String.self, forKey: .paymentTermsId)
			self.availabilityId = try container.decodeIfPresent(String.self, forKey: .availabilityId)
			self.shippingMethodId = try container.decodeIfPresent(String.self, forKey: .shippingMethodId)
			self.sourceReasonId = try container.decodeIfPresent(String.self, forKey: .sourceReasonId)
			self.lines = try container.decode([DolibarrOrderLine].self, forKey: .lines)
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

    public init(copying source: DolibarrOrder) {
        self.lines = source.lines
        self.clientRef = source.clientRef
        self.dateCreation = source.dateCreation
        self.dateOrder = source.dateOrder
        self.dateValidation = source.dateValidation
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

    public func copy(_ source: DolibarrOrder) {
        self.lines = source.lines
        self.clientRef = source.clientRef
        self.dateCreation = source.dateCreation
        self.dateOrder = source.dateOrder
        self.dateValidation = source.dateValidation
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
		hasher.combine(optional: dateCreation)
		hasher.combine(optional: dateOrder)
		hasher.combine(optional: dateValidation)
		hasher.combine(optional: deliveryDate)
		hasher.combine(optional: pdfModel)
		hasher.combine(optional: lastMainDoc)
		hasher.combine(optional: userAuthorId)
		hasher.combine(optional: paymentMethodId)
		hasher.combine(optional: paymentTermsId)
		hasher.combine(optional: availabilityId)
		hasher.combine(optional: shippingMethodId)
		hasher.combine(optional: sourceReasonId)
		hasher.combine(optional: externalContactIds)
		super.hash(into: &hasher)
	}

	override public func isEqual(to other: CommonBusinessObject) -> Bool {
		guard let other = other as? DolibarrOrder else { return false }
		return lines == other.lines
		&& clientRef == other.clientRef
		&& dateCreation == other.dateCreation
		&& dateOrder == other.dateOrder
		&& dateValidation == other.dateValidation
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
		try container.encodeIfPresentAndNotZero(dateCreation, forKey: .dateCreation)
		try container.encodeIfPresentAndNotZero(dateOrder, forKey: .dateOrder)
		try container.encodeIfPresentAndNotZero(dateValidation, forKey: .dateValidation)
		try container.encodeIfPresentAndNotZero(deliveryDate, forKey: .deliveryDate)
		try container.encodeIfPresent(pdfModel, forKey: .pdfModel)
		try container.encodeIfPresent(lastMainDoc, forKey: .lastMainDoc)
		try container.encodeIfPresentAndNotEmpty(userAuthorId, forKey: .userAuthorId)
		try container.encodeIfPresentAndNotEmpty(paymentMethodId, forKey: .paymentMethodId)
		try container.encodeIfPresentAndNotEmpty(paymentTermsId, forKey: .paymentTermsId)
		try container.encodeIfPresentAndNotEmpty(availabilityId, forKey: .availabilityId)
		try container.encodeIfPresentAndNotEmpty(shippingMethodId, forKey: .shippingMethodId)
		try container.encodeIfPresentAndNotEmpty(sourceReasonId, forKey: .sourceReasonId)
		try super.encode(to: encoder)
	}
}
