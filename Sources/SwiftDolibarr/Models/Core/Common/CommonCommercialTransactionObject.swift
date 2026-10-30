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
//  CommonCommercialTransactionObject.swift
//  SwiftDolibarr
//
//  Created by William Mead on 09/02/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// Base class for Dolibarr commercial transaction objects.
///
/// Extends ``CommonBusinessObject`` with transaction-specific properties
/// such as ``thirdPartyId``, ``ref``, financial totals, and
/// ``linkedObjectsIds`` for cross-referencing related documents.
///
/// ## Overview
///
/// Concrete subclasses include ``DolibarrQuote``, ``DolibarrOrder``,
/// and ``DolibarrInvoice``.
///
/// - SeeAlso: ``DolibarrCommercialTransaction``
/// - SeeAlso: ``CommonCommercialTransactionObjectLine``
public class CommonCommercialTransactionObject: CommonBusinessObject, DolibarrCommercialTransaction {

	// MARK: - Properties

	// Required

	/// Associated third party ID
	///
	/// - Mapped Dolibarr property: **socid**
	public var thirdPartyId: String

	/// Commercial transaction reference
	public var ref: String

	/// Total amount excluding tax
	///
	/// - Mapped Dolibarr property: **total_ht**
	public var totalExclTax: String

	/// Total tax amount
	///
	/// - Mapped Dolibarr property: **total_tva**
	public var totalTax: String

	/// Total amount including tax
	///
	/// - Mapped Dolibarr property: **total_ttc**
	public var totalInclTax: String

	// Optional

	/// Commercial transaction multicurrency code
	///
	/// - Mapped Dolibarr property: **multicurrency_code**
	public var multicurrencyCode: String?

	/// Linked objects IDs dictionary
	public var linkedObjectsIds: [String: [String: String]]?

	// Computed

	/// Linked quote IDs
	public var linkedQuotesIds: [String: String]? {
		return linkedObjectsIds?["propal"]
	}

	/// Linked order IDs
	public var linkedOrdersIds: [String: String]? {
		return linkedObjectsIds?["commande"]
	}

	/// Linked intervention IDs
	public var linkedInterventionIds: [String: String]? {
		return linkedObjectsIds?["fichinter"]
	}

	/// Linked invoice IDs
	public var linkedInvoiceIds: [String: String]? {
		return linkedObjectsIds?["facture"]
	}

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case thirdPartyId = "socid"
		case ref = "ref"
		case totalExclTax = "total_ht"
		case totalTax = "total_tva"
		case totalInclTax = "total_ttc"
		case multicurrencyCode = "multicurrency_code"
		case linkedObjectsIds = "linkedObjectsIds"
	}

	// MARK: - Inits

	public init(
		thirdPartyId: String = "",
		statusCode: String = "",
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
		self.thirdPartyId = thirdPartyId
		self.ref = ref
		self.totalExclTax = totalExclTax
		self.totalTax = totalTax
		self.totalInclTax = totalInclTax
		self.multicurrencyCode = multicurrencyCode
		self.linkedObjectsIds = linkedObjectsIds
		super.init(
			id: id,
			statusCode: statusCode,
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
			self.thirdPartyId = try container.decode(String.self, forKey: .thirdPartyId)
			self.ref = try container.decode(String.self, forKey: .ref)
			self.totalExclTax = try container.decode(MultiType.self, forKey: .totalExclTax).stringValue
			self.totalTax = try container.decode(MultiType.self, forKey: .totalTax).stringValue
			self.totalInclTax = try container.decode(MultiType.self, forKey: .totalInclTax).stringValue
			self.multicurrencyCode = try container.decodeIfPresent(String.self, forKey: .multicurrencyCode)
			if let dictlinkedObjectsIds = try? container.decode([String: [String: String]].self, forKey: .linkedObjectsIds) {
				self.linkedObjectsIds = dictlinkedObjectsIds
			} else {
				self.linkedObjectsIds = nil
			}
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
    
    public init(copying source: CommonCommercialTransactionObject) {
        self.thirdPartyId = source.thirdPartyId
        self.ref = source.ref
        self.totalExclTax = source.totalExclTax
        self.totalTax = source.totalTax
        self.totalInclTax = source.totalInclTax
        self.multicurrencyCode = source.multicurrencyCode
        self.linkedObjectsIds = source.linkedObjectsIds
        super.init(copying: source)
    }
    
    // MARK: - Methods
    
    public func copy(_ source: CommonCommercialTransactionObject) {
        self.thirdPartyId = source.thirdPartyId
        self.ref = source.ref
        self.totalExclTax = source.totalExclTax
        self.totalTax = source.totalTax
        self.totalInclTax = source.totalInclTax
        self.multicurrencyCode = source.multicurrencyCode
        self.linkedObjectsIds = source.linkedObjectsIds
        super.copy(source)
    }

	// MARK: - Protocol methods

	override public func hash(into hasher: inout Hasher) {
		hasher.combine(thirdPartyId)
		hasher.combine(ref)
		hasher.combine(totalExclTax)
		hasher.combine(totalTax)
		hasher.combine(totalInclTax)
		hasher.combine(optional: multicurrencyCode)
		hasher.combine(optional: linkedObjectsIds)
		super.hash(into: &hasher)
	}

	override public func isEqual(to other: CommonBusinessObject) -> Bool {
		guard let other = other as? CommonCommercialTransactionObject else { return false }
		return thirdPartyId == other.thirdPartyId
		&& ref == other.ref
		&& totalExclTax == other.totalExclTax
		&& totalTax == other.totalTax
		&& totalInclTax == other.totalInclTax
		&& multicurrencyCode == other.multicurrencyCode
		&& linkedObjectsIds == other.linkedObjectsIds
		&& super.isEqual(to: other)
	}

	override public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfNotEmpty(thirdPartyId, forKey: .thirdPartyId)
		try container.encodeIfNotEmpty(ref, forKey: .ref)
		try container.encode(totalExclTax, forKey: .totalExclTax)
		try container.encode(totalTax, forKey: .totalTax)
		try container.encode(totalInclTax, forKey: .totalInclTax)
		try container.encodeIfPresent(multicurrencyCode, forKey: .multicurrencyCode)
		try container.encodeIfPresent(linkedObjectsIds, forKey: .linkedObjectsIds)
		try super.encode(to: encoder)
	}

}
