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
//  DolibarrStockMovement.swift
//  SwiftDolibarr
//
//  Created by William Mead on 21/10/2025.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A Dolibarr stock movement object.
///
/// Maps to the Dolibarr `/stockmovements` REST API endpoint. Records
/// a quantity change for a product in a specific warehouse.
///
/// ## Overview
///
/// Each movement links a ``productId`` to a ``warehouseId`` with an optional
/// ``quantity``, ``label``, and ``inventoryCode``. Supports both Dolibarr
/// v23+ and earlier field naming conventions.
///
/// - Note: Requires the **Stock** module to be activated in Dolibarr.
/// - SeeAlso: ``DolibarrWarehouse``
/// - SeeAlso: ``DolibarrProduct``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrStockMovement: Equatable, Hashable, Codable, DolibarrObject {

	// MARK: - Properties

	// Required

	public var id: String
	public var productId: String
	public var warehouseId: String

	// Optional

	public var arrayOptions: [String: MultiType]?
	public var originId: String?
	public var originType: String?
	public var quantity: String?
	public var typeCode: String?
	public var label: String?
	public var price: String?
	public var inventoryCode: String?
	public var dateModify: Int?
	public var userAuthorId: String?
	public var tms: Int?

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case id
		case arrayOptions = "array_options"
		case productId = "product_id"
		case warehouseId = "warehouse_id"
		case originId = "origin_id"
		case originType = "origin_type"
		case quantity = "qty"
		case typeCode = "type"
		case label // Dolibarr compatibility => v23
		case price
		case inventoryCode = "inventorycode" // Dolibarr compatibility < v23
		case movementCode = "movementcode" // Dolibarr compatibility => v23
		case movementLabel = "movementlabel" // Dolibarr compatibility < v23
		case dateModify = "datem"
		case userAuthorId = "fk_user_author"
		case tms
	}

	// MARK: - Inits

	public init(
		id: String = "",
		arrayOptions: [String: MultiType]? = nil,
		productId: String = "",
		warehouseId: String = "",
		originId: String? = nil,
		originType: String? = nil,
		quantity: String? = nil,
		typeCode: String? = nil,
		label: String? = nil,
		price: String? = nil,
		inventoryCode: String? = nil,
		dateModify: Int? = nil,
		userAuthorId: String? = nil,
		tms: Int? = nil
	) {
		self.id = id
		self.arrayOptions = arrayOptions
		self.productId = productId
		self.warehouseId = warehouseId
		self.originId = originId
		self.originType = originType
		self.quantity = quantity
		self.typeCode = typeCode
		self.label = label
		self.price = price
		self.inventoryCode = inventoryCode
		self.dateModify = dateModify
		self.userAuthorId = userAuthorId
		self.tms = tms
	}
	
	public init(from decoder: any Decoder) throws {
		do {
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
#endif
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.id = try container.decode(String.self, forKey: .id)
			if let dictArrayOptions = try? container.decode([String: MultiType].self, forKey: .arrayOptions) {
				self.arrayOptions = dictArrayOptions
			} else {
				self.arrayOptions = nil
			}
			self.productId = try container.decode(String.self, forKey: .productId)
			self.warehouseId = try container.decode(String.self, forKey: .warehouseId)
			self.originId = try container.decodeIfPresent(String.self, forKey: .originId)
			self.originType = try container.decodeIfPresent(String.self, forKey: .originType)
			self.quantity = try container.decodeIfPresent(String.self, forKey: .quantity)
			self.typeCode = try container.decodeIfPresent(String.self, forKey: .typeCode)
			self.label = try container.decodeIfPresent(String.self, forKey: .label)
			self.price = try container.decodeIfPresent(String.self, forKey: .price)
			if let invCode = try container.decodeIfPresent(String.self, forKey: .movementCode) { // Dolibarr compatibility => v23
				self.inventoryCode = invCode
			} else {
				// Dolibarr compatibility < v23
				self.inventoryCode = try container.decodeIfPresent(String.self, forKey: .inventoryCode)
			}
			self.dateModify = try container.decodeIfPresent(Int.self, forKey: .dateModify)
			self.userAuthorId = try container.decodeIfPresent(String.self, forKey: .userAuthorId)
			self.tms = try container.decodeIfPresent(Int.self, forKey: .tms)
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

	public init(copying source: DolibarrStockMovement) {
		self.id = source.id
		self.arrayOptions = source.arrayOptions
		self.productId = source.productId
		self.warehouseId = source.warehouseId
		self.originId = source.originId
		self.originType = source.originType
		self.quantity = source.quantity
		self.typeCode = source.typeCode
		self.label = source.label
		self.price = source.price
		self.inventoryCode = source.inventoryCode
		self.dateModify = source.dateModify
		self.userAuthorId = source.userAuthorId
		self.tms = source.tms
	}
	
	// MARK: - Methods
	
	public func copy(_ source: DolibarrStockMovement) {
		self.id = source.id
		self.arrayOptions = source.arrayOptions
		self.productId = source.productId
		self.warehouseId = source.warehouseId
		self.originId = source.originId
		self.originType = source.originType
		self.quantity = source.quantity
		self.typeCode = source.typeCode
		self.label = source.label
		self.price = source.price
		self.inventoryCode = source.inventoryCode
		self.dateModify = source.dateModify
		self.userAuthorId = source.userAuthorId
		self.tms = source.tms
	}
	
	// MARK: - Protocol methods

	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(productId)
		hasher.combine(warehouseId)
		hasher.combine(optional: arrayOptions)
		hasher.combine(optional: originId)
		hasher.combine(optional: originType)
		hasher.combine(optional: quantity)
		hasher.combine(optional: typeCode)
		hasher.combine(optional: label)
		hasher.combine(optional: price)
		hasher.combine(optional: inventoryCode)
		hasher.combine(optional: dateModify)
		hasher.combine(optional: userAuthorId)
		hasher.combine(optional: tms)
	}

	public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfNotEmpty(id, forKey: .id)
		try container.encodeIfNotEmpty(productId, forKey: .productId)
		try container.encodeIfNotEmpty(warehouseId, forKey: .warehouseId)
		try container.encodeIfPresent(arrayOptions, forKey: .arrayOptions)
		try container.encodeIfPresentAndNotEmpty(quantity, forKey: .quantity)
		try container.encodeIfPresentAndNotEmpty(typeCode, forKey: .typeCode)
		try container.encodeIfPresent(price, forKey: .price)
		try container.encodeIfPresent(label, forKey: .label) // Dolibarr compatibility => v23
		try container.encodeIfPresent(label, forKey: .movementLabel) // Dolibarr compatibility < v23
		try container.encodeIfPresent(inventoryCode, forKey: .inventoryCode) // Dolibarr compatibility < v23
		try container.encodeIfPresent(inventoryCode, forKey: .movementCode) // Dolibarr compatibility => v23
	}

	public static func == (lhs: DolibarrStockMovement, rhs: DolibarrStockMovement) -> Bool {
		lhs.id == rhs.id
		&& lhs.productId == rhs.productId
		&& lhs.warehouseId == rhs.warehouseId
		&& lhs.arrayOptions == rhs.arrayOptions
		&& lhs.originId == rhs.originId
		&& lhs.originType == rhs.originType
		&& lhs.quantity == rhs.quantity
		&& lhs.typeCode == rhs.typeCode
		&& lhs.label == rhs.label
		&& lhs.price == rhs.price
		&& lhs.inventoryCode == rhs.inventoryCode
		&& lhs.dateModify == rhs.dateModify
		&& lhs.userAuthorId == rhs.userAuthorId
		&& lhs.tms == rhs.tms
	}

}
