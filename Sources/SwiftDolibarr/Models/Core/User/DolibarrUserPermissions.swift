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
//  DolibarrUserPermissions.swift
//  SwiftDolibarr
//
//  Created by William Mead on 19/05/2025.
//

import Foundation

/// The complete set of permissions for a Dolibarr user.
///
/// Groups module-specific permission structs covering user management,
/// expense reports, invoices, products, services, interventions,
/// third parties, agenda, quotes, orders, barcodes, stock, and projects.
///
/// - SeeAlso: ``DolibarrUser``
public struct DolibarrUserPermissions: Codable, Hashable {

	// MARK: - Properties

	public var user: DolibarrUserPermissionsUser
	public var expensereport: DolibarrUserPermissionsExpenseReport?
	public var facture: DolibarrUserPermissionsInvoice?
	public var produit: DolibarrUserPermissionsProduct?
	public var service: DolibarrUserPermissionsService?
	public var ficheinter: DolibarrUserPermissionsIntervention?
	public var societe: DolibarrUserPermissionsThirdParty?
	public var agenda: DolibarrUserPermissionsAgenda?
	public var propale: DolibarrUserPermissionsQuote?
	public var commande: DolibarrUserPermissionsOrder?
	public var barcode: DolibarrUserPermissionsBarcode?
	public var stock: DolibarrUserPermissionsStock?
	public var projet: DolibarrUserPermissionsProject?
	public var lareponse: DolibarrUserPermissionsLaReponse?
	public var multicompany: DolibarrUserPermissionsMulticompany?

	// MARK: - Inits

	public init(
		user: DolibarrUserPermissionsUser,
		expensereport: DolibarrUserPermissionsExpenseReport? = nil,
		facture: DolibarrUserPermissionsInvoice? = nil,
		produit: DolibarrUserPermissionsProduct? = nil,
		service: DolibarrUserPermissionsService? = nil,
		ficheinter: DolibarrUserPermissionsIntervention? = nil,
		societe: DolibarrUserPermissionsThirdParty? = nil,
		agenda: DolibarrUserPermissionsAgenda? = nil,
		propale: DolibarrUserPermissionsQuote? = nil,
		commande: DolibarrUserPermissionsOrder? = nil,
		barcode: DolibarrUserPermissionsBarcode? = nil,
		stock: DolibarrUserPermissionsStock? = nil,
		projet: DolibarrUserPermissionsProject? = nil,
		lareponse: DolibarrUserPermissionsLaReponse? = nil,
		multicompany: DolibarrUserPermissionsMulticompany? = nil
	) {
		self.user = user
		self.expensereport = expensereport
		self.facture = facture
		self.produit = produit
		self.service = service
		self.ficheinter = ficheinter
		self.societe = societe
		self.agenda = agenda
		self.propale = propale
		self.commande = commande
		self.barcode = barcode
		self.stock = stock
		self.projet = projet
		self.lareponse = lareponse
		self.multicompany = multicompany
	}

	public init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.user = try container.decode(DolibarrUserPermissionsUser.self, forKey: .user)
		self.expensereport = try container.decodeIfPresent(DolibarrUserPermissionsExpenseReport.self, forKey: .expensereport)
		self.facture = try container.decodeIfPresent(DolibarrUserPermissionsInvoice.self, forKey: .facture)
		self.produit = try container.decodeIfPresent(DolibarrUserPermissionsProduct.self, forKey: .produit)
		self.service = try container.decodeIfPresent(DolibarrUserPermissionsService.self, forKey: .service)
		self.ficheinter = try container.decodeIfPresent(DolibarrUserPermissionsIntervention.self, forKey: .ficheinter)
		self.societe = try container.decodeIfPresent(DolibarrUserPermissionsThirdParty.self, forKey: .societe)
		self.agenda = try container.decodeIfPresent(DolibarrUserPermissionsAgenda.self, forKey: .agenda)
		self.propale = try container.decodeIfPresent(DolibarrUserPermissionsQuote.self, forKey: .propale)
		self.commande = try container.decodeIfPresent(DolibarrUserPermissionsOrder.self, forKey: .commande)
		self.barcode = try container.decodeIfPresent(DolibarrUserPermissionsBarcode.self, forKey: .barcode)
		self.stock = try container.decodeIfPresent(DolibarrUserPermissionsStock.self, forKey: .stock)
		self.projet = try container.decodeIfPresent(DolibarrUserPermissionsProject.self, forKey: .projet)
		self.lareponse = try container.decodeIfPresent(DolibarrUserPermissionsLaReponse.self, forKey: .lareponse)
		self.multicompany = try container.decodeIfPresent(DolibarrUserPermissionsMulticompany.self, forKey: .multicompany)
	}

}
