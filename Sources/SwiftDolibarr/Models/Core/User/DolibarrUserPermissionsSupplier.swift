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
//  DolibarrUserPermissionsSupplier.swift
//  SwiftDolibarr
//
//  Created by William Mead on 28/10/2026.
//

import Foundation

/// Supplier module permissions for a Dolibarr user.
///
/// Dolibarr groups supplier order and supplier invoice rights under the
/// **fournisseur** permission node, with advanced rights in separate sub-nodes.
///
/// - SeeAlso: ``DolibarrUserPermissions``
public struct DolibarrUserPermissionsSupplier: Codable, Hashable {

	// MARK: - Properties

	public var lire: Int?
	public var commande: DolibarrUserPermissionsSupplierOrder?
	public var supplierOrderAdvance: [String: Int]?
	public var commandeAdvance: [String: Int]?
	public var facture: DolibarrUserPermissionsSupplierInvoice?
	public var supplierInvoiceAdvance: [String: Int]?

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case lire
		case commande
		case supplierOrderAdvance = "supplier_order_advance"
		case commandeAdvance = "commande_advance"
		case facture
		case supplierInvoiceAdvance = "supplier_invoice_advance"
	}

	// MARK: - Inits

	public init(
		lire: Int? = nil,
		commande: DolibarrUserPermissionsSupplierOrder? = nil,
		supplierOrderAdvance: [String: Int]? = nil,
		commandeAdvance: [String: Int]? = nil,
		facture: DolibarrUserPermissionsSupplierInvoice? = nil,
		supplierInvoiceAdvance: [String: Int]? = nil
	) {
		self.lire = lire
		self.commande = commande
		self.supplierOrderAdvance = supplierOrderAdvance
		self.commandeAdvance = commandeAdvance
		self.facture = facture
		self.supplierInvoiceAdvance = supplierInvoiceAdvance
	}

	public init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.lire = try container.decodeIfPresent(Int.self, forKey: .lire)
		self.commande = try container.decodeIfPresent(DolibarrUserPermissionsSupplierOrder.self, forKey: .commande)
		self.supplierOrderAdvance = try container.decodeIfPresent([String: Int].self, forKey: .supplierOrderAdvance)
		self.commandeAdvance = try container.decodeIfPresent([String: Int].self, forKey: .commandeAdvance)
		self.facture = try container.decodeIfPresent(DolibarrUserPermissionsSupplierInvoice.self, forKey: .facture)
		self.supplierInvoiceAdvance = try container.decodeIfPresent([String: Int].self, forKey: .supplierInvoiceAdvance)
	}

}
