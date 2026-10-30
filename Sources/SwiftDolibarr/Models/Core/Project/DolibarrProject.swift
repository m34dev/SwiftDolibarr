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
//  DolibarrProject.swift
//  SwiftDolibarr
//
//  Created by William Mead on 18/02/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A Dolibarr project object.
///
/// Maps to the Dolibarr `/projects` REST API endpoint. A project groups
/// related tasks and can have start/end dates.
///
/// - Note: Requires the **Projet** module to be activated in Dolibarr.
/// - SeeAlso: ``DolibarrTask``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrProject: CommonBusinessObject {

	// MARK: - Properties

	// Required

	/// Project reference
	///
	/// - Mapped Dolibarr property: **ref**
	public var reference: String

	/// Project title
	public var title: String

    /// Project used to track a lead
    ///
    /// - Mapped Dolibarr property: **usage_opportunity**
    public var usageLead: Int

    /// Project used to track tasks
    ///
    /// - Mapped Dolibarr property: **usage_task**
    public var usageTask: Int

    /// Project used to bill time
    ///
    /// - Mapped Dolibarr property: **usage_bill_time**
    public var usageBillTime: Int

    /// Project used for event organization
    ///
    /// - Mapped Dolibarr property: **usage_organize_event**
    public var usageOrganizeEvent: Int

	// Optional

    /// Associated third party ID
    ///
    /// - Mapped Dolibarr property: **socid**
    public var thirdPartyId: String?

	/// Project opportunity amount
	///
	/// - Mapped Dolibarr property: **opp_amount**
	public var leadAmount: String?

	/// Project opportunity status
	///
	/// - Mapped Dolibarr property: **opp_status**
	public var leadStatus: String?

	/// Project opportunity progress percentage
	///
	/// - Mapped Dolibarr property: **opp_percent**
	public var leadProgress: String?

	/// Project budget amount
	///
	/// - Mapped Dolibarr property: **budget_amount**
	public var budgetAmount: String?

	/// Project start date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_start**
	public var dateStart: Int?

	/// Project end date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date_end**
	public var dateEnd: Int?

	/// Project event start date (Unix timestamp as string)
	///
	/// - Mapped Dolibarr property: **date_start_event**
	public var dateStartEvent: Int?

	/// Project event end date (Unix timestamp as string)
	///
	/// - Mapped Dolibarr property: **date_end_event**
	public var dateEndEvent: Int?

	/// Project location
	public var location: String?

	/// Project description
	public var description: String?

	// Computed

	/// Associated project status type
	override public var status: DolibarrObjectStatus {
		guard let status = DolibarrObjectStatus.projects.first(where: { $0.code == statusCode }) else { return .unknown }
		return status
	}

	enum CodingKeys: String, CodingKey {
		case reference = "ref"
		case title
        case usageLead = "usage_opportunity"
        case usageTask = "usage_task"
        case usageBillTime = "usage_bill_time"
        case usageOrganizeEvent = "usage_organize_event"
        case thirdPartyId = "socid"
		case leadAmount = "opp_amount"
		case leadStatus = "opp_status"
		case leadProgress = "opp_percent"
		case budgetAmount = "budget_amount"
		case dateStart = "date_start"
		case dateEnd = "date_end"
		case dateStartEvent = "date_start_event"
		case dateEndEvent = "date_end_event"
		case location
		case description
	}

	// MARK: - Inits

	public init(
		reference: String = "",
		title: String = "",
        usageLead: Int = 0,
        usageTask: Int = 0,
        usageBillTime: Int = 0,
        usageOrganizeEvent: Int = 0,
        thirdPartyId: String? = nil,
        leadAmount: String? = nil,
		leadStatus: String? = nil,
		leadProgress: String? = nil,
		budgetAmount: String? = nil,
		dateStart: Int? = nil,
		dateEnd: Int? = nil,
		dateStartEvent: Int? = nil,
		dateEndEvent: Int? = nil,
		location: String? = nil,
		description: String? = nil,
		id: String = "",
		statusCode: String = "",
		entityId: String? = nil,
		arrayOptions: [String: MultiType]? = nil,
		notePublic: String? = nil,
		notePrivate: String? = nil
	) {
		self.reference = reference
		self.title = title
        self.usageLead = usageLead
        self.usageTask = usageTask
        self.usageBillTime = usageBillTime
        self.usageOrganizeEvent = usageOrganizeEvent
        self.thirdPartyId = thirdPartyId
		self.leadAmount = leadAmount
		self.leadStatus = leadStatus
		self.leadProgress = leadProgress
		self.budgetAmount = budgetAmount
		self.dateStart = dateStart
		self.dateEnd = dateEnd
		self.dateStartEvent = dateStartEvent
		self.dateEndEvent = dateEndEvent
		self.location = location
		self.description = description
		super.init(
			id: id,
			statusCode: statusCode,
			entityId: entityId,
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
			self.reference = try container.decode(String.self, forKey: .reference)
			self.title = try container.decode(String.self, forKey: .title)
            self.usageLead = try container.decode(Int.self, forKey: .usageLead)
            self.usageTask = try container.decode(Int.self, forKey: .usageTask)
            self.usageBillTime = try container.decode(Int.self, forKey: .usageBillTime)
            self.usageOrganizeEvent = try container.decode(Int.self, forKey: .usageOrganizeEvent)
            self.thirdPartyId = try container.decodeIfPresent(String.self, forKey: .thirdPartyId)
			self.leadAmount = try container.decodeIfPresent(String.self, forKey: .leadAmount)
			self.leadStatus = try container.decodeIfPresent(String.self, forKey: .leadStatus)
			self.leadProgress = try container.decodeIfPresent(String.self, forKey: .leadProgress)
			self.budgetAmount = try container.decodeIfPresent(String.self, forKey: .budgetAmount)
			self.dateStart = try container.decodeIfPresent(MultiType.self, forKey: .dateStart)?.intValue
			self.dateEnd = try container.decodeIfPresent(MultiType.self, forKey: .dateEnd)?.intValue
			self.dateStartEvent = try container.decodeIfPresent(MultiType.self, forKey: .dateStartEvent)?.intValue
			self.dateEndEvent = try container.decodeIfPresent(MultiType.self, forKey: .dateEndEvent)?.intValue
			self.location = try container.decodeIfPresent(String.self, forKey: .location)
			self.description = try container.decodeIfPresent(String.self, forKey: .description)
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
    
    public init(copying source: DolibarrProject) {
        self.reference = source.reference
        self.title = source.title
        self.usageLead = source.usageLead
        self.usageTask = source.usageTask
        self.usageBillTime = source.usageBillTime
        self.usageOrganizeEvent = source.usageOrganizeEvent
        self.thirdPartyId = source.thirdPartyId
        self.leadAmount = source.leadAmount
        self.leadStatus = source.leadStatus
        self.leadProgress = source.leadProgress
        self.budgetAmount = source.budgetAmount
        self.dateStart = source.dateStart
        self.dateEnd = source.dateEnd
        self.dateStartEvent = source.dateStartEvent
        self.dateEndEvent = source.dateEndEvent
        self.location = source.location
        self.description = source.description
        super.init(copying: source)
    }
    
    // MARK: - Methods
    
    public func copy(_ source: DolibarrProject) {
        self.reference = source.reference
        self.title = source.title
        self.usageLead = source.usageLead
        self.usageTask = source.usageTask
        self.usageBillTime = source.usageBillTime
        self.usageOrganizeEvent = source.usageOrganizeEvent
        self.thirdPartyId = source.thirdPartyId
        self.leadAmount = source.leadAmount
        self.leadStatus = source.leadStatus
        self.leadProgress = source.leadProgress
        self.budgetAmount = source.budgetAmount
        self.dateStart = source.dateStart
        self.dateEnd = source.dateEnd
        self.dateStartEvent = source.dateStartEvent
        self.dateEndEvent = source.dateEndEvent
        self.location = source.location
        self.description = source.description
        super.copy(source)
    }

	// MARK: - Protocol methods

	override public func hash(into hasher: inout Hasher) {
		hasher.combine(reference)
		hasher.combine(title)
        hasher.combine(usageLead)
        hasher.combine(usageTask)
        hasher.combine(usageBillTime)
        hasher.combine(usageOrganizeEvent)
        hasher.combine(optional: thirdPartyId)
		hasher.combine(optional: leadAmount)
		hasher.combine(optional: leadStatus)
		hasher.combine(optional: leadProgress)
		hasher.combine(optional: budgetAmount)
		hasher.combine(optional: dateStart)
		hasher.combine(optional: dateEnd)
		hasher.combine(optional: dateStartEvent)
		hasher.combine(optional: dateEndEvent)
		hasher.combine(optional: location)
		hasher.combine(optional: description)
		super.hash(into: &hasher)
	}

	override public func isEqual(to other: CommonBusinessObject) -> Bool {
		guard let other = other as? DolibarrProject else { return false }
		return reference == other.reference
		&& title == other.title
		&& usageLead == other.usageLead
		&& usageTask == other.usageTask
		&& usageBillTime == other.usageBillTime
		&& usageOrganizeEvent == other.usageOrganizeEvent
		&& thirdPartyId == other.thirdPartyId
		&& leadAmount == other.leadAmount
		&& leadStatus == other.leadStatus
		&& leadProgress == other.leadProgress
		&& budgetAmount == other.budgetAmount
		&& dateStart == other.dateStart
		&& dateEnd == other.dateEnd
		&& dateStartEvent == other.dateStartEvent
		&& dateEndEvent == other.dateEndEvent
		&& location == other.location
		&& description == other.description
		&& super.isEqual(to: other)
	}

	override public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfNotEmpty(reference, forKey: .reference)
		try container.encodeIfNotEmpty(title, forKey: .title)
        try container.encode(usageTask, forKey: .usageTask)
        try container.encode(usageLead, forKey: .usageLead)
        try container.encode(usageBillTime, forKey: .usageBillTime)
        try container.encode(usageOrganizeEvent, forKey: .usageOrganizeEvent)
        try container.encodeIfPresent(thirdPartyId, forKey: .thirdPartyId)
		try container.encodeIfPresent(leadAmount, forKey: .leadAmount)
		try container.encodeIfPresent(leadStatus, forKey: .leadStatus)
		try container.encodeIfPresent(leadProgress, forKey: .leadProgress)
		try container.encodeIfPresent(budgetAmount, forKey: .budgetAmount)
		try container.encodeIfPresentAndNotZero(dateStart, forKey: .dateStart)
		try container.encodeIfPresentAndNotZero(dateEnd, forKey: .dateEnd)
		try container.encodeIfPresentAndNotZero(dateStartEvent, forKey: .dateStartEvent)
		try container.encodeIfPresentAndNotZero(dateEndEvent, forKey: .dateEndEvent)
		try container.encodeIfPresent(location, forKey: .location)
		try container.encodeIfPresent(description, forKey: .description)
		try super.encode(to: encoder)
	}

}
