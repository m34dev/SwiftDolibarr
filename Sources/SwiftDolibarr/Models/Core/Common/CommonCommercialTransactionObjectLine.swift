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
//  CommonCommercialTransactionObjectLine.swift
//  SwiftDolibarr
//
//  Created by William Mead on 09/02/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// Base class for Dolibarr commercial transaction line items.
///
/// Extends ``CommonBusinessObjectLine`` with transaction line-specific
/// properties such as pricing, tax rate, discount, product reference,
/// and quantity.
///
/// ## Overview
///
/// Concrete subclasses include ``DolibarrQuoteLine``, ``DolibarrOrderLine``,
/// and ``DolibarrInvoiceLine``.
///
/// - SeeAlso: ``CommonCommercialTransactionObject``
public class CommonCommercialTransactionObjectLine: CommonBusinessObjectLine {

	// MARK: - Properties

	// Required

	/// Line special code
	///
	/// - Mapped Dolibarr property: **special_code**
	public var specialCode: String

	/// Line tax rate
	///
	/// - Mapped Dolibarr property: **tva_tx**
	public var taxRate: String

	/// Line unit price excluding tax
	///
	/// - Mapped Dolibarr property: **subprice**
	public var unitPriceExclTax: String

	/// Line discount rate percentage
	///
	/// - Mapped Dolibarr property: **remise_percent**
	public var discountRate: String

	/// Line total amount excluding tax
	///
	/// - Mapped Dolibarr property: **total_ht**
	public var totalExclTax: String

	/// Line total amount including tax
	///
	/// - Mapped Dolibarr property: **total_ttc**
	public var totalInclTax: String

	/// Line total tax amount
	///
	/// - Mapped Dolibarr property: **total_tva**
	public var totalTax: String

	// Optional

	/// Associated product ID
	///
	/// - Mapped Dolibarr property: **fk_product**
	public var productId: String?

	/// Associated product reference
	///
	/// - Mapped Dolibarr property: **product_ref**
	public var productRef: String?

	/// Associated product label
	///
	/// - Mapped Dolibarr property: **product_label**
	public var productLabel: String?

	/// Line quantity
	///
	/// - Mapped Dolibarr property: **qty**
	public var quantity: String?

	/// Line description
	///
	/// - Mapped Dolibarr property: **desc**
	public var description: String?

	/// Line unit price including tax
	///
	/// - Mapped Dolibarr property: **subprice_ttc**
	public var unitPriceInclTax: String?

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case specialCode = "special_code"
		case taxRate = "tva_tx"
		case unitPriceExclTax = "subprice"
		case unitPriceInclTax = "subprice_ttc"
		case discountRate = "remise_percent"
		case totalExclTax = "total_ht"
		case totalInclTax = "total_ttc"
		case totalTax = "total_tva"
		case productId = "fk_product"
		case productRef = "product_ref"
		case productLabel = "product_label"
		case quantity = "qty"
		case description = "desc"
	}

	// MARK: - Inits

	public init(
		specialCode: String = "0",
		taxRate: String = "0.0",
		unitPriceExclTax: String = "0.0",
		discountRate: String = "0.0",
		totalExclTax: String = "0.0",
		totalInclTax: String = "0.0",
		totalTax: String = "0.0",
		productId: String? = nil,
		productRef: String? = nil,
		productLabel: String? = nil,
		quantity: String? = nil,
		description: String? = nil,
		unitPriceInclTax: String? = nil,
		id: String = "",
		rang: String = ""
	) {
		self.specialCode = specialCode
		self.taxRate = taxRate
		self.unitPriceExclTax = unitPriceExclTax
		self.discountRate = discountRate
		self.totalExclTax = totalExclTax
		self.totalInclTax = totalInclTax
		self.totalTax = totalTax
		self.productId = productId
		self.productRef = productRef
		self.productLabel = productLabel
		self.quantity = quantity
		self.description = description
		self.unitPriceInclTax = unitPriceInclTax
		super.init(id: id, rang: rang)
	}

	public required init(from decoder: Decoder) throws {
		do {
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
			#endif
			let container = try decoder.container(keyedBy: CodingKeys.self)
			specialCode = try container.decode(String.self, forKey: .specialCode)
			taxRate = try container.decode(String.self, forKey: .taxRate)
			unitPriceExclTax = try container.decode(String.self, forKey: .unitPriceExclTax)
			discountRate = try container.decode(String.self, forKey: .discountRate)
			totalExclTax = try container.decode(String.self, forKey: .totalExclTax)
			totalInclTax = try container.decode(String.self, forKey: .totalInclTax)
			totalTax = try container.decode(String.self, forKey: .totalTax)
			productId = try container.decodeIfPresent(String.self, forKey: .productId)
			productRef = try container.decodeIfPresent(String.self, forKey: .productRef)
			productLabel = try container.decodeIfPresent(String.self, forKey: .productLabel)
			quantity = try container.decodeIfPresent(String.self, forKey: .quantity)
			description = try container.decodeIfPresent(String.self, forKey: .description)
			unitPriceInclTax = try container.decodeIfPresent(String.self, forKey: .unitPriceInclTax)
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

    public init(copying source: CommonCommercialTransactionObjectLine) {
        self.specialCode = source.specialCode
        self.taxRate = source.taxRate
        self.unitPriceExclTax = source.unitPriceExclTax
        self.discountRate = source.discountRate
        self.totalExclTax = source.totalExclTax
        self.totalInclTax = source.totalInclTax
        self.totalTax = source.totalTax
        self.productId = source.productId
        self.productRef = source.productRef
        self.productLabel = source.productLabel
        self.quantity = source.quantity
        self.description = source.description
        self.unitPriceInclTax = source.unitPriceInclTax
        super.init(copying: source)
    }

    // MARK: - Methods

    public func copy(_ source: CommonCommercialTransactionObjectLine) {
        self.specialCode = source.specialCode
        self.taxRate = source.taxRate
        self.unitPriceExclTax = source.unitPriceExclTax
        self.discountRate = source.discountRate
        self.totalExclTax = source.totalExclTax
        self.totalInclTax = source.totalInclTax
        self.totalTax = source.totalTax
        self.productId = source.productId
        self.productRef = source.productRef
        self.productLabel = source.productLabel
        self.quantity = source.quantity
        self.description = source.description
        self.unitPriceInclTax = source.unitPriceInclTax
        super.copy(source)
    }

	// MARK: - Protocol methods

	override public func hash(into hasher: inout Hasher) {
		hasher.combine(specialCode)
		hasher.combine(taxRate)
		hasher.combine(unitPriceExclTax)
		hasher.combine(discountRate)
		hasher.combine(totalExclTax)
		hasher.combine(totalInclTax)
		hasher.combine(totalTax)
		hasher.combine(optional: productId)
		hasher.combine(optional: productRef)
		hasher.combine(optional: productLabel)
		hasher.combine(optional: quantity)
		hasher.combine(optional: description)
		hasher.combine(optional: unitPriceInclTax)
		super.hash(into: &hasher)
	}

	override public func isEqual(to other: CommonBusinessObjectLine) -> Bool {
		guard let other = other as? CommonCommercialTransactionObjectLine else { return false }
		return specialCode == other.specialCode
		&& taxRate == other.taxRate
		&& unitPriceExclTax == other.unitPriceExclTax
		&& discountRate == other.discountRate
		&& totalExclTax == other.totalExclTax
		&& totalInclTax == other.totalInclTax
		&& totalTax == other.totalTax
		&& productId == other.productId
		&& productRef == other.productRef
		&& productLabel == other.productLabel
		&& quantity == other.quantity
		&& description == other.description
		&& unitPriceInclTax == other.unitPriceInclTax
		&& super.isEqual(to: other)
	}

	override public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(specialCode, forKey: .specialCode)
		try container.encode(taxRate, forKey: .taxRate)
		try container.encode(unitPriceExclTax, forKey: .unitPriceExclTax)
		try container.encode(discountRate, forKey: .discountRate)
		try container.encode(totalExclTax, forKey: .totalExclTax)
		try container.encode(totalInclTax, forKey: .totalInclTax)
		try container.encode(totalTax, forKey: .totalTax)
		try container.encodeIfPresent(productId, forKey: .productId)
		try container.encodeIfPresent(productRef, forKey: .productRef)
		try container.encodeIfPresent(productLabel, forKey: .productLabel)
		try container.encodeIfPresent(quantity, forKey: .quantity)
		try container.encodeIfPresent(description, forKey: .description)
		try container.encodeIfPresent(unitPriceInclTax, forKey: .unitPriceInclTax)
		try super.encode(to: encoder)
	}

}
