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
//  DolibarrSupplierOrderLine.swift
//  SwiftDolibarr
//
//  Created by William Mead on 15/09/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A single line item within a Dolibarr supplier order.
///
/// Each line references its parent supplier order via ``supplierOrderId`` and inherits
/// pricing, tax, and product details from ``CommonCommercialTransactionObjectLine``.
///
/// - Note: Requires the **Supplier order (Commande fournisseur)** module to be activated in Dolibarr.
/// - SeeAlso: ``DolibarrSupplierOrder``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrSupplierOrderLine: CommonCommercialTransactionObjectLine {

	// MARK: - Properties

	/// Associated supplier order ID
	///
	/// - Mapped Dolibarr property: **fk_commande**
	public var supplierOrderId: String

	/// Supplier's own reference for the product on this line
	///
	/// - Mapped Dolibarr property: **ref_fourn**
	public var supplierProductRef: String?

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case supplierOrderId = "fk_commande"
		case supplierProductRef = "ref_fourn"
	}

	// MARK: - Inits

	public init(
		supplierOrderId: String = "",
		supplierProductRef: String? = nil,
		specialCode: String = "0",
		taxRate: String = "0.0",
		unitPriceExclTax: String = "0.0",
		unitPriceInclTax: String = "0.0",
		discountRate: String = "0.0",
		totalExclTax: String = "0.0",
		totalInclTax: String = "0.0",
		totalTax: String = "0.0",
		productId: String? = nil,
		productRef: String? = nil,
		productLabel: String? = nil,
		quantity: String? = nil,
		description: String? = nil,
		id: String = "",
		rang: String = "",
	) {
		self.supplierOrderId = supplierOrderId
		self.supplierProductRef = supplierProductRef
		super.init(
			specialCode: specialCode,
			taxRate: taxRate,
			unitPriceExclTax: unitPriceExclTax,
			discountRate: discountRate,
			totalExclTax: totalExclTax,
			totalInclTax: totalInclTax,
			totalTax: totalTax,
			productId: productId,
			productRef: productRef,
			productLabel: productLabel,
			quantity: quantity,
			description: description,
			unitPriceInclTax: unitPriceInclTax,
			id: id,
			rang: rang,
		)
	}

	public required init(from decoder: Decoder) throws {
		do {
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logWithoutSignal("\(Self.self).init.decode", level: .info, category: .api)
			#endif
			let container = try decoder.container(keyedBy: CodingKeys.self)
			supplierOrderId = try container.decode(String.self, forKey: .supplierOrderId)
			supplierProductRef = try container.decodeIfPresent(String.self, forKey: .supplierProductRef)
			try super.init(from: decoder)
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logWithoutSignal("\(Self.self).init.decoded", level: .info, category: .api)
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

    public init(copying source: DolibarrSupplierOrderLine) {
        self.supplierOrderId = source.supplierOrderId
        self.supplierProductRef = source.supplierProductRef
        super.init(copying: source)
    }

    // MARK: - Methods

    public func copy(_ source: DolibarrSupplierOrderLine) {
        self.supplierOrderId = source.supplierOrderId
        self.supplierProductRef = source.supplierProductRef
        super.copy(source)
    }

	// MARK: - Protocol methods

	override public func hash(into hasher: inout Hasher) {
		hasher.combine(supplierOrderId)
		hasher.combine(optional: supplierProductRef)
		super.hash(into: &hasher)
	}

	override public func isEqual(to other: CommonBusinessObjectLine) -> Bool {
		guard let other = other as? DolibarrSupplierOrderLine else { return false }
		return supplierOrderId == other.supplierOrderId
		&& supplierProductRef == other.supplierProductRef
		&& super.isEqual(to: other)
	}

	override public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(supplierOrderId, forKey: .supplierOrderId)
		try container.encodeIfPresent(supplierProductRef, forKey: .supplierProductRef)
		try super.encode(to: encoder)
	}

}
