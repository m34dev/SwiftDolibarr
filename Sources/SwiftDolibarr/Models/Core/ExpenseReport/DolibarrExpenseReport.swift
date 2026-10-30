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
//  DolibarrExpenseReport.swift
//  SwiftDolibarr
//
//  Created by William Mead on 27/05/2025.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A Dolibarr expense report object.
///
/// Maps to the Dolibarr `/expensereports` REST API endpoint. Tracks employee
/// expenses through a validation and approval workflow.
///
/// ## Overview
///
/// Each expense report has a ``status``, an array of ``DolibarrExpenseReportLine`` items,
/// date range, totals, and references to author, validator, and approver users.
///
/// - Note: Requires the **Expensereport** module to be activated in Dolibarr.
/// - SeeAlso: ``DolibarrExpenseReportLine``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrExpenseReport: CommonBusinessObject {

    // MARK: - Properties

	// Required

	/// Expense report lines
	public var lines: [DolibarrExpenseReportLine]

	// Optional

	/// Expense report reference
	public var ref: String

	/// Expense report start date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_debut**
	public var dateStart: Int

	/// Expense report end date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_fin**
	public var dateEnd: Int

	/// Expense report creation date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_create**
	public var dateCreate: Int?

	/// Expense report modification date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_modif**
	public var dateModify: Int?

	/// Expense report validation date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_valid**
	public var dateValidate: Int?

	/// Expense report approval date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_approve**
	public var dateApprove: Int?

	/// Expense report refusal date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_refuse**
	public var dateRefuse: Int?

	/// Expense report cancellation date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_cancel**
	public var dateCancel: Int?

	/// Expense report creator user ID
	///
	/// - Mapped Dolibarr property: **fk_user_creat**
	public var userCreateId: String?

	/// Expense report last modifier user ID
	///
	/// - Mapped Dolibarr property: **fk_user_modif**
	public var userModifyId: String?

	/// Expense report beneficiary user ID (the person who incurred the expenses)
	///
	/// - Mapped Dolibarr property: **fk_user_author**
	public var userBeneficiaryId: String

	/// Expense report validator user ID
	///
	/// - Mapped Dolibarr property: **fk_user_validator**
	public var userValidatorId: String?

	/// Expense report approver user ID
	///
	/// - Mapped Dolibarr property: **fk_user_approve**
	public var userApprovedById: String?

	/// Expense report canceler user ID
	///
	/// - Mapped Dolibarr property: **fk_user_cancel**
	public var userCanceledById: String?

	/// Expense report refuser user ID
	///
	/// - Mapped Dolibarr property: **fk_user_refuse**
	public var userRefusedById: String?

	/// Expense report cancellation detail
	///
	/// - Mapped Dolibarr property: **detail_cancel**
	public var detailCanceled: String?

	/// Expense report refusal detail
	///
	/// - Mapped Dolibarr property: **detail_refuse**
	public var detailRefused: String?

	/// Expense report paid status
	public var paid: String

	/// Expense report total amount excluding tax
	///
	/// - Mapped Dolibarr property: **total_ht**
	public var totalExclTax: String

	/// Expense report total tax amount
	///
	/// - Mapped Dolibarr property: **total_tva**
	public var totalTax: String

	/// Expense report total amount including tax
	///
	/// - Mapped Dolibarr property: **total_ttc**
	public var totalInclTax: String

	// Computed

	/// Expense report start date
	public var dateStarted: Date {
		Date(timeIntervalSince1970: TimeInterval(dateStart))
	}

	/// Expense report end date
	public var dateEnded: Date {
		Date(timeIntervalSince1970: TimeInterval(dateEnd))
	}

	/// Expense report creation date
	public var dateCreated: Date? {
		guard let dateCreate else { return nil }
		return Date(timeIntervalSince1970: TimeInterval(dateCreate))
	}

	/// Expense report modification date
	public var dateModified: Date? {
		guard let dateModify else { return nil }
		return Date(timeIntervalSince1970: TimeInterval(dateModify))
	}

	/// Expense report validation date
	public var dateValidated: Date? {
		guard let dateValidate else { return nil }
		return Date(timeIntervalSince1970: TimeInterval(dateValidate))
	}

	/// Expense report approval date
	public var dateApproved: Date? {
		guard let dateApprove else { return nil }
		return Date(timeIntervalSince1970: TimeInterval(dateApprove))
	}

	/// Expense report refusal date
	public var dateRefused: Date? {
		guard let dateRefuse else { return nil }
		return Date(timeIntervalSince1970: TimeInterval(dateRefuse))
	}

	/// Expense report cancellation date
	public var dateCanceled: Date? {
		guard let dateCancel else { return nil }
		return Date(timeIntervalSince1970: TimeInterval(dateCancel))
	}

	/// Associated expense report status type
	override public var status: DolibarrObjectStatus {
		guard let status = DolibarrObjectStatus.expenseReports.first(where: { $0.code == statusCode }) else {
			return .unknown
		}
		return status
	}

    // MARK: - Enums

    enum CodingKeys: String, CodingKey {
        case ref
        case dateStart = "date_debut"
        case dateEnd = "date_fin"
        case dateCreate = "date_create"
        case dateModify = "date_modif"
        case dateValidate = "date_valid"
        case dateApprove = "date_approve"
        case dateRefuse = "date_refuse"
        case dateCancel = "date_cancel"
        case userCreateId = "fk_user_creat"
        case userModifyId = "fk_user_modif"
        case userBeneficiaryId = "fk_user_author"
        case userValidatorId = "fk_user_validator"
        case userApprovedById = "fk_user_approve"
        case userCanceledById = "fk_user_cancel"
        case userRefusedById = "fk_user_refuse"
        case detailCanceled = "detail_cancel"
        case detailRefused = "detail_refuse"
        case paid
        case totalExclTax = "total_ht"
        case totalTax = "total_tva"
        case totalInclTax = "total_ttc"
        case lines
    }

    // MARK: - Inits

	public init(
        ref: String = "",
        dateStart: Int = 0,
        dateEnd: Int = 0,
        dateCreate: Int? = nil,
        dateModify: Int? = nil,
        dateValidate: Int? = nil,
        dateApprove: Int? = nil,
        dateRefuse: Int? = nil,
        dateCancel: Int? = nil,
        userCreateId: String? = nil,
        userModifyId: String? = nil,
        userBeneficiaryId: String = "",
        userValidatorId: String? = nil,
        userApprovedById: String? = nil,
        userCanceledById: String? = nil,
        userRefusedById: String? = nil,
        detailCanceled: String? = nil,
        detailRefused: String? = nil,
        paid: String = "",
        totalExclTax: String = "",
        totalTax: String = "",
        totalInclTax: String = "",
        lines: [DolibarrExpenseReportLine] = [],
        id: String = "",
        statusCode: String = "",
        arrayOptions: [String: MultiType]? = nil,
        notePublic: String? = nil,
        notePrivate: String? = nil
    ) {
        self.ref = ref
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.dateCreate = dateCreate
        self.dateModify = dateModify
        self.dateValidate = dateValidate
        self.dateApprove = dateApprove
        self.dateRefuse = dateRefuse
        self.dateCancel = dateCancel
        self.userCreateId = userCreateId
        self.userModifyId = userModifyId
        self.userBeneficiaryId = userBeneficiaryId
        self.userValidatorId = userValidatorId
        self.userApprovedById = userApprovedById
        self.userCanceledById = userCanceledById
        self.userRefusedById = userRefusedById
        self.detailCanceled = detailCanceled
        self.detailRefused = detailRefused
        self.paid = paid
        self.totalExclTax = totalExclTax
        self.totalTax = totalTax
        self.totalInclTax = totalInclTax
        self.lines = lines
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
            Logger.logWithoutSignal("\(Self.self).init.decode", level: .info, category: .api)
            #endif
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.ref = try container.decode(String.self, forKey: .ref)
            self.dateStart = try container.decode(Int.self, forKey: .dateStart)
            self.dateEnd = try container.decode(Int.self, forKey: .dateEnd)
            self.dateCreate = try container.decode(MultiType.self, forKey: .dateCreate).intValue
            self.dateModify = try container.decode(MultiType.self, forKey: .dateModify).intValue
            self.dateValidate = try container.decode(MultiType.self, forKey: .dateValidate).intValue
            self.dateApprove = try container.decode(MultiType.self, forKey: .dateApprove).intValue
            self.dateRefuse = try container.decode(MultiType.self, forKey: .dateRefuse).intValue
            self.dateCancel = try container.decode(MultiType.self, forKey: .dateCancel).intValue
            self.userCreateId = try container.decodeIfPresent(String.self, forKey: .userCreateId)
            self.userModifyId = try container.decodeIfPresent(String.self, forKey: .userModifyId)
            self.userBeneficiaryId = try container.decode(String.self, forKey: .userBeneficiaryId)
            self.userValidatorId = try container.decodeIfPresent(String.self, forKey: .userValidatorId)
            self.userApprovedById = try container.decodeIfPresent(String.self, forKey: .userApprovedById)
            self.userCanceledById = try container.decodeIfPresent(String.self, forKey: .userCanceledById)
            self.userRefusedById = try container.decodeIfPresent(String.self, forKey: .userRefusedById)
            self.detailCanceled = try container.decodeIfPresent(String.self, forKey: .detailCanceled)
            self.detailRefused = try container.decodeIfPresent(String.self, forKey: .detailRefused)
            self.paid = try container.decode(String.self, forKey: .paid)
            self.totalExclTax = try container.decode(String.self, forKey: .totalExclTax)
            self.totalTax = try container.decode(String.self, forKey: .totalTax)
            self.totalInclTax = try container.decode(String.self, forKey: .totalInclTax)
            self.lines = try container.decode([DolibarrExpenseReportLine].self, forKey: .lines)
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
    
    public init(copying source: DolibarrExpenseReport) {
        self.ref = source.ref
        self.dateStart = source.dateStart
        self.dateEnd = source.dateEnd
        self.dateCreate = source.dateCreate
        self.dateModify = source.dateModify
        self.dateValidate = source.dateValidate
        self.dateApprove = source.dateApprove
        self.dateRefuse = source.dateRefuse
        self.dateCancel = source.dateCancel
        self.userCreateId = source.userCreateId
        self.userModifyId = source.userModifyId
        self.userBeneficiaryId = source.userBeneficiaryId
        self.userValidatorId = source.userValidatorId
        self.userCanceledById = source.userCanceledById
        self.detailCanceled = source.detailCanceled
        self.detailRefused = source.detailRefused
        self.paid = source.paid
        self.totalExclTax = source.totalExclTax
        self.totalTax = source.totalTax
        self.totalInclTax = source.totalInclTax
        self.lines = source.lines
        super.init(copying: source)
    }
    
    // MARK: - Methods
    
    public func copy(_ source: DolibarrExpenseReport) {
        self.ref = source.ref
        self.dateStart = source.dateStart
        self.dateEnd = source.dateEnd
        self.dateCreate = source.dateCreate
        self.dateModify = source.dateModify
        self.dateValidate = source.dateValidate
        self.dateApprove = source.dateApprove
        self.dateRefuse = source.dateRefuse
        self.dateCancel = source.dateCancel
        self.userCreateId = source.userCreateId
        self.userModifyId = source.userModifyId
        self.userBeneficiaryId = source.userBeneficiaryId
        self.userValidatorId = source.userValidatorId
        self.userCanceledById = source.userCanceledById
        self.detailCanceled = source.detailCanceled
        self.detailRefused = source.detailRefused
        self.paid = source.paid
        self.totalExclTax = source.totalExclTax
        self.totalTax = source.totalTax
        self.totalInclTax = source.totalInclTax
        self.lines = source.lines
        super.copy(source)
    }

    // MARK: - Protocol methods

    override public func hash(into hasher: inout Hasher) {
        hasher.combine(ref)
		hasher.combine(dateStart)
		hasher.combine(dateEnd)
		hasher.combine(optional: dateCreate)
		hasher.combine(optional: dateModify)
		hasher.combine(optional: dateValidate)
		hasher.combine(optional: dateApprove)
		hasher.combine(optional: dateRefuse)
		hasher.combine(optional: dateCancel)
		hasher.combine(optional: userCreateId)
		hasher.combine(optional: userModifyId)
		hasher.combine(userBeneficiaryId)
		hasher.combine(optional: userValidatorId)
		hasher.combine(optional: userApprovedById)
		hasher.combine(optional: userCanceledById)
		hasher.combine(optional: userRefusedById)
		hasher.combine(optional: detailRefused)
		hasher.combine(optional: detailCanceled)
		hasher.combine(paid)
		hasher.combine(totalExclTax)
		hasher.combine(totalTax)
		hasher.combine(totalInclTax)
		hasher.combine(lines)
		super.hash(into: &hasher)
    }

    override public func isEqual(to other: CommonBusinessObject) -> Bool {
		guard let other = other as? DolibarrExpenseReport else { return false }
		return ref == other.ref
		&& dateStart == other.dateStart
		&& dateEnd == other.dateEnd
		&& dateCreate == other.dateCreate
		&& dateModify == other.dateModify
		&& dateValidate == other.dateValidate
		&& dateApprove == other.dateApprove
		&& dateRefuse == other.dateRefuse
		&& dateCancel == other.dateCancel
		&& userCreateId == other.userCreateId
		&& userModifyId == other.userModifyId
		&& userBeneficiaryId == other.userBeneficiaryId
		&& userValidatorId == other.userValidatorId
		&& userApprovedById == other.userApprovedById
		&& userCanceledById == other.userCanceledById
		&& userRefusedById == other.userRefusedById
		&& detailRefused == other.detailRefused
		&& detailCanceled == other.detailCanceled
		&& paid == other.paid
		&& totalExclTax == other.totalExclTax
		&& totalTax == other.totalTax
		&& totalInclTax == other.totalInclTax
		&& lines == other.lines
		&& super.isEqual(to: other)
    }

    override public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfNotEmpty(ref, forKey: .ref)
		try container.encodeIfNotZero(dateStart, forKey: .dateStart)
		try container.encodeIfNotZero(dateEnd, forKey: .dateEnd)
		try container.encodeIfPresentAndNotZero(dateCreate, forKey: .dateCreate)
		try container.encodeIfPresentAndNotZero(dateModify, forKey: .dateModify)
		try container.encodeIfPresentAndNotZero(dateValidate, forKey: .dateValidate)
		try container.encodeIfPresentAndNotZero(dateApprove, forKey: .dateApprove)
		try container.encodeIfPresentAndNotZero(dateRefuse, forKey: .dateRefuse)
		try container.encodeIfPresentAndNotZero(dateCancel, forKey: .dateCancel)
		try container.encodeIfPresentAndNotEmpty(userCreateId, forKey: .userCreateId)
		try container.encodeIfPresentAndNotEmpty(userModifyId, forKey: .userModifyId)
		try container.encodeIfNotEmpty(userBeneficiaryId, forKey: .userBeneficiaryId)
		try container.encodeIfPresentAndNotEmpty(userValidatorId, forKey: .userValidatorId)
		try container.encodeIfPresentAndNotEmpty(userApprovedById, forKey: .userApprovedById)
		try container.encodeIfPresentAndNotEmpty(userCanceledById, forKey: .userCanceledById)
		try container.encodeIfPresentAndNotEmpty(userRefusedById, forKey: .userRefusedById)
		try container.encodeIfPresentAndNotEmpty(detailCanceled, forKey: .detailCanceled)
		try container.encodeIfPresentAndNotEmpty(detailRefused, forKey: .detailRefused)
		try container.encodeIfNotEmpty(paid, forKey: .paid)
		try container.encodeIfNotEmpty(totalExclTax, forKey: .totalExclTax)
		try container.encodeIfNotEmpty(totalTax, forKey: .totalTax)
		try container.encodeIfNotEmpty(totalInclTax, forKey: .totalInclTax)
		try super.encode(to: encoder)
    }

}
