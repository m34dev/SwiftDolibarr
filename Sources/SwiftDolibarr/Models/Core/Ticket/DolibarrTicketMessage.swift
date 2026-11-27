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
//  DolibarrTicketMessage.swift
//  SwiftDolibarr
//
//  Created by William Mead on 27/11/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A message of a Dolibarr ticket.
///
/// Decoded from the `messages` of `GET /tickets/{id}`, `GET /tickets/ref/{ref}`
/// and `GET /tickets/track_id/{track_id}`. Dolibarr builds them from every agenda event
/// linked to the ticket, newest first, so an entry can also be an event such as the ticket creation.
/// `datep` and `subject` are only returned since Dolibarr v21.
///
/// Encoded as the body to add a message (`POST /tickets/newmessage`), which uses other keys:
/// `track_id`, `message` and `private`. Dolibarr v20 to v24 find the ticket by `track_id` only.
///
/// - Note: Requires the **Ticket** module to be activated in Dolibarr.
/// - SeeAlso: ``DolibarrTicket``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrTicketMessage: Hashable, Codable, DolibarrObject {

	// MARK: - Properties

	/// Message (agenda event) ID
	public var id: String

	/// ID of the user owning the event, nil when the message comes from a contact or the public interface
	///
	/// - Mapped Dolibarr property: **fk_user_action**
	public var authorUserId: String?

	/// Third party ID of the user owning the event, for an external user
	///
	/// - Mapped Dolibarr property: **fk_user_action_socid**
	public var authorThirdPartyId: String?

	/// Full name of the user owning the event
	///
	/// - Mapped Dolibarr property: **fk_user_action_string**
	public var authorName: String?

	/// Creation date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **datec**
	public var dateCreate: Int?

	/// Event date (Unix timestamp), Dolibarr v21+
	///
	/// - Mapped Dolibarr property: **datep**
	public var dateEvent: Int?

	/// Event label, Dolibarr v21+
	public var subject: String?

	/// Message content (HTML)
	public var message: String

	/// Whether the message is private, only shown to internal users
	///
	/// - Mapped Dolibarr property: **private**
	public var isPrivate: Bool

	/// Tracking ID of the ticket to add the message to
	///
	/// Write only: never decoded, required to encode the new message body.
	///
	/// - Mapped Dolibarr property: **track_id**
	public var trackId: String?

	// MARK: - Computed properties

	/// Message creation date
	public var dateCreated: Date? {
		guard let dateCreate else { return nil }
		return Date(timeIntervalSince1970: TimeInterval(dateCreate))
	}

	/// Message date: the event date when present, else the creation date
	public var date: Date? {
		guard let timestamp = dateEvent ?? dateCreate else { return nil }
		return Date(timeIntervalSince1970: TimeInterval(timestamp))
	}

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case id
		case authorUserId = "fk_user_action"
		case authorThirdPartyId = "fk_user_action_socid"
		case authorName = "fk_user_action_string"
		case dateCreate = "datec"
		case dateEvent = "datep"
		case subject
		case message
		case isPrivate = "private"
	}

	/// Keys of the new message body
	enum WriteCodingKeys: String, CodingKey {
		case trackId = "track_id"
		case message
		case isPrivate = "private"
	}

	// MARK: - Inits

	public init(
		id: String = "",
		authorUserId: String? = nil,
		authorThirdPartyId: String? = nil,
		authorName: String? = nil,
		dateCreate: Int? = nil,
		dateEvent: Int? = nil,
		subject: String? = nil,
		message: String = "",
		isPrivate: Bool = false,
		trackId: String? = nil
	) {
		self.id = id
		self.authorUserId = authorUserId
		self.authorThirdPartyId = authorThirdPartyId
		self.authorName = authorName
		self.dateCreate = dateCreate
		self.dateEvent = dateEvent
		self.subject = subject
		self.message = message
		self.isPrivate = isPrivate
		self.trackId = trackId
	}

	public required init(from decoder: any Decoder) throws {
		do {
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
			#endif
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.id = try container.decode(MultiType.self, forKey: .id).stringValue
			self.authorUserId = try container.decodeIdIfPresent(forKey: .authorUserId)
			self.authorThirdPartyId = try container.decodeIdIfPresent(forKey: .authorThirdPartyId)
			let authorName = try container.decodeIfPresent(String.self, forKey: .authorName)
			self.authorName = authorName?.isEmpty == false ? authorName : nil
			self.dateCreate = try container.decodeIfPresent(MultiType.self, forKey: .dateCreate)?.intValue
			self.dateEvent = try container.decodeIfPresent(MultiType.self, forKey: .dateEvent)?.intValue
			self.subject = try container.decodeIfPresent(String.self, forKey: .subject)
			self.message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
			self.isPrivate = try container.decodeIfPresent(MultiType.self, forKey: .isPrivate)?.intValue == 1
			self.trackId = nil
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

	public init(copying source: DolibarrTicketMessage) {
		self.id = source.id
		self.authorUserId = source.authorUserId
		self.authorThirdPartyId = source.authorThirdPartyId
		self.authorName = source.authorName
		self.dateCreate = source.dateCreate
		self.dateEvent = source.dateEvent
		self.subject = source.subject
		self.message = source.message
		self.isPrivate = source.isPrivate
		self.trackId = source.trackId
	}

	// MARK: - Methods

	public func copy(_ source: DolibarrTicketMessage) {
		self.id = source.id
		self.authorUserId = source.authorUserId
		self.authorThirdPartyId = source.authorThirdPartyId
		self.authorName = source.authorName
		self.dateCreate = source.dateCreate
		self.dateEvent = source.dateEvent
		self.subject = source.subject
		self.message = source.message
		self.isPrivate = source.isPrivate
		self.trackId = source.trackId
	}

	// MARK: - Protocol methods

	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(authorUserId)
		hasher.combine(authorThirdPartyId)
		hasher.combine(authorName)
		hasher.combine(dateCreate)
		hasher.combine(dateEvent)
		hasher.combine(subject)
		hasher.combine(message)
		hasher.combine(isPrivate)
		hasher.combine(trackId)
	}

	/// Encodes the new message body
	///
	/// - Throws: `EncodingError.invalidValue` when ``trackId`` or ``message`` is empty
	public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: WriteCodingKeys.self)
		guard let trackId, !trackId.isEmpty else {
			throw EncodingError.invalidValue(self, EncodingError.Context(codingPath: container.codingPath + [WriteCodingKeys.trackId], debugDescription: "Ticket tracking ID is required"))
		}
		guard !message.isEmpty else {
			throw EncodingError.invalidValue(self, EncodingError.Context(codingPath: container.codingPath + [WriteCodingKeys.message], debugDescription: "Message is required"))
		}
		try container.encode(trackId, forKey: .trackId)
		try container.encode(message, forKey: .message)
		try container.encode(isPrivate ? 1 : 0, forKey: .isPrivate)
	}

	public static func == (lhs: DolibarrTicketMessage, rhs: DolibarrTicketMessage) -> Bool {
		lhs.id == rhs.id
		&& lhs.authorUserId == rhs.authorUserId
		&& lhs.authorThirdPartyId == rhs.authorThirdPartyId
		&& lhs.authorName == rhs.authorName
		&& lhs.dateCreate == rhs.dateCreate
		&& lhs.dateEvent == rhs.dateEvent
		&& lhs.subject == rhs.subject
		&& lhs.message == rhs.message
		&& lhs.isPrivate == rhs.isPrivate
		&& lhs.trackId == rhs.trackId
	}

}
