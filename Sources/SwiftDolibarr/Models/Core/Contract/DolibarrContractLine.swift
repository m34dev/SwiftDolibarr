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
//  DolibarrContractLine.swift
//  SwiftDolibarr
//
//  Created by William Mead on 05/11/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A single service line within a Dolibarr contract.
///
/// Each line references its parent contract via ``contractId`` and inherits
/// pricing, tax, and product details from ``CommonCommercialTransactionObjectLine``.
/// Unlike other commercial lines, a contract line has its own ``status`` and
/// planned and actual service dates.
///
/// - Note: Requires the **Contrat** module to be activated in Dolibarr.
/// - Note: The line `ref` returned by the API depends on the endpoint: the
/// product reference when embedded in a contract, the line ID from
/// `/contracts/{id}/lines`. Use ``productRef`` for the product reference.
/// - SeeAlso: ``DolibarrContract``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrContractLine: CommonCommercialTransactionObjectLine {

	// MARK: - Properties

	// Required

	/// Associated contract ID
	///
	/// - Mapped Dolibarr property: **fk_contrat**
	public var contractId: String

	/// Line status code
	///
	/// - Mapped Dolibarr property: **status** or **statut** (legacy)
	public var statusCode: String

	// Optional

	/// Planned service start date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_start**
	public var dateStart: Int?

	/// Actual service start date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_start_real**
	public var dateStartReal: Int?

	/// Planned service end date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_end**
	public var dateEnd: Int?

	/// Actual service end date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_end_real**
	public var dateEndReal: Int?

	/// User ID who activated the service
	///
	/// - Mapped Dolibarr property: **fk_user_ouverture**
	public var userOpenId: String?

	/// User ID who closed the service
	///
	/// - Mapped Dolibarr property: **fk_user_cloture**
	public var userCloseId: String?

	/// Line comment
	///
	/// - Mapped Dolibarr property: **commentaire**
	public var comment: String?

	/// Line unit ID
	///
	/// - Mapped Dolibarr property: **fk_unit**
	public var unitId: String?

	// Computed

	/// Associated contract line status type
	public var status: DolibarrObjectStatus {
		guard let status = DolibarrObjectStatus.contractLines.first(where: { $0.code == statusCode }) else { return .unknown }
		return status
	}

	/// Planned service start date
	public var dateStarted: Date? {
		guard let dateStart else { return nil }
		return Date(timeIntervalSince1970: TimeInterval(dateStart))
	}

	/// Actual service start date
	public var dateStartedReal: Date? {
		guard let dateStartReal else { return nil }
		return Date(timeIntervalSince1970: TimeInterval(dateStartReal))
	}

	/// Planned service end date
	public var dateEnded: Date? {
		guard let dateEnd else { return nil }
		return Date(timeIntervalSince1970: TimeInterval(dateEnd))
	}

	/// Actual service end date
	public var dateEndedReal: Date? {
		guard let dateEndReal else { return nil }
		return Date(timeIntervalSince1970: TimeInterval(dateEndReal))
	}

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case contractId = "fk_contrat"
		case statusCode = "status"
		case statusCodeLegacy = "statut"
		case dateStart = "date_start"
		case dateStartReal = "date_start_real"
		case dateEnd = "date_end"
		case dateEndReal = "date_end_real"
		case userOpenId = "fk_user_ouverture"
		case userCloseId = "fk_user_cloture"
		case comment = "commentaire"
		case unitId = "fk_unit"
		case descriptionFallback = "description"
	}

	// MARK: - Inits

	public init(
		contractId: String = "",
		statusCode: String = "0",
		dateStart: Int? = nil,
		dateStartReal: Int? = nil,
		dateEnd: Int? = nil,
		dateEndReal: Int? = nil,
		userOpenId: String? = nil,
		userCloseId: String? = nil,
		comment: String? = nil,
		unitId: String? = nil,
		specialCode: String = "0",
		taxRate: String = "0.0",
		unitPriceExclTax: String = "0.0",
		unitPriceInclTax: String? = nil,
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
		rang: String = ""
	) {
		self.contractId = contractId
		self.statusCode = statusCode
		self.dateStart = dateStart
		self.dateStartReal = dateStartReal
		self.dateEnd = dateEnd
		self.dateEndReal = dateEndReal
		self.userOpenId = userOpenId
		self.userCloseId = userCloseId
		self.comment = comment
		self.unitId = unitId
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
			rang: rang
		)
	}

	public required init(from decoder: Decoder) throws {
		do {
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logWithoutSignal("\(Self.self).init.decode", level: .info, category: .api)
			#endif
			let container = try decoder.container(keyedBy: CodingKeys.self)
			contractId = try container.decode(MultiType.self, forKey: .contractId).stringValue
			if let status = try? container.decode(MultiType.self, forKey: .statusCode), !status.stringValue.isEmpty {
				statusCode = status.stringValue
			} else if let status = try? container.decode(MultiType.self, forKey: .statusCodeLegacy),
					  !status.stringValue.isEmpty {
				statusCode = status.stringValue
			} else {
				statusCode = ""
			}
			dateStart = try container.decodeIfPresent(MultiType.self, forKey: .dateStart)?.intValue
			dateStartReal = try container.decodeIfPresent(MultiType.self, forKey: .dateStartReal)?.intValue
			dateEnd = try container.decodeIfPresent(MultiType.self, forKey: .dateEnd)?.intValue
			dateEndReal = try container.decodeIfPresent(MultiType.self, forKey: .dateEndReal)?.intValue
			userOpenId = try container.decodeIdIfPresent(forKey: .userOpenId)
			userCloseId = try container.decodeIdIfPresent(forKey: .userCloseId)
			comment = try container.decodeIfPresent(String.self, forKey: .comment)
			unitId = try container.decodeIdIfPresent(forKey: .unitId)
			try super.init(from: decoder)
			if description == nil {
				description = try container.decodeIfPresent(String.self, forKey: .descriptionFallback)
			}
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

	public init(copying source: DolibarrContractLine) {
		self.contractId = source.contractId
		self.statusCode = source.statusCode
		self.dateStart = source.dateStart
		self.dateStartReal = source.dateStartReal
		self.dateEnd = source.dateEnd
		self.dateEndReal = source.dateEndReal
		self.userOpenId = source.userOpenId
		self.userCloseId = source.userCloseId
		self.comment = source.comment
		self.unitId = source.unitId
		super.init(copying: source)
	}

	// MARK: - Methods

	public func copy(_ source: DolibarrContractLine) {
		self.contractId = source.contractId
		self.statusCode = source.statusCode
		self.dateStart = source.dateStart
		self.dateStartReal = source.dateStartReal
		self.dateEnd = source.dateEnd
		self.dateEndReal = source.dateEndReal
		self.userOpenId = source.userOpenId
		self.userCloseId = source.userCloseId
		self.comment = source.comment
		self.unitId = source.unitId
		super.copy(source)
	}

	// MARK: - Protocol methods

	override public func hash(into hasher: inout Hasher) {
		hasher.combine(contractId)
		hasher.combine(statusCode)
		hasher.combine(optional: dateStart)
		hasher.combine(optional: dateStartReal)
		hasher.combine(optional: dateEnd)
		hasher.combine(optional: dateEndReal)
		hasher.combine(optional: userOpenId)
		hasher.combine(optional: userCloseId)
		hasher.combine(optional: comment)
		hasher.combine(optional: unitId)
		super.hash(into: &hasher)
	}

	override public func isEqual(to other: CommonBusinessObjectLine) -> Bool {
		guard let other = other as? DolibarrContractLine else { return false }
		return contractId == other.contractId
		&& statusCode == other.statusCode
		&& dateStart == other.dateStart
		&& dateStartReal == other.dateStartReal
		&& dateEnd == other.dateEnd
		&& dateEndReal == other.dateEndReal
		&& userOpenId == other.userOpenId
		&& userCloseId == other.userCloseId
		&& comment == other.comment
		&& unitId == other.unitId
		&& super.isEqual(to: other)
	}

	override public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(contractId, forKey: .contractId)
		try container.encodeIfNotEmpty(statusCode, forKey: .statusCode)
		try container.encodeIfPresentAndNotZero(dateStart, forKey: .dateStart)
		try container.encodeIfPresentAndNotZero(dateStartReal, forKey: .dateStartReal)
		try container.encodeIfPresentAndNotZero(dateEnd, forKey: .dateEnd)
		try container.encodeIfPresentAndNotZero(dateEndReal, forKey: .dateEndReal)
		try container.encodeIfPresentAndNotEmpty(userOpenId, forKey: .userOpenId)
		try container.encodeIfPresentAndNotEmpty(userCloseId, forKey: .userCloseId)
		try container.encodeIfPresent(comment, forKey: .comment)
		try container.encodeIfPresentAndNotEmpty(unitId, forKey: .unitId)
		try super.encode(to: encoder)
	}

}
