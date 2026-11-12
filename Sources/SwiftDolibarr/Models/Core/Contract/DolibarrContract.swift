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
//  DolibarrContract.swift
//  SwiftDolibarr
//
//  Created by William Mead on 05/11/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A Dolibarr contract object.
///
/// Maps to the Dolibarr `/contracts` REST API endpoint. Inherits common commercial
/// transaction properties such as third-party ID, totals, and status from
/// ``CommonCommercialTransactionObject``.
///
/// ## Overview
///
/// Each contract has a ``status``, an array of ``DolibarrContractLine`` services
/// with their own status lifecycle, and counters of services by state.
///
/// - Note: Requires the **Contrat** module to be activated in Dolibarr.
/// - Note: The API ignores ``lines`` when creating a contract. Lines are
/// created through `POST /contracts/{id}/lines`.
/// - SeeAlso: ``DolibarrContractLine``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrContract: CommonCommercialTransactionObject {

	// MARK: - Properties

	// Required

	/// Contract lines
	///
	/// Empty when the contract was fetched with `withLines=false`.
	public var lines: [DolibarrContractLine]

	// Optional

	/// Contract date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_contrat**
	public var dateContract: Int?

	/// Contract creation date (Unix timestamp)
	///
	/// Dolibarr fills this with the same value as ``dateContract``.
	///
	/// - Mapped Dolibarr property: **date_creation**
	public var dateCreation: Int?

	/// Contract validation date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_validation**
	public var dateValidation: Int?

	/// Contract customer reference
	///
	/// - Mapped Dolibarr property: **ref_customer**
	public var customerRef: String?

	/// Contract supplier reference
	///
	/// - Mapped Dolibarr property: **ref_supplier**
	public var supplierRef: String?

	/// Contract type code (0 for customer, 1 for supplier)
	///
	/// - Mapped Dolibarr property: **fk_contract_type**
	public var contractType: String?

	/// Contract signed status code
	///
	/// - Mapped Dolibarr property: **signed_status**
	public var signedStatus: String?

	/// Contract author user ID
	///
	/// - Mapped Dolibarr property: **user_author_id**
	public var userAuthorId: String?

	/// Sales representative user ID signing the contract
	///
	/// - Mapped Dolibarr property: **commercial_signature_id**
	public var salesSignatureUserId: String?

	/// Sales representative user ID following up the contract
	///
	/// - Mapped Dolibarr property: **commercial_suivi_id**
	public var salesFollowUpUserId: String?

	/// Contract PDF model name
	///
	/// - Mapped Dolibarr property: **model_pdf**
	public var pdfModel: String?

	/// Contract last generated main document path
	///
	/// - Mapped Dolibarr property: **last_main_doc**
	public var lastMainDoc: String?

	/// Number of services in the contract
	///
	/// - Mapped Dolibarr property: **nbofservices**
	public var serviceCount: Int?

	/// Number of services waiting to be activated
	///
	/// - Mapped Dolibarr property: **nbofserviceswait**
	public var servicesWaitingCount: Int?

	/// Number of open services
	///
	/// - Mapped Dolibarr property: **nbofservicesopened**
	public var servicesOpenCount: Int?

	/// Number of expired services
	///
	/// - Mapped Dolibarr property: **nbofservicesexpired**
	public var servicesExpiredCount: Int?

	/// Number of closed services
	///
	/// - Mapped Dolibarr property: **nbofservicesclosed**
	public var servicesClosedCount: Int?

	// Computed

	/// ID of the user who created the contract
	override public var createdByUserId: String? {
		super.createdByUserId ?? Self.userId(userAuthorId)
	}

	/// Associated contract status type
	override public var status: DolibarrObjectStatus {
		guard let status = DolibarrObjectStatus.contracts.first(where: { $0.code == statusCode }) else { return .unknown }
		return status
	}

	/// Contract date
	public var dateContracted: Date? {
		guard let dateContract else { return nil }
		return Date(timeIntervalSince1970: TimeInterval(dateContract))
	}

	/// Contract creation date
	override public var dateCreated: Date? {
		Self.date(from: dateCreation) ?? super.dateCreated
	}

	/// Contract validation date
	override public var dateValidated: Date? {
		Self.date(from: dateValidation) ?? super.dateValidated
	}

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case lines
		case dateContract = "date_contrat"
		case dateCreation = "date_creation"
		case dateValidation = "date_validation"
		case customerRef = "ref_customer"
		case supplierRef = "ref_supplier"
		case contractType = "fk_contract_type"
		case signedStatus = "signed_status"
		case userAuthorId = "user_author_id"
		case salesSignatureUserId = "commercial_signature_id"
		case salesFollowUpUserId = "commercial_suivi_id"
		case pdfModel = "model_pdf"
		case lastMainDoc = "last_main_doc"
		case serviceCount = "nbofservices"
		case servicesWaitingCount = "nbofserviceswait"
		case servicesOpenCount = "nbofservicesopened"
		case servicesExpiredCount = "nbofservicesexpired"
		case servicesClosedCount = "nbofservicesclosed"
	}

	// MARK: - Inits

	public init(
		lines: [DolibarrContractLine] = [],
		dateContract: Int? = nil,
		dateCreation: Int? = nil,
		dateValidation: Int? = nil,
		customerRef: String? = nil,
		supplierRef: String? = nil,
		contractType: String? = nil,
		signedStatus: String? = nil,
		userAuthorId: String? = nil,
		salesSignatureUserId: String? = nil,
		salesFollowUpUserId: String? = nil,
		pdfModel: String? = nil,
		lastMainDoc: String? = nil,
		serviceCount: Int? = nil,
		servicesWaitingCount: Int? = nil,
		servicesOpenCount: Int? = nil,
		servicesExpiredCount: Int? = nil,
		servicesClosedCount: Int? = nil,
		thirdPartyId: String = "",
		statusCode: String = "0",
		ref: String = "",
		totalExclTax: String = "0.00",
		totalTax: String = "0.00",
		totalInclTax: String = "0.00",
		multicurrencyCode: String? = nil,
		projectId: String? = nil,
		linkedObjectsIds: [String: [String: String]]? = nil,
		id: String = "",
		arrayOptions: [String: MultiType]? = nil,
		notePublic: String? = nil,
		notePrivate: String? = nil
	) {
		self.lines = lines
		self.dateContract = dateContract
		self.dateCreation = dateCreation
		self.dateValidation = dateValidation
		self.customerRef = customerRef
		self.supplierRef = supplierRef
		self.contractType = contractType
		self.signedStatus = signedStatus
		self.userAuthorId = userAuthorId
		self.salesSignatureUserId = salesSignatureUserId
		self.salesFollowUpUserId = salesFollowUpUserId
		self.pdfModel = pdfModel
		self.lastMainDoc = lastMainDoc
		self.serviceCount = serviceCount
		self.servicesWaitingCount = servicesWaitingCount
		self.servicesOpenCount = servicesOpenCount
		self.servicesExpiredCount = servicesExpiredCount
		self.servicesClosedCount = servicesClosedCount
		super.init(
			thirdPartyId: thirdPartyId,
			statusCode: statusCode,
			ref: ref,
			totalExclTax: totalExclTax,
			totalTax: totalTax,
			totalInclTax: totalInclTax,
			multicurrencyCode: multicurrencyCode,
			projectId: projectId,
			linkedObjectsIds: linkedObjectsIds,
			id: id,
			arrayOptions: arrayOptions,
			notePublic: notePublic,
			notePrivate: notePrivate
		)
	}

	public required init(from decoder: any Decoder) throws {
		do {
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logWithoutSignal("\(Self.self).init.decode", level: .info, category: .api)
			#endif
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.lines = try container.decodeIfPresent([DolibarrContractLine].self, forKey: .lines) ?? []
			self.dateContract = try container.decodeIfPresent(MultiType.self, forKey: .dateContract)?.intValue
			self.dateCreation = try container.decodeIfPresent(MultiType.self, forKey: .dateCreation)?.intValue
			self.dateValidation = try container.decodeIfPresent(MultiType.self, forKey: .dateValidation)?.intValue
			self.customerRef = try container.decodeIfPresent(String.self, forKey: .customerRef)
			self.supplierRef = try container.decodeIfPresent(String.self, forKey: .supplierRef)
			self.contractType = try container.decodeIfPresent(MultiType.self, forKey: .contractType)?.stringValue
			self.signedStatus = try container.decodeIfPresent(MultiType.self, forKey: .signedStatus)?.stringValue
			self.userAuthorId = try container.decodeIdIfPresent(forKey: .userAuthorId)
			self.salesSignatureUserId = try container.decodeIdIfPresent(forKey: .salesSignatureUserId)
			self.salesFollowUpUserId = try container.decodeIdIfPresent(forKey: .salesFollowUpUserId)
			self.pdfModel = try container.decodeIfPresent(String.self, forKey: .pdfModel)
			self.lastMainDoc = try container.decodeIfPresent(String.self, forKey: .lastMainDoc)
			self.serviceCount = try container.decodeIfPresent(MultiType.self, forKey: .serviceCount)?.intValue
			self.servicesWaitingCount = try container.decodeIfPresent(MultiType.self, forKey: .servicesWaitingCount)?.intValue
			self.servicesOpenCount = try container.decodeIfPresent(MultiType.self, forKey: .servicesOpenCount)?.intValue
			self.servicesExpiredCount = try container.decodeIfPresent(MultiType.self, forKey: .servicesExpiredCount)?.intValue
			self.servicesClosedCount = try container.decodeIfPresent(MultiType.self, forKey: .servicesClosedCount)?.intValue
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

	public init(copying source: DolibarrContract) {
		self.lines = source.lines
		self.dateContract = source.dateContract
		self.dateCreation = source.dateCreation
		self.dateValidation = source.dateValidation
		self.customerRef = source.customerRef
		self.supplierRef = source.supplierRef
		self.contractType = source.contractType
		self.signedStatus = source.signedStatus
		self.userAuthorId = source.userAuthorId
		self.salesSignatureUserId = source.salesSignatureUserId
		self.salesFollowUpUserId = source.salesFollowUpUserId
		self.pdfModel = source.pdfModel
		self.lastMainDoc = source.lastMainDoc
		self.serviceCount = source.serviceCount
		self.servicesWaitingCount = source.servicesWaitingCount
		self.servicesOpenCount = source.servicesOpenCount
		self.servicesExpiredCount = source.servicesExpiredCount
		self.servicesClosedCount = source.servicesClosedCount
		super.init(copying: source)
	}

	// MARK: - Methods

	public func copy(_ source: DolibarrContract) {
		self.lines = source.lines
		self.dateContract = source.dateContract
		self.dateCreation = source.dateCreation
		self.dateValidation = source.dateValidation
		self.customerRef = source.customerRef
		self.supplierRef = source.supplierRef
		self.contractType = source.contractType
		self.signedStatus = source.signedStatus
		self.userAuthorId = source.userAuthorId
		self.salesSignatureUserId = source.salesSignatureUserId
		self.salesFollowUpUserId = source.salesFollowUpUserId
		self.pdfModel = source.pdfModel
		self.lastMainDoc = source.lastMainDoc
		self.serviceCount = source.serviceCount
		self.servicesWaitingCount = source.servicesWaitingCount
		self.servicesOpenCount = source.servicesOpenCount
		self.servicesExpiredCount = source.servicesExpiredCount
		self.servicesClosedCount = source.servicesClosedCount
		super.copy(source)
	}

	// MARK: - Protocol methods

	override public func hash(into hasher: inout Hasher) {
		hasher.combine(lines)
		hasher.combine(optional: dateContract)
		hasher.combine(optional: dateCreation)
		hasher.combine(optional: dateValidation)
		hasher.combine(optional: customerRef)
		hasher.combine(optional: supplierRef)
		hasher.combine(optional: contractType)
		hasher.combine(optional: signedStatus)
		hasher.combine(optional: userAuthorId)
		hasher.combine(optional: salesSignatureUserId)
		hasher.combine(optional: salesFollowUpUserId)
		hasher.combine(optional: pdfModel)
		hasher.combine(optional: lastMainDoc)
		hasher.combine(optional: serviceCount)
		hasher.combine(optional: servicesWaitingCount)
		hasher.combine(optional: servicesOpenCount)
		hasher.combine(optional: servicesExpiredCount)
		hasher.combine(optional: servicesClosedCount)
		super.hash(into: &hasher)
	}

	override public func isEqual(to other: CommonBusinessObject) -> Bool {
		guard let other = other as? DolibarrContract else { return false }
		return lines == other.lines
		&& dateContract == other.dateContract
		&& dateCreation == other.dateCreation
		&& dateValidation == other.dateValidation
		&& customerRef == other.customerRef
		&& supplierRef == other.supplierRef
		&& contractType == other.contractType
		&& signedStatus == other.signedStatus
		&& userAuthorId == other.userAuthorId
		&& salesSignatureUserId == other.salesSignatureUserId
		&& salesFollowUpUserId == other.salesFollowUpUserId
		&& pdfModel == other.pdfModel
		&& lastMainDoc == other.lastMainDoc
		&& serviceCount == other.serviceCount
		&& servicesWaitingCount == other.servicesWaitingCount
		&& servicesOpenCount == other.servicesOpenCount
		&& servicesExpiredCount == other.servicesExpiredCount
		&& servicesClosedCount == other.servicesClosedCount
		&& super.isEqual(to: other)
	}

	override public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(lines, forKey: .lines)
		try container.encodeIfPresentAndNotZero(dateContract, forKey: .dateContract)
		try container.encodeIfPresentAndNotZero(dateCreation, forKey: .dateCreation)
		try container.encodeIfPresentAndNotZero(dateValidation, forKey: .dateValidation)
		try container.encodeIfPresent(customerRef, forKey: .customerRef)
		try container.encodeIfPresent(supplierRef, forKey: .supplierRef)
		try container.encodeIfPresentAndNotEmpty(contractType, forKey: .contractType)
		try container.encodeIfPresentAndNotEmpty(signedStatus, forKey: .signedStatus)
		try container.encodeIfPresentAndNotEmpty(userAuthorId, forKey: .userAuthorId)
		try container.encodeIfPresentAndNotEmpty(salesSignatureUserId, forKey: .salesSignatureUserId)
		try container.encodeIfPresentAndNotEmpty(salesFollowUpUserId, forKey: .salesFollowUpUserId)
		try container.encodeIfPresent(pdfModel, forKey: .pdfModel)
		try container.encodeIfPresent(lastMainDoc, forKey: .lastMainDoc)
		try container.encodeIfPresent(serviceCount, forKey: .serviceCount)
		try container.encodeIfPresent(servicesWaitingCount, forKey: .servicesWaitingCount)
		try container.encodeIfPresent(servicesOpenCount, forKey: .servicesOpenCount)
		try container.encodeIfPresent(servicesExpiredCount, forKey: .servicesExpiredCount)
		try container.encodeIfPresent(servicesClosedCount, forKey: .servicesClosedCount)
		try super.encode(to: encoder)
	}

}
