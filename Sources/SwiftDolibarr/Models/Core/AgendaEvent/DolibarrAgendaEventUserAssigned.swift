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
//  DolibarrAgendaEventUserAssigned.swift
//  SwiftDolibarr
//
//  Created by William Mead on 25/06/2025.
//

import Foundation

/// A user assigned to a Dolibarr agenda event.
///
/// Each assigned user has an ``id``, an optional ``mandatory`` flag,
/// an ``answerStatus``, and a ``transparency`` setting.
///
/// - SeeAlso: ``DolibarrAgendaEvent``
public struct DolibarrAgendaEventUserAssigned: Codable, Equatable, Hashable, DolibarrObject {

	// MARK: - Properties

	/// Assigned user ID
	public var id: String

	/// Assigned user mandatory flag
	public var mandatory: String?

	/// Assigned user answer status
	///
	/// - Mapped Dolibarr property: **answer_status**
	public var answerStatus: String?

	/// Assigned user transparency
	public var transparency: String?

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case id
		case mandatory
		case answerStatus = "answer_status"
		case transparency
	}

	// MARK: - Inits

	public init(
		id: String,
		mandatory: String? = nil,
		answerStatus: String? = nil,
		transparency: String? = nil
	) {
		self.id = id
		self.mandatory = mandatory
		self.answerStatus = answerStatus
		self.transparency = transparency
	}

}

/// A contact assigned to a Dolibarr agenda event.
///
/// Same shape as an assigned user. Only ``DolibarrAgendaEventUserAssigned/id`` is used when sending
/// it: Dolibarr stores contacts as not mandatory, not transparent and with no answer.
///
/// - SeeAlso: ``DolibarrAgendaEvent/contactsAssigned``
public typealias DolibarrAgendaEventContactAssigned = DolibarrAgendaEventUserAssigned
