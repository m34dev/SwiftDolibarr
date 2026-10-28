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
//  DolibarrSupplierInvoiceClose.swift
//  SwiftDolibarr
//
//  Created by William Mead on 15/09/2026.
//

import Foundation

/// Represents the close reason for a Dolibarr supplier invoice.
///
/// Predefined static instances cover the standard close reasons:
/// ``discount``, ``badSupplier``, ``bankCharge``, ``withholdingTax``,
/// ``other``, ``abandoned``, and ``replaced``.
///
/// - SeeAlso: ``DolibarrSupplierInvoice``
public struct DolibarrSupplierInvoiceClose: Identifiable, Hashable, Sendable {

	// MARK: - Properties

	/// Supplier invoice close unique identifier
	public var id: UUID = UUID()

	/// Supplier invoice close code
	public var code: String

	// MARK: - Static properties

	public static let discount = DolibarrSupplierInvoiceClose(code: "discount_vat")
	public static let badSupplier = DolibarrSupplierInvoiceClose(code: "badsupplier")
	public static let bankCharge = DolibarrSupplierInvoiceClose(code: "bankcharge")
	public static let withholdingTax = DolibarrSupplierInvoiceClose(code: "withholdingtax")
	public static let other = DolibarrSupplierInvoiceClose(code: "other")
	public static let abandoned = DolibarrSupplierInvoiceClose(code: "abandon")
	public static let replaced = DolibarrSupplierInvoiceClose(code: "replaced")
	public static let unknown = DolibarrSupplierInvoiceClose(code: "")

	public static let allClose: [DolibarrSupplierInvoiceClose] = [
		discount, badSupplier, bankCharge, withholdingTax, other, abandoned, replaced
	]

}
