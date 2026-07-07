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
	/// - Mapped Dolibarr property: **fourn_ref**
	public var supplierProductRef: String
	
	/// Supplier ID
	///
	/// - Mapped Dolibarr property: **fourn_id**
	public var supplierId: String
	
	/// Supplier name
	///
	/// - Mapped Dolibarr property: **fourn_name**
	public var supplierName: String
	
	/// Supplier minimum order quantity
	///
	/// - Mapped Dolibarr property: **fourn_qty**
	public var supplierMinimumQuanity: String
	
	/// Supplier price
	///
	/// - Mapped Dolibarr property: **fourn_price**
	public var supplierPrice: String
	
	/// Supplier unit price
	///
	/// - Mapped Dolibarr property: **fourn_unitprice**
	public var supplierUnitPrice: String
	
	/// Supplier discount rate
	///
	/// - Mapped Dolibarr property: **fourn_remise_percent**
	public var supplierDiscountRate: String
	
	/// Supplier tax rate
	///
	/// - Mapped Dolibarr property: **fourn_tva_tx**
	public var supplierTaxRate: String
	
	/// Supplier multi-currency code
	///
	/// - Mapped Dolibarr property: **fourn_multicurrency_code**
	public var supplierMulticurrencyCode: String?
	
	/// Supplier price base type
	///
	/// - Mapped Dolibarr property: **price_base_type**
	public var supplierPriceBaseType: String?
	
	/// Availability
	///
	/// - Mapped Dolibarr property: **fk_availability**
	public var supplierProductAvailability: String
	
	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case id = "product_fourn_price_id"
		case productId = "id"
		case supplierProductRefDecode = "fourn_ref"
		case supplierProductRefEncode = "ref_fourn"
		case supplierId = "fourn_id"
		case supplierName = "fourn_name"
		case supplierMinimumQuanityDecode = "fourn_qty"
		case supplierMinimumQuanityEncode = "qty"
		case supplierPriceDecode = "fourn_price"
		case supplierPriceEncode = "buyprice"
		case supplierUnitPrice = "fourn_unitprice"
		case supplierDiscountRateDecode = "fourn_remise_percent"
		case supplierDiscountRateEncode = "remise_percent"
		case supplierTaxRateDecode = "fourn_tva_tx"
		case supplierTaxRateEncode = "tva_tx"
		case supplierMulticurrencyCode = "fourn_multicurrency_code"
		case supplierPriceBaseType = "price_base_type"
		case supplierProductAvailabilityDecode = "fk_availability"
		case supplierProductAvailabilityEncode = "availability"
	}

	// MARK: - Inits

	public init(
		id: String = "",
		productId: String = "",
		supplierProductRef: String = "",
		supplierId: String = "",
		supplierName: String = "",
		supplierMinimumQuanity: String = "",
		supplierPrice: String = "",
		supplierUnitPrice: String = "",
		supplierDiscountRate: String = "",
		supplierTaxRate: String = "",
		supplierMulticurrencyCode: String? = nil,
		supplierPriceBaseType: String? = nil,
		supplierProductAvailability: String = ""
	) {
		self.id = id
		self.productId = productId
		self.supplierProductRef = supplierProductRef
		self.supplierId = supplierId
		self.supplierName = supplierName
		self.supplierMinimumQuanity = supplierMinimumQuanity
		self.supplierPrice = supplierPrice
		self.supplierUnitPrice = supplierUnitPrice
		self.supplierDiscountRate = supplierDiscountRate
		self.supplierTaxRate = supplierTaxRate
		self.supplierMulticurrencyCode = supplierMulticurrencyCode
		self.supplierPriceBaseType = supplierPriceBaseType
		self.supplierProductAvailability = supplierProductAvailability
	}

	public init(from decoder: any Decoder) throws {
		do {
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
			#endif
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.id = try container.decode(String.self, forKey: .id)
			self.productId = try container.decode(String.self, forKey: .productId)
			self.supplierProductRef = try container.decode(String.self, forKey: .supplierProductRefDecode)
			self.supplierId = try container.decode(String.self, forKey: .supplierId)
			self.supplierName = try container.decode(String.self, forKey: .supplierName)
			self.supplierMinimumQuanity = try container.decode(String.self, forKey: .supplierMinimumQuanityDecode)
			self.supplierPrice = try container.decode(String.self, forKey: .supplierPriceDecode)
			self.supplierUnitPrice = try container.decode(String.self, forKey: .supplierUnitPrice)
			self.supplierDiscountRate = try container.decode(String.self, forKey: .supplierDiscountRateDecode)
			self.supplierTaxRate = try container.decode(String.self, forKey: .supplierTaxRateDecode)
			self.supplierMulticurrencyCode = try container.decodeIfPresent(String.self, forKey: .supplierMulticurrencyCode)
			self.supplierPriceBaseType = try container.decodeIfPresent(String.self, forKey: .supplierPriceBaseType)
			self.supplierProductAvailability = try container.decode(String.self, forKey: .supplierProductAvailabilityDecode)
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
		hasher.combine(productId)
		hasher.combine(supplierProductRef)
		hasher.combine(supplierId)
		hasher.combine(supplierName)
		hasher.combine(supplierMinimumQuanity)
		hasher.combine(supplierPrice)
		hasher.combine(supplierUnitPrice)
		hasher.combine(supplierDiscountRate)
		hasher.combine(supplierTaxRate)
		hasher.combine(optional: supplierMulticurrencyCode)
		hasher.combine(optional: supplierPriceBaseType)
		hasher.combine(supplierProductAvailability)
	}

	public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(productId, forKey: .productId)
		try container.encode(supplierProductRef, forKey: .supplierProductRefEncode)
		try container.encode(supplierId, forKey: .supplierId)
		try container.encode(supplierName, forKey: .supplierName)
		try container.encode(supplierMinimumQuanity, forKey: .supplierMinimumQuanityEncode)
		try container.encode(supplierPrice, forKey: .supplierPriceEncode)
		try container.encode(supplierUnitPrice, forKey: .supplierUnitPrice)
		try container.encode(supplierDiscountRate, forKey: .supplierDiscountRateEncode)
		try container.encode(supplierTaxRate, forKey: .supplierTaxRateEncode)
		try container.encodeIfPresent(supplierMulticurrencyCode, forKey: .supplierMulticurrencyCode)
		try container.encodeIfPresent(supplierPriceBaseType, forKey: .supplierPriceBaseType)
		try container.encode(supplierProductAvailability, forKey: .supplierProductAvailabilityEncode)
	}

	public static func == (lhs: DolibarrProductSupplierPrice, rhs: DolibarrProductSupplierPrice) -> Bool {
		lhs.id == rhs.id &&
		lhs.productId == rhs.productId &&
		lhs.supplierProductRef == rhs.supplierProductRef &&
		lhs.supplierId == rhs.supplierId &&
		lhs.supplierName == rhs.supplierName &&
		lhs.supplierMinimumQuanity == rhs.supplierMinimumQuanity &&
		lhs.supplierPrice == rhs.supplierPrice &&
		lhs.supplierUnitPrice == rhs.supplierUnitPrice &&
		lhs.supplierDiscountRate == rhs.supplierDiscountRate &&
		lhs.supplierTaxRate == rhs.supplierTaxRate &&
		lhs.supplierMulticurrencyCode == rhs.supplierMulticurrencyCode &&
		lhs.supplierPriceBaseType == rhs.supplierPriceBaseType &&
		lhs.supplierProductAvailability == rhs.supplierProductAvailability
	}

}
