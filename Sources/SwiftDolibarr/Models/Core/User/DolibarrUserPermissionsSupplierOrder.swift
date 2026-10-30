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
//  DolibarrUserPermissionsSupplierOrder.swift
//  SwiftDolibarr
//
//  Created by William Mead on 28/10/2026.
//

import Foundation

/// Supplier order permissions for a Dolibarr user.
///
/// Mapped from the **fournisseur.commande** permission node.
///
/// - SeeAlso: ``DolibarrUserPermissions``
public struct DolibarrUserPermissionsSupplierOrder: Codable, Hashable {

	// MARK: - Properties

	public var lire: Int?
	public var creer: Int?
	public var approuver: Int?
	/// Second-level approval, only defined when `SUPPLIER_ORDER_3_STEPS_TO_BE_APPROVED` is enabled
	public var approve2: Int?
	public var commander: Int?
	public var receptionner: Int?
	public var supprimer: Int?
	public var export: Int?

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case lire
		case creer
		case approuver
		case approve2
		case commander
		case receptionner
		case supprimer
		case export
	}

	// MARK: - Inits

	public init(
		lire: Int? = nil,
		creer: Int? = nil,
		approuver: Int? = nil,
		approve2: Int? = nil,
		commander: Int? = nil,
		receptionner: Int? = nil,
		supprimer: Int? = nil,
		export: Int? = nil
	) {
		self.lire = lire
		self.creer = creer
		self.approuver = approuver
		self.approve2 = approve2
		self.commander = commander
		self.receptionner = receptionner
		self.supprimer = supprimer
		self.export = export
	}

	public init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.lire = try container.decodeIfPresent(Int.self, forKey: .lire)
		self.creer = try container.decodeIfPresent(Int.self, forKey: .creer)
		self.approuver = try container.decodeIfPresent(Int.self, forKey: .approuver)
		self.approve2 = try container.decodeIfPresent(Int.self, forKey: .approve2)
		self.commander = try container.decodeIfPresent(Int.self, forKey: .commander)
		self.receptionner = try container.decodeIfPresent(Int.self, forKey: .receptionner)
		self.supprimer = try container.decodeIfPresent(Int.self, forKey: .supprimer)
		self.export = try container.decodeIfPresent(Int.self, forKey: .export)
	}

}
