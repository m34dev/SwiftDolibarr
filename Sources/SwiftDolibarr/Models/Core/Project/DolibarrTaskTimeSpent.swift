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
//  DolibarrTaskTimeSpent.swift
//  SwiftDolibarr
//
//  Created by William Mead on 14/11/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A time spent entry on a Dolibarr task.
///
/// Decoded from the `lines` of `GET /tasks/{id}?includetimespent=2` (v16+),
/// also returned by `GET /tasks/{id}/timespent` (v23+).
///
/// Encoded as the body to add (`POST /tasks/{id}/addtimespent`) or update
/// (`PUT /tasks/{id}/timespent/{timespent_id}`, v18+) an entry, which uses other keys:
/// `date` (GMT `YYYY-MM-DD HH:MM:SS`), `duration`, `user_id`, `product_id`, `note` and `progress`.
/// Dolibarr always stores a written entry with its hour.
///
/// - Note: Requires the **Projet** module to be activated in Dolibarr.
/// - SeeAlso: ``DolibarrTask``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrTaskTimeSpent: Hashable, Codable, DolibarrObject {

	// MARK: - Properties

	/// Time spent entry ID
	///
	/// - Mapped Dolibarr property: **timespent_line_id**
	public var id: String

	/// Task ID
	///
	/// - Mapped Dolibarr property: **fk_task**
	public var taskId: String

	/// Day of the entry (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **timespent_line_date**
	public var dateTimestamp: Int?

	/// Day and hour of the entry (Unix timestamp), only meaningful when ``withHour`` is true
	///
	/// - Mapped Dolibarr property: **timespent_line_datehour**
	public var dateHourTimestamp: Int?

	/// Whether the entry has an hour, not only a day
	///
	/// - Mapped Dolibarr property: **timespent_line_withhour**
	public var withHour: Bool

	/// Duration in seconds
	///
	/// - Mapped Dolibarr property: **timespent_line_duration**
	public var durationSeconds: Int

	/// User ID of who spent the time
	///
	/// Empty encodes `user_id` 0, the connected user, which only `POST addtimespent` understands:
	/// on `PUT`, Dolibarr would store user 0, so keep the decoded user ID when updating.
	///
	/// - Mapped Dolibarr property: **timespent_line_fk_user**
	public var userId: String

	/// Product (service) ID used, if any
	///
	/// - Mapped Dolibarr property: **timespent_line_fk_product**
	public var productId: String?

	/// Hourly rate
	///
	/// - Mapped Dolibarr property: **timespent_line_thm**
	public var hourlyRate: String?

	/// Note
	///
	/// - Mapped Dolibarr property: **timespent_line_note**
	public var note: String?

	/// New task progress in percent (0-100) to send when adding the entry, nil to leave it unchanged
	///
	/// Write only: never decoded, ignored by Dolibarr on update.
	///
	/// - Mapped Dolibarr property: **progress**
	public var progress: Int?

	// MARK: - Type properties

	/// Format of the date sent to Dolibarr: `YYYY-MM-DD HH:MM:SS` in GMT
	public static let dateFormatStyle = Date.VerbatimFormatStyle(
		format: "\(year: .padded(4))-\(month: .twoDigits)-\(day: .twoDigits) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)",
		timeZone: .gmt,
		calendar: Calendar(identifier: .gregorian)
	)

	// MARK: - Computed properties

	/// Date of the entry: day and hour when ``withHour`` is true, else the day
	///
	/// Setting it sets the day and hour, as Dolibarr stores them when writing.
	public var date: Date? {
		get {
			guard let timestamp = withHour ? (dateHourTimestamp ?? dateTimestamp) : dateTimestamp else { return nil }
			return Date(timeIntervalSince1970: TimeInterval(timestamp))
		}
		set {
			let timestamp = newValue.map { Int($0.timeIntervalSince1970) }
			dateTimestamp = timestamp
			dateHourTimestamp = timestamp
			withHour = timestamp != nil
		}
	}

	/// Duration as a `Duration`
	public var duration: Duration {
		.seconds(durationSeconds)
	}

	/// Hourly rate as a `Double`
	public var hourlyRateValue: Double? {
		guard let hourlyRate else { return nil }
		return Double(hourlyRate)
	}

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case id = "timespent_line_id"
		case taskId = "fk_task"
		case dateTimestamp = "timespent_line_date"
		case dateHourTimestamp = "timespent_line_datehour"
		case withHour = "timespent_line_withhour"
		case durationSeconds = "timespent_line_duration"
		case userId = "timespent_line_fk_user"
		case productId = "timespent_line_fk_product"
		case hourlyRate = "timespent_line_thm"
		case note = "timespent_line_note"
	}

	/// Keys of the add and update body
	enum WriteCodingKeys: String, CodingKey {
		case date
		case durationSeconds = "duration"
		case userId = "user_id"
		case productId = "product_id"
		case note
		case progress
	}

	// MARK: - Inits

	public init(
		id: String = "",
		taskId: String = "",
		dateTimestamp: Int? = nil,
		dateHourTimestamp: Int? = nil,
		withHour: Bool = false,
		durationSeconds: Int = 0,
		userId: String = "",
		productId: String? = nil,
		hourlyRate: String? = nil,
		note: String? = nil,
		progress: Int? = nil
	) {
		self.id = id
		self.taskId = taskId
		self.dateTimestamp = dateTimestamp
		self.dateHourTimestamp = dateHourTimestamp
		self.withHour = withHour
		self.durationSeconds = durationSeconds
		self.userId = userId
		self.productId = productId
		self.hourlyRate = hourlyRate
		self.note = note
		self.progress = progress
	}

	public required init(from decoder: any Decoder) throws {
		do {
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
			#endif
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.id = try container.decode(MultiType.self, forKey: .id).stringValue
			self.taskId = try container.decodeIfPresent(MultiType.self, forKey: .taskId)?.stringValue ?? ""
			self.dateTimestamp = try container.decodeIfPresent(MultiType.self, forKey: .dateTimestamp)?.intValue
			self.dateHourTimestamp = try container.decodeIfPresent(MultiType.self, forKey: .dateHourTimestamp)?.intValue
			self.withHour = try container.decodeIfPresent(MultiType.self, forKey: .withHour)?.intValue == 1
			self.durationSeconds = try container.decodeIfPresent(MultiType.self, forKey: .durationSeconds)?.intValue ?? 0
			self.userId = try container.decodeIfPresent(MultiType.self, forKey: .userId)?.stringValue ?? ""
			self.productId = try container.decodeIfPresent(MultiType.self, forKey: .productId)?.stringValue
			self.hourlyRate = try container.decodeIfPresent(MultiType.self, forKey: .hourlyRate)?.stringValue
			self.note = try container.decodeIfPresent(String.self, forKey: .note)
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

	public init(copying source: DolibarrTaskTimeSpent) {
		self.id = source.id
		self.taskId = source.taskId
		self.dateTimestamp = source.dateTimestamp
		self.dateHourTimestamp = source.dateHourTimestamp
		self.withHour = source.withHour
		self.durationSeconds = source.durationSeconds
		self.userId = source.userId
		self.productId = source.productId
		self.hourlyRate = source.hourlyRate
		self.note = source.note
		self.progress = source.progress
	}

	// MARK: - Methods

	public func copy(_ source: DolibarrTaskTimeSpent) {
		self.id = source.id
		self.taskId = source.taskId
		self.dateTimestamp = source.dateTimestamp
		self.dateHourTimestamp = source.dateHourTimestamp
		self.withHour = source.withHour
		self.durationSeconds = source.durationSeconds
		self.userId = source.userId
		self.productId = source.productId
		self.hourlyRate = source.hourlyRate
		self.note = source.note
		self.progress = source.progress
	}

	// MARK: - Protocol methods

	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(taskId)
		hasher.combine(dateTimestamp)
		hasher.combine(dateHourTimestamp)
		hasher.combine(withHour)
		hasher.combine(durationSeconds)
		hasher.combine(userId)
		hasher.combine(productId)
		hasher.combine(hourlyRate)
		hasher.combine(note)
		hasher.combine(progress)
	}

	/// Encodes the add and update body
	///
	/// - Throws: `EncodingError.invalidValue` when ``date`` is nil
	public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: WriteCodingKeys.self)
		guard let date else {
			throw EncodingError.invalidValue(self, EncodingError.Context(codingPath: container.codingPath + [WriteCodingKeys.date], debugDescription: "Time spent date is required"))
		}
		try container.encode(date.formatted(Self.dateFormatStyle), forKey: .date)
		try container.encode(durationSeconds, forKey: .durationSeconds)
		try container.encode(Int(userId) ?? 0, forKey: .userId)
		if let productId, let productIdValue = Int(productId), productIdValue > 0 {
			try container.encode(productIdValue, forKey: .productId)
		}
		try container.encode(note ?? "", forKey: .note)
		if let progress {
			try container.encode(min(max(progress, 0), 100), forKey: .progress)
		}
	}

	public static func == (lhs: DolibarrTaskTimeSpent, rhs: DolibarrTaskTimeSpent) -> Bool {
		lhs.id == rhs.id
		&& lhs.taskId == rhs.taskId
		&& lhs.dateTimestamp == rhs.dateTimestamp
		&& lhs.dateHourTimestamp == rhs.dateHourTimestamp
		&& lhs.withHour == rhs.withHour
		&& lhs.durationSeconds == rhs.durationSeconds
		&& lhs.userId == rhs.userId
		&& lhs.productId == rhs.productId
		&& lhs.hourlyRate == rhs.hourlyRate
		&& lhs.note == rhs.note
		&& lhs.progress == rhs.progress
	}

}
