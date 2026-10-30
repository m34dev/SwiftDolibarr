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
//  DolibarrOrderLine.swift
//  SwiftDolibarr
//
//  Created by William Mead on 18/01/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A single line item within a Dolibarr order.
///
/// Each line references its parent order via ``orderId`` and inherits
/// pricing, tax, and product details from ``CommonCommercialTransactionObjectLine``.
///
/// - Note: Requires the **commande** module to be activated in Dolibarr.
/// - SeeAlso: ``DolibarrOrder``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrOrderLine: CommonCommercialTransactionObjectLine {

	// MARK: - Properties

	/// Associated order ID
	///
	/// - Mapped Dolibarr property: **fk_commande**
	public var orderId: String

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case orderId = "fk_commande"
	}

	// MARK: - Inits

	public init(
		orderId: String = "",
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
		self.orderId = orderId
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
			orderId = try container.decode(String.self, forKey: .orderId)
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

    public init(copying source: DolibarrOrderLine) {
        self.orderId = source.orderId
        super.init(copying: source)
    }

    // MARK: - Methods

    public func copy(_ source: DolibarrOrderLine) {
        self.orderId = source.orderId
        super.copy(source)
    }

	// MARK: - Protocol methods

	override public func hash(into hasher: inout Hasher) {
		hasher.combine(orderId)
		super.hash(into: &hasher)
	}

	override public func isEqual(to other: CommonBusinessObjectLine) -> Bool {
		guard let other = other as? DolibarrOrderLine else { return false }
		return orderId == other.orderId
		&& super.isEqual(to: other)
	}

	override public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(orderId, forKey: .orderId)
		try super.encode(to: encoder)
	}

}
