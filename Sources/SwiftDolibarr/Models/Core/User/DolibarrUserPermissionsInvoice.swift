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
//  DolibarrUserPermissionsInvoice.swift
//  SwiftDolibarr
//
//  Created by William Mead on 09/03/2026.
//

import Foundation

/// Invoice module permissions for a Dolibarr user.
///
/// - SeeAlso: ``DolibarrUserPermissions``
public struct DolibarrUserPermissionsInvoice: Codable, Hashable {

	// MARK: - Properties

	public var lire: Int?
	public var creer: Int?
	public var invoiceAdvance: [String: Int]?
	public var paiement: Int?
	public var supprimer: Int?

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case lire
		case creer
		case invoiceAdvance = "invoice_advance"
		case paiement
		case supprimer
	}

	// MARK: - Inits

	public init(lire: Int?, creer: Int?, invoiceAdvance: [String: Int]?, paiement: Int?, supprimer: Int?) {
		self.lire = lire
		self.creer = creer
		self.invoiceAdvance = invoiceAdvance
		self.paiement = paiement
		self.supprimer = supprimer
	}

	public init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.lire = try container.decodeIfPresent(Int.self, forKey: .lire)
		self.creer = try container.decodeIfPresent(Int.self, forKey: .creer)
		self.invoiceAdvance = try container.decodeIfPresent([String: Int].self, forKey: .invoiceAdvance)
		self.paiement = try container.decodeIfPresent(Int.self, forKey: .paiement)
		self.supprimer = try container.decodeIfPresent(Int.self, forKey: .supprimer)
	}

}
