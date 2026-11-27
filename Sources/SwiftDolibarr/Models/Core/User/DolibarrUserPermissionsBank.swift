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
//  DolibarrUserPermissionsBank.swift
//  SwiftDolibarr
//
//  Created by William Mead on 27/11/2026.
//

import Foundation

/// Bank module permissions for a Dolibarr user.
///
/// Mapped from the **banque** permission node. Dolibarr only returns it when the Banque module is activated.
/// Reading bank accounts (`GET /bankaccounts`), needed to add a payment, requires ``read``.
///
/// - SeeAlso: ``DolibarrUserPermissions``
public struct DolibarrUserPermissionsBank: Codable, Hashable {

	// MARK: - Properties

	/// Read bank accounts and transactions
	///
	/// - Mapped Dolibarr property: **lire**
	public var read: Int?

	/// Create and update bank transactions
	///
	/// - Mapped Dolibarr property: **modifier**
	public var modify: Int?

	/// Set up bank accounts and categories
	///
	/// - Mapped Dolibarr property: **configurer**
	public var configure: Int?

	/// Reconcile bank transactions
	///
	/// - Mapped Dolibarr property: **consolidate**
	public var consolidate: Int?

	/// Export bank transactions
	///
	/// - Mapped Dolibarr property: **export**
	public var export: Int?

	/// Transfer between accounts
	///
	/// - Mapped Dolibarr property: **transfer**
	public var transfer: Int?

	/// Manage cheque deposits
	///
	/// - Mapped Dolibarr property: **cheque**
	public var cheque: Int?

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case read = "lire"
		case modify = "modifier"
		case configure = "configurer"
		case consolidate
		case export
		case transfer
		case cheque
	}

	// MARK: - Inits

	public init(
		read: Int? = nil,
		modify: Int? = nil,
		configure: Int? = nil,
		consolidate: Int? = nil,
		export: Int? = nil,
		transfer: Int? = nil,
		cheque: Int? = nil
	) {
		self.read = read
		self.modify = modify
		self.configure = configure
		self.consolidate = consolidate
		self.export = export
		self.transfer = transfer
		self.cheque = cheque
	}

	public init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.read = try container.decodeIfPresent(Int.self, forKey: .read)
		self.modify = try container.decodeIfPresent(Int.self, forKey: .modify)
		self.configure = try container.decodeIfPresent(Int.self, forKey: .configure)
		self.consolidate = try container.decodeIfPresent(Int.self, forKey: .consolidate)
		self.export = try container.decodeIfPresent(Int.self, forKey: .export)
		self.transfer = try container.decodeIfPresent(Int.self, forKey: .transfer)
		self.cheque = try container.decodeIfPresent(Int.self, forKey: .cheque)
	}

}
