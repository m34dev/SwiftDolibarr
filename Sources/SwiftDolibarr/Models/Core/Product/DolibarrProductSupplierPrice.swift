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
//  DolibarrProductSupplierPrice.swift
//  hades
//
//  Created by William Mead on 22/05/2025.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A purchase price of a product from a supplier.
///
/// Decoded from `GET /products/{id}/purchase_prices`. Fields that depend on a Dolibarr
/// version, module or setting are optional and decode as `nil` when missing.
///
/// Encoded as the body to add or update a price (`POST /products/{id}/purchase_prices`),
/// which uses other keys. Dolibarr stores supplier prices excluding tax.
///
/// - Important: When the **Multicurrency** module is enabled, Dolibarr computes the price
///   from ``supplierMulticurrencyPrice`` and ``supplierMulticurrencyRate`` and ignores
///   ``supplierPrice``. Update the multicurrency price when editing a price on such a server.
/// - SeeAlso: ``DolibarrProduct``, ``DolibarrAvailability``, ``DolibarrSupplierReputation``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrProductSupplierPrice: Hashable, Codable, DolibarrObject {

	// MARK: - Properties

	/// Supplier product price ID
	///
	/// - Mapped Dolibarr property: **product_fourn_price_id**
	public var id: String

	/// Product ID
	///
	/// - Mapped Dolibarr property: **id**
	public var productId: String

	/// Supplier product reference
	///
	/// - Mapped Dolibarr property: **fourn_ref**, encoded as **ref_fourn**
	public var supplierProductRef: String

	/// Supplier product description
	///
	/// - Mapped Dolibarr property: **desc_supplier**, encoded as **desc_fourn**
	public var supplierDescription: String?

	/// Supplier ID
	///
	/// - Mapped Dolibarr property: **fourn_id**
	public var supplierId: String

	/// Supplier name (read-only)
	///
	/// - Mapped Dolibarr property: **fourn_name**
	public var supplierName: String

	/// Supplier minimum order quantity
	///
	/// - Mapped Dolibarr property: **fourn_qty**, encoded as **qty**
	public var supplierMinimumQuantity: String

	/// Supplier price excluding tax for the minimum quantity
	///
	/// - Mapped Dolibarr property: **fourn_price**, encoded as **buyprice**
	public var supplierPrice: String

	/// Supplier unit price excluding tax (read-only, computed by Dolibarr)
	///
	/// - Mapped Dolibarr property: **fourn_unitprice**
	public var supplierUnitPrice: String

	/// Supplier discount rate in percent
	///
	/// - Mapped Dolibarr property: **fourn_remise_percent**, encoded as **remise_percent**
	public var supplierDiscountRate: String

	/// Supplier discount amount
	///
	/// - Mapped Dolibarr property: **fourn_remise**, encoded as **remise**
	public var supplierDiscountAmount: String?

	/// Supplier charges, only returned when the `PRODUCT_CHARGES` setting is set
	///
	/// - Mapped Dolibarr property: **fourn_charges**, encoded as **charges**
	public var supplierCharges: String?

	/// Supplier tax rate in percent
	///
	/// - Mapped Dolibarr property: **fourn_tva_tx**, encoded as **tva_tx**
	public var supplierTaxRate: String

	/// Supplier tax "non perçue récupérable" flags (`info_bits`), bit `1` set when the tax is NPR
	///
	/// - Mapped Dolibarr property: **fourn_tva_npr**, encoded as **newnpr**
	public var supplierTaxNPR: String?

	/// Supplier multicurrency code
	///
	/// - Mapped Dolibarr property: **fourn_multicurrency_code**, encoded as **multicurrency_code**
	public var supplierMulticurrencyCode: String?

	/// Supplier price excluding tax for the minimum quantity, in the multicurrency
	///
	/// When `nil`, ``supplierPrice`` is encoded with a rate of `1`.
	///
	/// - Mapped Dolibarr property: **fourn_multicurrency_price**, encoded as **multicurrency_buyprice**
	public var supplierMulticurrencyPrice: String?

	/// Supplier unit price excluding tax in the multicurrency (read-only, computed by Dolibarr)
	///
	/// - Mapped Dolibarr property: **fourn_multicurrency_unitprice**
	public var supplierMulticurrencyUnitPrice: String?

	/// Supplier multicurrency rate
	///
	/// - Mapped Dolibarr property: **fourn_multicurrency_tx**, encoded as **multicurrency_tx**
	public var supplierMulticurrencyRate: String?

	/// Price base type to send for ``supplierPrice`` and ``supplierMulticurrencyPrice``:
	/// `HT` (excluding tax, the default when `nil`) or `TTC`
	///
	/// Write only: never decoded, as Dolibarr always returns supplier prices excluding tax.
	///
	/// - Mapped Dolibarr property: **price_base_type** and **multicurrency_price_base_type**
	public var supplierPriceBaseType: String?

	/// Availability ID, in the `/setup/dictionary/availability` dictionary
	///
	/// - Mapped Dolibarr property: **fk_availability**, encoded as **availability**
	public var supplierProductAvailability: String?

	/// Delivery time in days
	///
	/// - Mapped Dolibarr property: **delivery_time_days**
	public var deliveryTimeDays: String?

	/// Supplier reputation for this product: `FAVORITE`, `NOTTHGOOD`, `DONOTORDER`, or `nil` when not set
	///
	/// - Mapped Dolibarr property: **supplier_reputation**
	public var supplierReputation: String?

	/// Supplier barcode, only returned when the **Barcode** module is enabled
	///
	/// - Mapped Dolibarr property: **supplier_barcode**, encoded as **barcode**
	public var supplierBarcode: String?

	/// Supplier barcode type ID, only returned when the **Barcode** module is enabled
	///
	/// - Mapped Dolibarr property: **supplier_fk_barcode_type**, encoded as **fk_barcode_type**
	public var supplierBarcodeTypeId: String?

	/// Packaging quantity (read-only: the REST API can't set it), Dolibarr v14+
	///
	/// - Mapped Dolibarr property: **packaging**
	public var packaging: String?

	/// Purchase price status (read-only), `1` when active, Dolibarr v18+
	///
	/// - Warning: Before Dolibarr v18, this key holds the product's "to sell" status instead.
	///
	/// - Mapped Dolibarr property: **status**
	public var supplierPriceStatus: String?

	// Audit (read-only: never encoded, not part of equality)

	/// Purchase price creation date (Unix timestamp), shown by Dolibarr as the date the price applies from
	///
	/// - Mapped Dolibarr property: **fourn_date_creation**
	public var creationTimestamp: Int?

	/// Purchase price last modification date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **fourn_date_modification**
	public var modificationTimestamp: Int?

	// Computed

	/// Supplier price as a number, `0` when the value can't be parsed
	public var supplierPriceValue: Double {
		Double(supplierPrice) ?? 0
	}

	/// Supplier unit price as a number, `0` when the value can't be parsed
	public var supplierUnitPriceValue: Double {
		Double(supplierUnitPrice) ?? 0
	}

	/// Supplier minimum order quantity as a number, `0` when the value can't be parsed
	public var supplierMinimumQuantityValue: Double {
		Double(supplierMinimumQuantity) ?? 0
	}

	/// Supplier discount rate as a fraction (e.g. `0.1` for 10 %)
	public var supplierDiscountFraction: Double {
		(Double(supplierDiscountRate) ?? 0) / 100
	}

	/// Supplier discount amount as a number, `nil` when unset or not a number
	public var supplierDiscountAmountValue: Double? {
		supplierDiscountAmount.flatMap(Double.init)
	}

	/// Supplier charges as a number, `nil` when unset or not a number
	public var supplierChargesValue: Double? {
		supplierCharges.flatMap(Double.init)
	}

	/// Supplier tax rate as a fraction (e.g. `0.2` for 20 %)
	public var supplierTaxFraction: Double {
		(Double(supplierTaxRate) ?? 0) / 100
	}

	/// Whether the supplier tax is "non perçue récupérable" (NPR)
	public var isSupplierTaxNPR: Bool {
		get { ((supplierTaxNPR.flatMap { Int($0) } ?? 0) & 1) == 1 }
		set { supplierTaxNPR = newValue ? "1" : "0" }
	}

	/// Supplier multicurrency price as a number, `nil` when unset or not a number
	public var supplierMulticurrencyPriceValue: Double? {
		supplierMulticurrencyPrice.flatMap(Double.init)
	}

	/// Supplier multicurrency unit price as a number, `nil` when unset or not a number
	public var supplierMulticurrencyUnitPriceValue: Double? {
		supplierMulticurrencyUnitPrice.flatMap(Double.init)
	}

	/// Supplier multicurrency rate as a number, `nil` when unset or not a number
	public var supplierMulticurrencyRateValue: Double? {
		supplierMulticurrencyRate.flatMap(Double.init)
	}

	/// Delivery time in days as a number, `nil` when unset or not a number
	public var deliveryTimeDaysValue: Int? {
		get { deliveryTimeDays.flatMap { Int($0) } }
		set { deliveryTimeDays = newValue.map(String.init) }
	}

	/// Supplier reputation as a ``DolibarrSupplierReputation``, `nil` when unset or unknown
	public var supplierReputationValue: DolibarrSupplierReputation? {
		get { supplierReputation.flatMap(DolibarrSupplierReputation.init(rawValue:)) }
		set { supplierReputation = newValue?.rawValue }
	}

	/// Packaging quantity as a number, `nil` when unset or not a number
	public var packagingValue: Double? {
		packaging.flatMap(Double.init)
	}

	/// Whether the purchase price is active, `nil` when the status isn't returned
	///
	/// - Warning: Before Dolibarr v18, this reflects the product's "to sell" status instead.
	public var isActive: Bool? {
		supplierPriceStatus.map { $0 == "1" }
	}

	/// Purchase price creation date
	public var dateCreated: Date? {
		CommonBusinessObject.date(from: creationTimestamp)
	}

	/// Purchase price last modification date
	public var dateModified: Date? {
		CommonBusinessObject.date(from: modificationTimestamp)
	}

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case id = "product_fourn_price_id"
		case productId = "id"
		case supplierProductRef = "fourn_ref"
		case supplierDescription = "desc_supplier"
		case supplierId = "fourn_id"
		case supplierName = "fourn_name"
		case supplierMinimumQuantity = "fourn_qty"
		case supplierPrice = "fourn_price"
		case supplierUnitPrice = "fourn_unitprice"
		case supplierDiscountRate = "fourn_remise_percent"
		case supplierDiscountAmount = "fourn_remise"
		case supplierCharges = "fourn_charges"
		case supplierTaxRate = "fourn_tva_tx"
		case supplierTaxNPR = "fourn_tva_npr"
		case supplierMulticurrencyCode = "fourn_multicurrency_code"
		case supplierMulticurrencyPrice = "fourn_multicurrency_price"
		case supplierMulticurrencyUnitPrice = "fourn_multicurrency_unitprice"
		case supplierMulticurrencyRate = "fourn_multicurrency_tx"
		case supplierProductAvailability = "fk_availability"
		case deliveryTimeDays = "delivery_time_days"
		case supplierReputation = "supplier_reputation"
		case supplierBarcode = "supplier_barcode"
		case supplierBarcodeTypeId = "supplier_fk_barcode_type"
		case packaging
		case supplierPriceStatus = "status"
		case creationTimestamp = "fourn_date_creation"
		case modificationTimestamp = "fourn_date_modification"
	}

	/// Keys of the `POST /products/{id}/purchase_prices` body
	enum WriteCodingKeys: String, CodingKey {
		case supplierMinimumQuantity = "qty"
		case supplierPrice = "buyprice"
		case supplierPriceBaseType = "price_base_type"
		case supplierId = "fourn_id"
		case supplierProductAvailability = "availability"
		case supplierProductRef = "ref_fourn"
		case supplierTaxRate = "tva_tx"
		case supplierCharges = "charges"
		case supplierDiscountRate = "remise_percent"
		case supplierDiscountAmount = "remise"
		case supplierTaxNPR = "newnpr"
		case deliveryTimeDays = "delivery_time_days"
		case supplierReputation = "supplier_reputation"
		case supplierMulticurrencyPrice = "multicurrency_buyprice"
		case supplierMulticurrencyPriceBaseType = "multicurrency_price_base_type"
		case supplierMulticurrencyRate = "multicurrency_tx"
		case supplierMulticurrencyCode = "multicurrency_code"
		case supplierDescription = "desc_fourn"
		case supplierBarcode = "barcode"
		case supplierBarcodeTypeId = "fk_barcode_type"
	}

	// MARK: - Inits

	public init(
		id: String = "",
		productId: String = "",
		supplierProductRef: String = "",
		supplierDescription: String? = nil,
		supplierId: String = "",
		supplierName: String = "",
		supplierMinimumQuantity: String = "",
		supplierPrice: String = "",
		supplierUnitPrice: String = "",
		supplierDiscountRate: String = "",
		supplierDiscountAmount: String? = nil,
		supplierCharges: String? = nil,
		supplierTaxRate: String = "",
		supplierTaxNPR: String? = nil,
		supplierMulticurrencyCode: String? = nil,
		supplierMulticurrencyPrice: String? = nil,
		supplierMulticurrencyUnitPrice: String? = nil,
		supplierMulticurrencyRate: String? = nil,
		supplierPriceBaseType: String? = nil,
		supplierProductAvailability: String? = nil,
		deliveryTimeDays: String? = nil,
		supplierReputation: String? = nil,
		supplierBarcode: String? = nil,
		supplierBarcodeTypeId: String? = nil,
		packaging: String? = nil,
		supplierPriceStatus: String? = nil,
		creationTimestamp: Int? = nil,
		modificationTimestamp: Int? = nil
	) {
		self.id = id
		self.productId = productId
		self.supplierProductRef = supplierProductRef
		self.supplierDescription = supplierDescription
		self.supplierId = supplierId
		self.supplierName = supplierName
		self.supplierMinimumQuantity = supplierMinimumQuantity
		self.supplierPrice = supplierPrice
		self.supplierUnitPrice = supplierUnitPrice
		self.supplierDiscountRate = supplierDiscountRate
		self.supplierDiscountAmount = supplierDiscountAmount
		self.supplierCharges = supplierCharges
		self.supplierTaxRate = supplierTaxRate
		self.supplierTaxNPR = supplierTaxNPR
		self.supplierMulticurrencyCode = supplierMulticurrencyCode
		self.supplierMulticurrencyPrice = supplierMulticurrencyPrice
		self.supplierMulticurrencyUnitPrice = supplierMulticurrencyUnitPrice
		self.supplierMulticurrencyRate = supplierMulticurrencyRate
		self.supplierPriceBaseType = supplierPriceBaseType
		self.supplierProductAvailability = supplierProductAvailability
		self.deliveryTimeDays = deliveryTimeDays
		self.supplierReputation = supplierReputation
		self.supplierBarcode = supplierBarcode
		self.supplierBarcodeTypeId = supplierBarcodeTypeId
		self.packaging = packaging
		self.supplierPriceStatus = supplierPriceStatus
		self.creationTimestamp = creationTimestamp
		self.modificationTimestamp = modificationTimestamp
	}

	public init(from decoder: any Decoder) throws {
		do {
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
			#endif
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.id = try container.decode(String.self, forKey: .id)
			self.productId = try container.decode(String.self, forKey: .productId)
			self.supplierProductRef = try container.decode(String.self, forKey: .supplierProductRef)
			self.supplierDescription = try container.decodeIfPresent(String.self, forKey: .supplierDescription)
			self.supplierId = try container.decode(String.self, forKey: .supplierId)
			self.supplierName = try container.decode(String.self, forKey: .supplierName)
			self.supplierMinimumQuantity = try container.decode(String.self, forKey: .supplierMinimumQuantity)
			self.supplierPrice = try container.decode(String.self, forKey: .supplierPrice)
			self.supplierUnitPrice = try container.decode(String.self, forKey: .supplierUnitPrice)
			self.supplierDiscountRate = try container.decode(String.self, forKey: .supplierDiscountRate)
			self.supplierDiscountAmount = try Self.decodeValue(in: container, forKey: .supplierDiscountAmount)
			self.supplierCharges = try Self.decodeValue(in: container, forKey: .supplierCharges)
			self.supplierTaxRate = try container.decode(String.self, forKey: .supplierTaxRate)
			self.supplierTaxNPR = try Self.decodeValue(in: container, forKey: .supplierTaxNPR)
			self.supplierMulticurrencyCode = try Self.decodeValue(in: container, forKey: .supplierMulticurrencyCode)
			self.supplierMulticurrencyPrice = try Self.decodeValue(in: container, forKey: .supplierMulticurrencyPrice)
			self.supplierMulticurrencyUnitPrice = try Self.decodeValue(in: container, forKey: .supplierMulticurrencyUnitPrice)
			self.supplierMulticurrencyRate = try Self.decodeValue(in: container, forKey: .supplierMulticurrencyRate)
			self.supplierPriceBaseType = nil
			self.supplierProductAvailability = try container.decodeIdIfPresent(forKey: .supplierProductAvailability)
			self.deliveryTimeDays = try Self.decodeValue(in: container, forKey: .deliveryTimeDays)
			self.supplierReputation = try Self.decodeValue(in: container, forKey: .supplierReputation)
			self.supplierBarcode = try Self.decodeValue(in: container, forKey: .supplierBarcode)
			self.supplierBarcodeTypeId = try container.decodeIdIfPresent(forKey: .supplierBarcodeTypeId)
			self.packaging = try Self.decodeValue(in: container, forKey: .packaging)
			self.supplierPriceStatus = try Self.decodeValue(in: container, forKey: .supplierPriceStatus)
			self.creationTimestamp = try Self.decodeTimestamp(in: container, forKey: .creationTimestamp)
			self.modificationTimestamp = try Self.decodeTimestamp(in: container, forKey: .modificationTimestamp)
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

	// MARK: - Decoding helpers

	/// Decodes an optional value returned as a string or a number, treating empty strings as unset.
	private static func decodeValue(in container: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) throws -> String? {
		guard let value = try container.decodeIfPresent(MultiType.self, forKey: key)?.stringValue, !value.isEmpty else {
			return nil
		}
		return value
	}

	/// Decodes an optional Unix timestamp returned as a number or a string, treating empty and zero values as unset.
	private static func decodeTimestamp(in container: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) throws -> Int? {
		guard let timestamp = try container.decodeIfPresent(MultiType.self, forKey: key)?.intValue, timestamp > 0 else {
			return nil
		}
		return timestamp
	}

	// MARK: - Protocol methods

	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(productId)
		hasher.combine(supplierProductRef)
		hasher.combine(optional: supplierDescription)
		hasher.combine(supplierId)
		hasher.combine(supplierName)
		hasher.combine(supplierMinimumQuantity)
		hasher.combine(supplierPrice)
		hasher.combine(supplierUnitPrice)
		hasher.combine(supplierDiscountRate)
		hasher.combine(optional: supplierDiscountAmount)
		hasher.combine(optional: supplierCharges)
		hasher.combine(supplierTaxRate)
		hasher.combine(optional: supplierTaxNPR)
		hasher.combine(optional: supplierMulticurrencyCode)
		hasher.combine(optional: supplierMulticurrencyPrice)
		hasher.combine(optional: supplierMulticurrencyUnitPrice)
		hasher.combine(optional: supplierMulticurrencyRate)
		hasher.combine(optional: supplierPriceBaseType)
		hasher.combine(optional: supplierProductAvailability)
		hasher.combine(optional: deliveryTimeDays)
		hasher.combine(optional: supplierReputation)
		hasher.combine(optional: supplierBarcode)
		hasher.combine(optional: supplierBarcodeTypeId)
		hasher.combine(optional: packaging)
		hasher.combine(optional: supplierPriceStatus)
	}

	/// Encodes the `POST /products/{id}/purchase_prices` body
	///
	/// Unset optional values are sent as Dolibarr's defaults, so a POST that updates an existing
	/// price clears them. Unset ``deliveryTimeDays`` is sent as `null` to clear it.
	public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: WriteCodingKeys.self)
		try container.encode(supplierMinimumQuantity, forKey: .supplierMinimumQuantity)
		try container.encode(supplierPrice, forKey: .supplierPrice)
		try container.encode(supplierPriceBaseType ?? "HT", forKey: .supplierPriceBaseType)
		try container.encode(supplierId, forKey: .supplierId)
		try container.encode(supplierProductAvailability ?? "0", forKey: .supplierProductAvailability)
		try container.encode(supplierProductRef, forKey: .supplierProductRef)
		try container.encode(supplierTaxRate, forKey: .supplierTaxRate)
		try container.encode(supplierCharges ?? "0", forKey: .supplierCharges)
		try container.encode(supplierDiscountRate, forKey: .supplierDiscountRate)
		try container.encode(supplierDiscountAmount ?? "0", forKey: .supplierDiscountAmount)
		try container.encode(isSupplierTaxNPR ? 1 : 0, forKey: .supplierTaxNPR)
		if let deliveryTimeDays {
			try container.encode(deliveryTimeDays, forKey: .deliveryTimeDays)
		} else {
			try container.encodeNil(forKey: .deliveryTimeDays)
		}
		try container.encode(supplierReputation ?? "", forKey: .supplierReputation)
		if let supplierMulticurrencyPrice {
			try container.encode(supplierMulticurrencyPrice, forKey: .supplierMulticurrencyPrice)
			try container.encode(supplierMulticurrencyRate ?? "1", forKey: .supplierMulticurrencyRate)
		} else {
			try container.encode(supplierPrice, forKey: .supplierMulticurrencyPrice)
			try container.encode("1", forKey: .supplierMulticurrencyRate)
		}
		try container.encode(supplierPriceBaseType ?? "HT", forKey: .supplierMulticurrencyPriceBaseType)
		try container.encodeIfPresent(supplierMulticurrencyCode, forKey: .supplierMulticurrencyCode)
		try container.encode(supplierDescription ?? "", forKey: .supplierDescription)
		try container.encode(supplierBarcode ?? "", forKey: .supplierBarcode)
		try container.encodeIfPresent(supplierBarcodeTypeId, forKey: .supplierBarcodeTypeId)
	}

	public static func == (lhs: DolibarrProductSupplierPrice, rhs: DolibarrProductSupplierPrice) -> Bool {
		lhs.id == rhs.id &&
		lhs.productId == rhs.productId &&
		lhs.supplierProductRef == rhs.supplierProductRef &&
		lhs.supplierDescription == rhs.supplierDescription &&
		lhs.supplierId == rhs.supplierId &&
		lhs.supplierName == rhs.supplierName &&
		lhs.supplierMinimumQuantity == rhs.supplierMinimumQuantity &&
		lhs.supplierPrice == rhs.supplierPrice &&
		lhs.supplierUnitPrice == rhs.supplierUnitPrice &&
		lhs.supplierDiscountRate == rhs.supplierDiscountRate &&
		lhs.supplierDiscountAmount == rhs.supplierDiscountAmount &&
		lhs.supplierCharges == rhs.supplierCharges &&
		lhs.supplierTaxRate == rhs.supplierTaxRate &&
		lhs.supplierTaxNPR == rhs.supplierTaxNPR &&
		lhs.supplierMulticurrencyCode == rhs.supplierMulticurrencyCode &&
		lhs.supplierMulticurrencyPrice == rhs.supplierMulticurrencyPrice &&
		lhs.supplierMulticurrencyUnitPrice == rhs.supplierMulticurrencyUnitPrice &&
		lhs.supplierMulticurrencyRate == rhs.supplierMulticurrencyRate &&
		lhs.supplierPriceBaseType == rhs.supplierPriceBaseType &&
		lhs.supplierProductAvailability == rhs.supplierProductAvailability &&
		lhs.deliveryTimeDays == rhs.deliveryTimeDays &&
		lhs.supplierReputation == rhs.supplierReputation &&
		lhs.supplierBarcode == rhs.supplierBarcode &&
		lhs.supplierBarcodeTypeId == rhs.supplierBarcodeTypeId &&
		lhs.packaging == rhs.packaging &&
		lhs.supplierPriceStatus == rhs.supplierPriceStatus
	}

}
