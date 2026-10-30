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
//  DolibarrTask.swift
//  SwiftDolibarr
//
//  Created by William Mead on 20/02/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A Dolibarr task object.
///
/// Maps to the Dolibarr `/tasks` REST API endpoint. Each task belongs to
/// a ``DolibarrProject`` via ``projectId`` and can optionally have a parent
/// task via ``parentId``.
///
/// - Note: Requires the **Projet** module to be activated in Dolibarr.
/// - SeeAlso: ``DolibarrProject``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrTask: CommonBusinessObject {

	// MARK: - Properties

	// Required

	/// Task reference
	public var ref: String

	/// Task label
	public var label: String

	/// Associated project ID
	///
	/// - Mapped Dolibarr property: **fk_project**
	public var projectId: String

	/// Parent task ID
	///
	/// - Mapped Dolibarr property: **fk_task_parent**
	public var parentId: String

    // Optional

    /// Task is billable to client
    public var billable: String?

    /// Task start date (Unix timestamp as string)
    ///
    /// - Mapped Dolibarr property: **date_start**
    public var dateStart: Int?

    /// Task end date (Unix timestamp as string)
    ///
    /// - Mapped Dolibarr property: **date_end**
    public var dateEnd: Int?

    /// Task planned workload in seconds
    ///
    /// - Mapped Dolibarr property: **planned_workload**
    public var plannedWorkload: String?

    /// Task progress in percent
    public var progress: String?

    /// Task description
    public var description: String?

    /// Task budget
    ///
    /// - Mapped Dolibarr property: **budget_amount**
    public var budgetAmount: String?

    /// Task total time spent in seconds
    ///
    /// - Mapped Dolibarr property: **duration_effective**
    public var totalTimeSpentSeconds: String?

    // Computed

    /// Associated task status type
    override public var status: DolibarrObjectStatus {
        guard let status = DolibarrObjectStatus.tasks.first(where: { $0.code == statusCode }) else { return .unknown }
        return status
    }

    /// Task start date
    public var dateStarted: Date? {
        guard let dateStart else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(dateStart))
    }

    /// Task end date
    public var dateEnded: Date? {
        guard let dateEnd else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(dateEnd))
    }

    /// Task total time spent as a `Duration`
    public var totalTimeSpent: Duration? {
        guard let totalTimeSpentSeconds, let seconds = Double(totalTimeSpentSeconds) else { return nil }
        return .seconds(seconds)
    }

    /// Task budget as a `Double`
    public var budget: Double? {
        guard let budgetAmount else { return nil }
        return Double(budgetAmount)
    }

    // MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case ref
		case label
		case projectId = "fk_project"
		case parentId = "fk_task_parent"
		case billable
		case dateStart = "date_start"
		case dateEnd = "date_end"
		case plannedWorkload = "planned_workload"
		case progress
		case description
		case budgetAmount = "budget_amount"
		case totalTimeSpentSeconds = "duration_effective"
	}

	// MARK: - Inits

	public init(
		ref: String = "",
		label: String = "",
		projectId: String = "",
		parentId: String = "",
		billable: String? = nil,
		dateStart: Int? = nil,
		dateEnd: Int? = nil,
		plannedWorkload: String? = nil,
		progress: String? = nil,
		description: String? = nil,
		budgetAmount: String? = nil,
		totalTimeSpentSeconds: String? = nil,
		id: String = "",
		statusCode: String = "",
		entityId: String? = nil,
		arrayOptions: [String: MultiType]? = nil,
		notePublic: String? = nil,
		notePrivate: String? = nil
	) {
		self.ref = ref
		self.label = label
		self.projectId = projectId
		self.parentId = parentId
		self.billable = billable
		self.dateStart = dateStart
		self.dateEnd = dateEnd
		self.plannedWorkload = plannedWorkload
		self.progress = progress
		self.description = description
		self.budgetAmount = budgetAmount
		self.totalTimeSpentSeconds = totalTimeSpentSeconds
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
			self.ref = try container.decode(String.self, forKey: .ref)
			self.label = try container.decode(String.self, forKey: .label)
			self.projectId = try container.decode(String.self, forKey: .projectId)
			self.parentId = try container.decode(String.self, forKey: .parentId)
			self.billable = try container.decodeIfPresent(String.self, forKey: .billable)
            self.dateStart = try container.decodeIfPresent(MultiType.self, forKey: .dateStart)?.intValue
            self.dateEnd = try container.decodeIfPresent(MultiType.self, forKey: .dateEnd)?.intValue
			self.plannedWorkload = try container.decodeIfPresent(String.self, forKey: .plannedWorkload)
			self.progress = try container.decodeIfPresent(String.self, forKey: .progress)
			self.description = try container.decodeIfPresent(String.self, forKey: .description)
			self.budgetAmount = try container.decodeIfPresent(String.self, forKey: .budgetAmount)
			self.totalTimeSpentSeconds = try container.decodeIfPresent(String.self, forKey: .totalTimeSpentSeconds)
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
    
    public init(copying source: DolibarrTask) {
        self.ref = source.ref
        self.label = source.label
        self.projectId = source.projectId
        self.parentId = source.parentId
        self.billable = source.billable
        self.dateStart = source.dateStart
        self.dateEnd = source.dateEnd
        self.plannedWorkload = source.plannedWorkload
        self.progress = source.progress
        self.description = source.description
        self.budgetAmount = source.budgetAmount
        self.totalTimeSpentSeconds = source.totalTimeSpentSeconds
        super.init(copying: source)
    }
    
    // MARK: - Methods
    
    public func copy(_ source: DolibarrTask) {
        self.ref = source.ref
        self.label = source.label
        self.projectId = source.projectId
        self.parentId = source.parentId
        self.billable = source.billable
        self.dateStart = source.dateStart
        self.dateEnd = source.dateEnd
        self.plannedWorkload = source.plannedWorkload
        self.progress = source.progress
        self.description = source.description
        self.budgetAmount = source.budgetAmount
        self.totalTimeSpentSeconds = source.totalTimeSpentSeconds
        super.copy(source)
    }

	// MARK: - Protocol methods

	override public func hash(into hasher: inout Hasher) {
		hasher.combine(ref)
		hasher.combine(label)
		hasher.combine(projectId)
		hasher.combine(parentId)
		hasher.combine(billable)
		hasher.combine(dateStart)
		hasher.combine(dateEnd)
		hasher.combine(plannedWorkload)
		hasher.combine(progress)
		hasher.combine(description)
		hasher.combine(budgetAmount)
		hasher.combine(totalTimeSpentSeconds)
        super.hash(into: &hasher)
	}

	override public func isEqual(to other: CommonBusinessObject) -> Bool {
		guard let other = other as? DolibarrTask else { return false }
		return ref == other.ref
		&& label == other.label
		&& projectId == other.projectId
		&& parentId == other.parentId
		&& billable == other.billable
		&& dateStart == other.dateStart
		&& dateEnd == other.dateEnd
		&& plannedWorkload == other.plannedWorkload
		&& progress == other.progress
		&& description == other.description
		&& budgetAmount == other.budgetAmount
		&& totalTimeSpentSeconds == other.totalTimeSpentSeconds
		&& super.isEqual(to: other)
	}

	override public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfNotEmpty(ref, forKey: .ref)
		try container.encodeIfNotEmpty(label, forKey: .label)
		try container.encodeIfNotEmpty(projectId, forKey: .projectId)
		try container.encodeIfNotEmpty(parentId, forKey: .parentId)
		try container.encodeIfPresent(billable, forKey: .billable)
		try container.encodeIfPresentAndNotZero(dateStart, forKey: .dateStart)
		try container.encodeIfPresentAndNotZero(dateEnd, forKey: .dateEnd)
		try container.encodeIfPresent(plannedWorkload, forKey: .plannedWorkload)
		try container.encodeIfPresent(progress, forKey: .progress)
		try container.encodeIfPresent(description, forKey: .description)
		try container.encodeIfPresent(budgetAmount, forKey: .budgetAmount)
		try super.encode(to: encoder)
	}

}
