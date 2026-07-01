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
//  DolibarrWarehouse.swift
//  SwiftDolibarr
//
//  Created by William Mead on 02/07/2025.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A Dolibarr warehouse (stock location) object.
///
/// Maps to the Dolibarr `/warehouses` REST API endpoint. A warehouse
/// stores products and can have a parent warehouse via ``parentId``.
///
/// ## Overview
///
/// Includes location details such as address, city, and country,
/// along with a ``status`` indicating whether the warehouse is open or closed.
///
/// - Note: Requires the **Stock** module to be activated in Dolibarr.
/// - SeeAlso: ``DolibarrStockMovement``
/// - SeeAlso: ``DolibarrProductStockWarehouse``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrWarehouse: CommonBusinessObject, Locatable {

    // MARK: - Properties

	// Required

	public var label: String

	// Optional

	public var parentId: String?
	public var description: String?
	public var location: String?
	public var address: String?
	public var zipCode: String?
	public var city: String?
	public var countryId: String?
	public var phone: String?

	// Computed

	override public var status: DolibarrObjectStatus {
		guard let status = DolibarrObjectStatus.warehouses.first(where: { $0.code == statusCode }) else { return .unknown }
		return status
	}

    // MARK: - Enums

    enum CodingKeys: String, CodingKey {
		case label
		case parentId = "fk_parent"
        case description
        case location = "lieu"
        case address
        case zipCode = "zip"
        case city = "town"
        case countryId = "country_id"
        case phone
    }

    // MARK: - Inits

    public init(
		label: String = "",
		parentId: String? = nil,
		description: String? = nil,
		location: String? = nil,
		address: String? = nil,
		zipCode: String? = nil,
		city: String? = nil,
		countryId: String? = nil,
		phone: String? = nil,
		id: String = "",
		statusCode: String = "",
		arrayOptions: [String: MultiType]? = nil,
		notePublic: String? = nil,
		notePrivate: String? = nil,
    ) {
		self.label = label
		self.parentId = parentId
        self.description = description
        self.location = location
        self.address = address
        self.zipCode = zipCode
        self.city = city
        self.countryId = countryId
        self.phone = phone
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
			self.label = try container.decode(String.self, forKey: .label)
			self.parentId = try container.decodeIfPresent(String.self, forKey: .parentId)
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            self.location = try container.decodeIfPresent(String.self, forKey: .location)
			self.address = try container.decodeIfPresent(String.self, forKey: .address)
			self.zipCode = try container.decodeIfPresent(String.self, forKey: .zipCode)
			self.city = try container.decodeIfPresent(String.self, forKey: .city)
            self.countryId = try container.decodeIfPresent(String.self, forKey: .countryId)
            self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
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

    public init(copying source: DolibarrWarehouse) {
		self.label = source.label
		self.parentId = source.parentId
		self.description = source.description
		self.location = source.location
		self.address = source.address
		self.zipCode = source.zipCode
		self.city = source.city
		self.countryId = source.countryId
		self.phone = source.phone
		super.init(copying: source)
    }

    // MARK: - Methods

    public func copy(_ source: DolibarrWarehouse) {
		self.label = source.label
		self.parentId = source.parentId
		self.description = source.description
		self.location = source.location
		self.address = source.address
		self.zipCode = source.zipCode
		self.city = source.city
		self.countryId = source.countryId
		self.phone = source.phone
		super.copy(source)
    }

    // MARK: - Protocol methods

    override public func hash(into hasher: inout Hasher) {
		hasher.combine(label)
		hasher.combine(optional: parentId)
		hasher.combine(optional: description)
		hasher.combine(optional: location)
		hasher.combine(optional: address)
		hasher.combine(optional: zipCode)
		hasher.combine(optional: city)
		hasher.combine(optional: countryId)
		hasher.combine(optional: phone)
		super.hash(into: &hasher)
    }

    override public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfNotEmpty(label, forKey: .label)
		try container.encodeIfPresent(parentId, forKey: .parentId)
		try container.encodeIfPresent(location, forKey: .location)
		try container.encodeIfPresent(description, forKey: .description)
		try container.encodeIfPresent(address, forKey: .address)
		try container.encodeIfPresent(zipCode, forKey: .zipCode)
		try container.encodeIfPresent(city, forKey: .city)
		try container.encodeIfPresent(phone, forKey: .phone)
        try container.encodeIfPresent(countryId, forKey: .countryId)
		try super.encode(to: encoder)
    }

	public static func == (lhs: DolibarrWarehouse, rhs: DolibarrWarehouse) -> Bool {
		lhs.label == rhs.label
		&& lhs.parentId == rhs.parentId
		&& lhs.description == rhs.description
		&& lhs.location == rhs.location
		&& lhs.address == rhs.address
		&& lhs.zipCode == rhs.zipCode
		&& lhs.city == rhs.city
		&& lhs.countryId == rhs.countryId
		&& lhs.phone == rhs.phone
		&& (lhs as CommonBusinessObject) == (rhs as CommonBusinessObject)
	}

}
