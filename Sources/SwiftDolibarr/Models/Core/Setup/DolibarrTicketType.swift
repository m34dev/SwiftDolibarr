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
//  DolibarrTicketType.swift
//  SwiftDolibarr
//
//  Created by William Mead on 27/11/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A Dolibarr ticket type.
///
/// Maps to the Dolibarr `/setup/dictionary/ticket_types` REST API endpoint
/// (table `c_ticket_type`). The ``code`` is the value of ``DolibarrTicket/typeCode``.
/// Pass `lang` to the endpoint to get a translated ``label``.
///
/// - Note: Requires the **Ticket** module to be activated in Dolibarr.
/// - SeeAlso: ``DolibarrTicket``
public struct DolibarrTicketType: Hashable, Decodable, Sendable, DolibarrObject {

	// MARK: - Properties

	/// Type ID
	///
	/// - Mapped Dolibarr property: **rowid**
	public var id: String

	/// Type code
	public var code: String

	/// Display label
	public var label: String

	/// Sort position
	///
	/// - Mapped Dolibarr property: **pos**
	public var position: Int?

	/// Whether this type is selected by default for a new ticket
	///
	/// - Mapped Dolibarr property: **use_default**
	public var isDefault: Bool

	/// Description
	public var description: String?

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case id = "rowid"
		case code
		case label
		case position = "pos"
		case isDefault = "use_default"
		case description
	}

	// MARK: - Inits

	public init(
		id: String = "",
		code: String = "",
		label: String = "",
		position: Int? = nil,
		isDefault: Bool = false,
		description: String? = nil
	) {
		self.id = id
		self.code = code
		self.label = label
		self.position = position
		self.isDefault = isDefault
		self.description = description
	}

	public init(from decoder: any Decoder) throws {
		do {
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
			#endif
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.id = try container.decode(MultiType.self, forKey: .id).stringValue
			self.code = try container.decode(MultiType.self, forKey: .code).stringValue
			self.label = try container.decodeIfPresent(String.self, forKey: .label) ?? ""
			self.position = try container.decodeIfPresent(MultiType.self, forKey: .position)?.intValue
			self.isDefault = try container.decodeIfPresent(MultiType.self, forKey: .isDefault)?.intValue == 1
			let description = try container.decodeIfPresent(String.self, forKey: .description)
			self.description = description?.isEmpty == false ? description : nil
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

}
