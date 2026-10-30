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
//  DolibarrSupplierOrder.swift
//  SwiftDolibarr
//
//  Created by William Mead on 15/09/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A Dolibarr supplier (purchase) order object.
///
/// Maps to the Dolibarr `/supplierorders` REST API endpoint. Inherits common commercial
/// transaction properties such as third-party ID, totals, and status from
/// ``CommonCommercialTransactionObject``.
///
/// ## Overview
///
/// Each supplier order has a ``status``, an array of ``DolibarrSupplierOrderLine`` items,
/// and optional approval, delivery, and payment details. The inherited ``thirdPartyId``
/// represents the **supplier's** third-party ID.
///
/// - Note: Requires the **Supplier order (Commande fournisseur)** module to be activated in Dolibarr.
/// - SeeAlso: ``DolibarrSupplierOrderLine``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrSupplierOrder: CommonCommercialTransactionObject {

	// MARK: - Properties

	// Required

	/// Supplier order lines
	public var lines: [DolibarrSupplierOrderLine]

	// Optional

	/// Supplier order's own reference for this order
	///
	/// - Mapped Dolibarr property: **ref_supplier**
	public var supplierRef: String?

	/// Supplier order creation date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_creation**
	public var dateCreation: Int?

	/// Supplier order date, set when the order is sent to the supplier (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_commande**
	public var dateOrder: Int?

	/// Supplier order validation date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_valid**
	public var dateValidation: Int?

	/// Supplier order first approval date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_approve**
	public var dateApproval: Int?

	/// Supplier order second approval date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_approve2**
	public var dateApproval2: Int?

	/// Supplier order expected delivery date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **delivery_date**
	public var deliveryDate: Int?

	/// Supplier order PDF model name
	///
	/// - Mapped Dolibarr property: **model_pdf**
	public var pdfModel: String?

	/// Supplier order last generated main document path
	///
	/// - Mapped Dolibarr property: **last_main_doc**
	public var lastMainDoc: String?

	/// Supplier order author user ID
	///
	/// - Mapped Dolibarr property: **user_author_id**
	public var userAuthorId: String?

	/// Supplier order first approver user ID
	///
	/// - Mapped Dolibarr property: **user_approve_id**
	public var userApproveId: String?

	/// Supplier order second approver user ID
	///
	/// - Mapped Dolibarr property: **user_approve_id2**
	public var userApproveId2: String?

	/// Supplier order payment method ID
	///
	/// - Mapped Dolibarr property: **mode_reglement_id**
	public var paymentMethodId: String?

	/// Supplier order payment terms ID
	///
	/// - Mapped Dolibarr property: **cond_reglement_id**
	public var paymentTermsId: String?

	/// Supplier order ordering method ID
	///
	/// - Mapped Dolibarr property: **methode_commande_id**
	public var orderMethodId: String?

	/// Supplier order ordering method label
	///
	/// - Mapped Dolibarr property: **methode_commande**
	public var orderMethod: String?

	/// Whether the supplier order has been billed
	///
	/// - Mapped Dolibarr property: **billed**
	public var billed: String?

	// Computed

	/// Associated supplier order status type
	override public var status: DolibarrObjectStatus {
		guard let status = DolibarrObjectStatus.supplierOrders.first(where: { $0.code == statusCode }) else { return .unknown }
		return status
	}

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case lines
		case supplierRef = "ref_supplier"
		case dateCreation = "date_creation"
		case dateOrder = "date_commande"
		case dateValidation = "date_valid"
		case dateApproval = "date_approve"
		case dateApproval2 = "date_approve2"
		case deliveryDate = "delivery_date"
		case pdfModel = "model_pdf"
		case lastMainDoc = "last_main_doc"
		case userAuthorId = "user_author_id"
		case userApproveId = "user_approve_id"
		case userApproveId2 = "user_approve_id2"
		case paymentMethodId = "mode_reglement_id"
		case paymentTermsId = "cond_reglement_id"
		case orderMethodId = "methode_commande_id"
		case orderMethod = "methode_commande"
		case billed
	}

	// MARK: - Inits

	public init(
		lines: [DolibarrSupplierOrderLine] = [],
		supplierRef: String? = nil,
		dateCreation: Int? = nil,
		dateOrder: Int? = nil,
		dateValidation: Int? = nil,
		dateApproval: Int? = nil,
		dateApproval2: Int? = nil,
		deliveryDate: Int? = nil,
		pdfModel: String? = nil,
		lastMainDoc: String? = nil,
		userAuthorId: String? = nil,
		userApproveId: String? = nil,
		userApproveId2: String? = nil,
		paymentMethodId: String? = nil,
		paymentTermsId: String? = nil,
		orderMethodId: String? = nil,
		orderMethod: String? = nil,
		billed: String? = nil,
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
		self.lines = lines
		self.supplierRef = supplierRef
		self.dateCreation = dateCreation
		self.dateOrder = dateOrder
		self.dateValidation = dateValidation
		self.dateApproval = dateApproval
		self.dateApproval2 = dateApproval2
		self.deliveryDate = deliveryDate
		self.pdfModel = pdfModel
		self.lastMainDoc = lastMainDoc
		self.userAuthorId = userAuthorId
		self.userApproveId = userApproveId
		self.userApproveId2 = userApproveId2
		self.paymentMethodId = paymentMethodId
		self.paymentTermsId = paymentTermsId
		self.orderMethodId = orderMethodId
		self.orderMethod = orderMethod
		self.billed = billed
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
			Logger.logWithoutSignal("\(Self.self).init.decode", level: .info, category: .api)
			#endif
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.supplierRef = try container.decodeIfPresent(String.self, forKey: .supplierRef)
			self.dateCreation = try container.decodeIfPresent(MultiType.self, forKey: .dateCreation)?.intValue
			self.dateOrder = try container.decodeIfPresent(MultiType.self, forKey: .dateOrder)?.intValue
			self.dateValidation = try container.decodeIfPresent(MultiType.self, forKey: .dateValidation)?.intValue
			self.dateApproval = try container.decodeIfPresent(MultiType.self, forKey: .dateApproval)?.intValue
			self.dateApproval2 = try container.decodeIfPresent(MultiType.self, forKey: .dateApproval2)?.intValue
			self.deliveryDate = try container.decodeIfPresent(MultiType.self, forKey: .deliveryDate)?.intValue
			self.pdfModel = try container.decodeIfPresent(String.self, forKey: .pdfModel)
			self.lastMainDoc = try container.decodeIfPresent(String.self, forKey: .lastMainDoc)
			self.userAuthorId = try container.decodeIfPresent(String.self, forKey: .userAuthorId)
			self.userApproveId = try container.decodeIfPresent(String.self, forKey: .userApproveId)
			self.userApproveId2 = try container.decodeIfPresent(String.self, forKey: .userApproveId2)
			self.paymentMethodId = try container.decodeIfPresent(String.self, forKey: .paymentMethodId)
			self.paymentTermsId = try container.decodeIfPresent(String.self, forKey: .paymentTermsId)
			self.orderMethodId = try container.decodeIfPresent(MultiType.self, forKey: .orderMethodId)?.stringValue
			self.orderMethod = try container.decodeIfPresent(String.self, forKey: .orderMethod)
			self.billed = try container.decodeIfPresent(MultiType.self, forKey: .billed)?.stringValue
			self.lines = try container.decode([DolibarrSupplierOrderLine].self, forKey: .lines)
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

    public init(copying source: DolibarrSupplierOrder) {
        self.lines = source.lines
        self.supplierRef = source.supplierRef
        self.dateCreation = source.dateCreation
        self.dateOrder = source.dateOrder
        self.dateValidation = source.dateValidation
        self.dateApproval = source.dateApproval
        self.dateApproval2 = source.dateApproval2
        self.deliveryDate = source.deliveryDate
        self.pdfModel = source.pdfModel
        self.lastMainDoc = source.lastMainDoc
        self.userAuthorId = source.userAuthorId
        self.userApproveId = source.userApproveId
        self.userApproveId2 = source.userApproveId2
        self.paymentMethodId = source.paymentMethodId
        self.paymentTermsId = source.paymentTermsId
        self.orderMethodId = source.orderMethodId
        self.orderMethod = source.orderMethod
        self.billed = source.billed
        super.init(copying: source)
    }

    // MARK: - Methods

    public func copy(_ source: DolibarrSupplierOrder) {
        self.lines = source.lines
        self.supplierRef = source.supplierRef
        self.dateCreation = source.dateCreation
        self.dateOrder = source.dateOrder
        self.dateValidation = source.dateValidation
        self.dateApproval = source.dateApproval
        self.dateApproval2 = source.dateApproval2
        self.deliveryDate = source.deliveryDate
        self.pdfModel = source.pdfModel
        self.lastMainDoc = source.lastMainDoc
        self.userAuthorId = source.userAuthorId
        self.userApproveId = source.userApproveId
        self.userApproveId2 = source.userApproveId2
        self.paymentMethodId = source.paymentMethodId
        self.paymentTermsId = source.paymentTermsId
        self.orderMethodId = source.orderMethodId
        self.orderMethod = source.orderMethod
        self.billed = source.billed
        super.copy(source)
    }

	// MARK: - Protocol methods

	override public func hash(into hasher: inout Hasher) {
		hasher.combine(lines)
		hasher.combine(optional: supplierRef)
		hasher.combine(optional: dateCreation)
		hasher.combine(optional: dateOrder)
		hasher.combine(optional: dateValidation)
		hasher.combine(optional: dateApproval)
		hasher.combine(optional: dateApproval2)
		hasher.combine(optional: deliveryDate)
		hasher.combine(optional: pdfModel)
		hasher.combine(optional: lastMainDoc)
		hasher.combine(optional: userAuthorId)
		hasher.combine(optional: userApproveId)
		hasher.combine(optional: userApproveId2)
		hasher.combine(optional: paymentMethodId)
		hasher.combine(optional: paymentTermsId)
		hasher.combine(optional: orderMethodId)
		hasher.combine(optional: orderMethod)
		hasher.combine(optional: billed)
		super.hash(into: &hasher)
	}

	override public func isEqual(to other: CommonBusinessObject) -> Bool {
		guard let other = other as? DolibarrSupplierOrder else { return false }
		return lines == other.lines
		&& supplierRef == other.supplierRef
		&& dateCreation == other.dateCreation
		&& dateOrder == other.dateOrder
		&& dateValidation == other.dateValidation
		&& dateApproval == other.dateApproval
		&& dateApproval2 == other.dateApproval2
		&& deliveryDate == other.deliveryDate
		&& pdfModel == other.pdfModel
		&& lastMainDoc == other.lastMainDoc
		&& userAuthorId == other.userAuthorId
		&& userApproveId == other.userApproveId
		&& userApproveId2 == other.userApproveId2
		&& paymentMethodId == other.paymentMethodId
		&& paymentTermsId == other.paymentTermsId
		&& orderMethodId == other.orderMethodId
		&& orderMethod == other.orderMethod
		&& billed == other.billed
		&& super.isEqual(to: other)
	}

	override public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(lines, forKey: .lines)
		try container.encodeIfPresent(supplierRef, forKey: .supplierRef)
		try container.encodeIfPresentAndNotZero(dateCreation, forKey: .dateCreation)
		try container.encodeIfPresentAndNotZero(dateOrder, forKey: .dateOrder)
		try container.encodeIfPresentAndNotZero(dateValidation, forKey: .dateValidation)
		try container.encodeIfPresentAndNotZero(dateApproval, forKey: .dateApproval)
		try container.encodeIfPresentAndNotZero(dateApproval2, forKey: .dateApproval2)
		try container.encodeIfPresentAndNotZero(deliveryDate, forKey: .deliveryDate)
		try container.encodeIfPresent(pdfModel, forKey: .pdfModel)
		try container.encodeIfPresent(lastMainDoc, forKey: .lastMainDoc)
		try container.encodeIfPresentAndNotEmpty(userAuthorId, forKey: .userAuthorId)
		try container.encodeIfPresentAndNotEmpty(userApproveId, forKey: .userApproveId)
		try container.encodeIfPresentAndNotEmpty(userApproveId2, forKey: .userApproveId2)
		try container.encodeIfPresentAndNotEmpty(paymentMethodId, forKey: .paymentMethodId)
		try container.encodeIfPresentAndNotEmpty(paymentTermsId, forKey: .paymentTermsId)
		try container.encodeIfPresentAndNotEmpty(orderMethodId, forKey: .orderMethodId)
		try container.encodeIfPresent(orderMethod, forKey: .orderMethod)
		try container.encodeIfPresent(billed, forKey: .billed)
		try super.encode(to: encoder)
	}
}
