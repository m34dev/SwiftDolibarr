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
//  DolibarrProduct.swift
//  SwiftDolibarr
//
//  Created by William Mead on 16/05/2025.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A Dolibarr product or service object.
///
/// Maps to the Dolibarr `/products` REST API endpoint. The ``type`` property
/// distinguishes between a product and a service via ``ProductType``.
///
/// ## Overview
///
/// Each product has a ``ref``, ``label``, sell/buy statuses, pricing information,
/// and optional stock warehouse data.
///
/// - Note: Requires the **Product** and/or **Service** module to be activated in Dolibarr.
/// - SeeAlso: ``ProductType``
/// - SeeAlso: ``DolibarrProductStockWarehouse``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrProduct: CommonBusinessObject {

	// MARK: - Properties

	// Required

	public var ref: String
	public var sellStatus: String
	public var buyStatus: String
	public var typeCode: String
	public var label: String

	// Optional

	public var description: String?
	public var duration: String?
	public var finished: String?
	public var priceExclTax: String?
	public var priceInclTax: String?
	public var priceMinExclTax: String?
	public var priceMinInclTax: String?
	public var priceBaseType: String?
	public var priceLabel: String?
	public var taxRate: String?
	public var url: String?
	public var barcode: String?
	public var barcodeType: String?
	public var stockWarehouse: DolibarrProductStockWarehouse?
	public var defaultWarehouseId: String?

	// Computed

	public var type: ProductType {
		guard let type = ProductType.allProductTypes.first(where: { $0.code == typeCode }) else { return .unknown }
		return type
	}

	override public var status: DolibarrObjectStatus {
		let combinedStatusCodes = "\(sellStatus)\(buyStatus)"
		guard let status = DolibarrObjectStatus.productsServices.first(where: { $0.code == combinedStatusCodes }) else {
			return .unknown
		}
		return status
	}

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case ref = "ref"
		case sellStatus = "status"
		case buyStatus = "status_buy"
		case typeCode = "type"
		case label
		case description
		case duration
		case finished
		case priceExclTax = "price"
		case priceInclTax = "price_ttc"
		case priceMinExclTax = "price_min"
		case priceMinInclTax = "price_min_ttc"
		case priceBaseType = "price_base_type"
		case priceLabel = "price_label"
		case taxRate = "tva_tx"
		case url
		case barcode
		case barcodeType = "barcode_type"
		case stockWarehouse = "stock_warehouse"
		case defaultWarehouseId = "fk_default_warehouse"
	}

	// MARK: - Inits

	public init(
		ref: String = "",
		sellStatus: String = "1",
		buyStatus: String = "1",
		typeCode: String = "0",
		label: String = "",
		description: String? = nil,
		duration: String? = nil,
		finished: String? = nil,
		priceExclTax: String? = nil,
		priceInclTax: String? = nil,
		priceMinExclTax: String? = nil,
		priceMinInclTax: String? = nil,
		priceBaseType: String? = nil,
		priceLabel: String? = nil,
		taxRate: String? = nil,
		url: String? = nil,
		barcode: String? = nil,
		barcodeType: String? = nil,
		stockWarehouse: DolibarrProductStockWarehouse? = nil,
		defaultWarehouseId: String? = nil,
		id: String = "",
		arrayOptions: [String: MultiType]? = nil,
		notePublic: String? = nil,
		notePrivate: String? = nil,
	) {
		self.ref = ref
		self.sellStatus = sellStatus
		self.buyStatus = buyStatus
		self.typeCode = typeCode
		self.label = label
		self.description = description
		self.duration = duration
		self.finished = finished
		self.priceExclTax = priceExclTax
		self.priceInclTax = priceInclTax
		self.priceMinExclTax = priceMinExclTax
		self.priceMinInclTax = priceMinInclTax
		self.priceBaseType = priceBaseType
		self.priceLabel = priceLabel
		self.taxRate = taxRate
		self.url = url
		self.barcode = barcode
		self.barcodeType = barcodeType
		self.stockWarehouse = stockWarehouse
		self.defaultWarehouseId = defaultWarehouseId
		super.init(id: id, arrayOptions: arrayOptions, notePublic: notePublic, notePrivate: notePrivate)
	}

	public required init(from decoder: any Decoder) throws {
		do {
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
			#endif
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.ref = try container.decode(String.self, forKey: .ref)
			self.sellStatus = try container.decode(String.self, forKey: .sellStatus)
			self.buyStatus = try container.decode(String.self, forKey: .buyStatus)
			self.typeCode = try container.decode(String.self, forKey: .typeCode)
			self.label = try container.decode(String.self, forKey: .label)
			self.description = try container.decodeIfPresent(String.self, forKey: .description)
			self.duration = try container.decodeIfPresent(String.self, forKey: .duration)
			self.finished = try container.decodeIfPresent(String.self, forKey: .finished)
			self.priceExclTax = try container.decodeIfPresent(String.self, forKey: .priceExclTax)
			self.priceInclTax = try container.decodeIfPresent(String.self, forKey: .priceInclTax)
			self.priceMinExclTax = try container.decodeIfPresent(String.self, forKey: .priceMinExclTax)
			self.priceMinInclTax = try container.decodeIfPresent(String.self, forKey: .priceMinInclTax)
			self.priceBaseType = try container.decodeIfPresent(String.self, forKey: .priceBaseType)
			self.priceLabel = try container.decodeIfPresent(String.self, forKey: .priceLabel)
			self.taxRate = try container.decodeIfPresent(String.self, forKey: .taxRate)
			self.url = try container.decodeIfPresent(String.self, forKey: .url)
			self.barcode = try container.decodeIfPresent(String.self, forKey: .barcode)
			self.barcodeType = try container.decodeIfPresent(String.self, forKey: .barcodeType)
			if let productStock = try? container.decode(DolibarrProductStockWarehouse.self, forKey: .stockWarehouse) {
				self.stockWarehouse = productStock
			} else {
				self.stockWarehouse = nil
			}
			self.defaultWarehouseId = try container.decodeIfPresent(String.self, forKey: .defaultWarehouseId)
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

    public init(copying source: DolibarrProduct) {
        self.ref = source.ref
        self.sellStatus = source.sellStatus
        self.buyStatus = source.buyStatus
        self.typeCode = source.typeCode
        self.label = source.label
        self.description = source.description
        self.duration = source.duration
        self.finished = source.finished
        self.priceExclTax = source.priceExclTax
        self.priceInclTax = source.priceInclTax
        self.priceMinExclTax = source.priceMinExclTax
        self.priceMinInclTax = source.priceMinInclTax
        self.priceBaseType = source.priceBaseType
        self.priceLabel = source.priceLabel
        self.taxRate = source.taxRate
        self.url = source.url
        self.barcode = source.barcode
        self.barcodeType = source.barcodeType
        self.stockWarehouse = source.stockWarehouse
        self.defaultWarehouseId = source.defaultWarehouseId
        super.init(copying: source)
    }

    // MARK: - Methods

    public func copy(_ source: DolibarrProduct) {
        self.ref = source.ref
        self.sellStatus = source.sellStatus
        self.buyStatus = source.buyStatus
        self.typeCode = source.typeCode
        self.label = source.label
        self.description = source.description
        self.duration = source.duration
        self.finished = source.finished
        self.priceExclTax = source.priceExclTax
        self.priceInclTax = source.priceInclTax
        self.priceMinExclTax = source.priceMinExclTax
        self.priceMinInclTax = source.priceMinInclTax
        self.priceBaseType = source.priceBaseType
        self.priceLabel = source.priceLabel
        self.taxRate = source.taxRate
        self.url = source.url
        self.barcode = source.barcode
        self.barcodeType = source.barcodeType
        self.stockWarehouse = source.stockWarehouse
        self.defaultWarehouseId = source.defaultWarehouseId
        super.copy(source)
    }

	// MARK: - Protocol methods

	override public func hash(into hasher: inout Hasher) {
		hasher.combine(ref)
		hasher.combine(sellStatus)
		hasher.combine(buyStatus)
		hasher.combine(typeCode)
		hasher.combine(label)
		hasher.combine(optional: description)
		hasher.combine(optional: duration)
		hasher.combine(optional: finished)
		hasher.combine(optional: priceExclTax)
		hasher.combine(optional: priceInclTax)
		hasher.combine(optional: priceMinExclTax)
		hasher.combine(optional: priceMinInclTax)
		hasher.combine(optional: priceBaseType)
		hasher.combine(optional: priceLabel)
		hasher.combine(optional: taxRate)
		hasher.combine(optional: url)
		hasher.combine(optional: barcode)
		hasher.combine(optional: barcodeType)
		hasher.combine(optional: stockWarehouse)
		hasher.combine(optional: defaultWarehouseId)
		super.hash(into: &hasher)
	}

	override public func isEqual(to other: CommonBusinessObject) -> Bool {
		guard let other = other as? DolibarrProduct else { return false }
		return ref == other.ref
		&& sellStatus == other.sellStatus
		&& buyStatus == other.buyStatus
		&& typeCode == other.typeCode
		&& label == other.label
		&& description == other.description
		&& duration == other.duration
		&& finished == other.finished
		&& priceExclTax == other.priceExclTax
		&& priceInclTax == other.priceInclTax
		&& priceMinExclTax == other.priceMinExclTax
		&& priceMinInclTax == other.priceMinInclTax
		&& priceBaseType == other.priceBaseType
		&& priceLabel == other.priceLabel
		&& taxRate == other.taxRate
		&& url == other.url
		&& barcode == other.barcode
		&& barcodeType == other.barcodeType
		&& stockWarehouse == other.stockWarehouse
		&& defaultWarehouseId == other.defaultWarehouseId
		&& super.isEqual(to: other)
	}

	override public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfNotEmpty(ref, forKey: .ref)
		try container.encodeIfNotEmpty(sellStatus, forKey: .sellStatus)
		try container.encodeIfNotEmpty(buyStatus, forKey: .buyStatus)
		try container.encodeIfNotEmpty(typeCode, forKey: .typeCode)
		try container.encodeIfNotEmpty(label, forKey: .label)
		try container.encodeIfPresent(description, forKey: .description)
		try container.encodeIfPresent(duration, forKey: .duration)
		try container.encodeIfPresent(finished, forKey: .finished)
		try container.encodeIfPresent(priceExclTax, forKey: .priceExclTax)
		try container.encodeIfPresent(priceInclTax, forKey: .priceInclTax)
		try container.encodeIfPresent(priceMinExclTax, forKey: .priceMinExclTax)
		try container.encodeIfPresent(priceMinInclTax, forKey: .priceMinInclTax)
		try container.encodeIfPresent(priceBaseType, forKey: .priceBaseType)
		try container.encodeIfPresent(priceLabel, forKey: .priceLabel)
		try container.encodeIfPresent(taxRate, forKey: .taxRate)
		try container.encodeIfPresent(url, forKey: .url)
		try container.encodeIfPresent(barcode, forKey: .barcode)
		try container.encodeIfPresent(barcodeType, forKey: .barcodeType)
		try container.encodeIfPresent(defaultWarehouseId, forKey: .defaultWarehouseId)
		try super.encode(to: encoder)
	}

}
