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

import Foundation
import Testing
@testable import SwiftDolibarr

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
}

@Test func decodeSupplierOrder() async throws {
    let json = """
    {
        "id": "42",
        "ref": "CF2026-0001",
        "ref_supplier": "PO-9981",
        "socid": "7",
        "status": "3",
        "total_ht": "1000.00",
        "total_tva": "200.00",
        "total_ttc": "1200.00",
        "date_creation": 1700000000,
        "date_commande": 1700000100,
        "delivery_date": 1700100000,
        "billed": "0",
        "lines": [
            {
                "id": "1",
                "rang": "1",
                "fk_commande": "42",
                "ref_fourn": "SUP-REF-1",
                "desc": "Widget",
                "qty": "10",
                "subprice": "100.00",
                "tva_tx": "20.0",
                "total_ht": "1000.00",
                "total_tva": "200.00",
                "total_ttc": "1200.00",
                "special_code": "0",
                "remise_percent": "0.0"
            }
        ]
    }
    """
    let decoder = JSONDecoder()
    let order = try decoder.decode(DolibarrSupplierOrder.self, from: Data(json.utf8))

    #expect(order.id == "42")
    #expect(order.ref == "CF2026-0001")
    #expect(order.supplierRef == "PO-9981")
    #expect(order.thirdPartyId == "7")
    #expect(order.status == .supplierOrderSent)
    #expect(order.dateCreation == 1700000000)
    #expect(order.dateOrder == 1700000100)
    #expect(order.lines.count == 1)
    #expect(order.lines[0].supplierOrderId == "42")
    #expect(order.lines[0].supplierProductRef == "SUP-REF-1")

    let encoder = JSONEncoder()
    let redecoded = try decoder.decode(DolibarrSupplierOrder.self, from: encoder.encode(order))
    #expect(redecoded == order)
}

@Test func decodeSupplierInvoice() async throws {
    let json = """
    {
        "id": "99",
        "ref": "FF2026-0001",
        "ref_supplier": "INV-4412",
        "socid": "7",
        "status": "2",
        "type": "0",
        "paye": "1",
        "close_code": "discount_vat",
        "total_ht": "500.00",
        "total_tva": "100.00",
        "total_ttc": "600.00",
        "date": 1700000000,
        "lines": [
            {
                "id": "1",
                "rang": "1",
                "fk_facture_fourn": "99",
                "ref_supplier": "SUP-REF-2",
                "desc": "Service",
                "qty": "1",
                "subprice": "500.00",
                "tva_tx": "20.0",
                "total_ht": "500.00",
                "total_tva": "100.00",
                "total_ttc": "600.00",
                "special_code": "0",
                "remise_percent": "0.0"
            }
        ]
    }
    """
    let decoder = JSONDecoder()
    let invoice = try decoder.decode(DolibarrSupplierInvoice.self, from: Data(json.utf8))

    #expect(invoice.id == "99")
    #expect(invoice.supplierRef == "INV-4412")
    #expect(invoice.status == .supplierInvoiceClosed)
    #expect(invoice.type == .standard)
    #expect(invoice.close == .discount)
    #expect(invoice.lines.count == 1)
    #expect(invoice.lines[0].supplierInvoiceId == "99")
    #expect(invoice.lines[0].supplierProductRef == "SUP-REF-2")

    let encoder = JSONEncoder()
    let redecoded = try decoder.decode(DolibarrSupplierInvoice.self, from: encoder.encode(invoice))
    #expect(redecoded == invoice)
}

/// Live `GET /supplierorders` response from Dolibarr v21 (approved order, not yet sent to supplier)
@Test func decodeLiveSupplierOrderV21() async throws {
    let json = """
    [
      {
        "id": "1",
        "entity": "1",
        "array_options": [],
        "contacts_ids": null,
        "linkedObjectsIds": null,
        "ref": "PO2506-0001",
        "statut": "2",
        "status": "2",
        "mode_reglement_id": null,
        "cond_reglement_id": null,
        "multicurrency_code": "EUR",
        "last_main_doc": "fournisseur/commande/PO2506-0001/PO2506-0001.pdf",
        "note_public": "",
        "note_private": "",
        "total_ht": "50.00000000",
        "total_tva": "10.00000000",
        "total_ttc": "60.00000000",
        "lines": [
          {
            "id": "1",
            "array_options": [],
            "ref": "P1",
            "total_ht": "50.00000000",
            "total_tva": "10.00000000",
            "total_ttc": "60.00000000",
            "product_type": "0",
            "fk_product": "1",
            "desc": "",
            "description": "",
            "product_ref": "P1",
            "product_label": "Produit 1",
            "qty": "1",
            "remise_percent": "0",
            "special_code": "0",
            "subprice": "50.00000000",
            "tva_tx": "20.0000",
            "fk_commande": "1",
            "rang": "1",
            "date_start": "",
            "date_end": "",
            "ref_supplier": "P1",
            "ref_fourn": "P1"
          }
        ],
        "date_creation": 1749822336,
        "date_validation": null,
        "user_validation_id": "1",
        "ref_supplier": "",
        "ref_fourn": null,
        "billed": "0",
        "socid": "2",
        "fourn_id": "2",
        "date": 1749822336,
        "date_valid": 1749823249,
        "date_approve": 1749823249,
        "date_approve2": "",
        "date_commande": "",
        "delivery_date": "",
        "user_author_id": "1",
        "user_approve_id": "1",
        "user_approve_id2": null
      }
    ]
    """
    let decoder = JSONDecoder()
    let orders = try decoder.decode([DolibarrSupplierOrder].self, from: Data(json.utf8))
    let order = try #require(orders.first)

    #expect(order.ref == "PO2506-0001")
    #expect(order.thirdPartyId == "2")
    #expect(order.status == .supplierOrderApproved)
    #expect(order.billed == "0")
    #expect(order.dateCreation == 1749822336)
    #expect(order.dateValidation == 1749823249)
    #expect(order.dateApproval == 1749823249)
    #expect(order.dateApproval2 == nil)
    #expect(order.dateOrder == nil)
    #expect(order.deliveryDate == nil)
    #expect(order.userAuthorId == "1")
    #expect(order.userApproveId == "1")
    #expect(order.userApproveId2 == nil)
    #expect(order.lastMainDoc == "fournisseur/commande/PO2506-0001/PO2506-0001.pdf")
    #expect(order.lines.count == 1)
    #expect(order.lines[0].supplierOrderId == "1")
    #expect(order.lines[0].supplierProductRef == "P1")
    #expect(order.lines[0].productId == "1")

    let encoder = JSONEncoder()
    let redecoded = try decoder.decode(DolibarrSupplierOrder.self, from: encoder.encode(order))
    #expect(redecoded == order)
}

/// Live `GET /supplierinvoices` response from Dolibarr v21 (validated, unpaid invoice)
@Test func decodeLiveSupplierInvoiceV21() async throws {
    let json = """
    [
      {
        "id": "1",
        "entity": "1",
        "array_options": [],
        "contacts_ids": null,
        "linkedObjectsIds": null,
        "ref": "SI2610-0001",
        "ref_ext": "",
        "statut": "1",
        "status": "1",
        "mode_reglement_id": "2",
        "cond_reglement_id": "7",
        "multicurrency_code": "EUR",
        "last_main_doc": null,
        "note_public": "",
        "note_private": "",
        "total_ht": "50.00000000",
        "total_tva": "10.00000000",
        "total_ttc": "60.00000000",
        "lines": [
          {
            "id": "1",
            "array_options": [],
            "ref": "P1",
            "total_ht": "50.00000000",
            "total_tva": "10.00000000",
            "total_ttc": "60.00000000",
            "product_type": "0",
            "fk_product": "1",
            "desc": "Produit 1",
            "description": "Produit 1",
            "product_ref": "P1",
            "product_label": "Produit 1",
            "qty": "1",
            "remise_percent": "0",
            "special_code": "0",
            "subprice": "50.00000000",
            "tva_tx": "20.0000",
            "ref_supplier": "P1",
            "pu_ht": "50.00000000",
            "pu_ttc": "60.00000000",
            "fk_facture_fourn": "1",
            "date_start": "",
            "date_end": "",
            "rang": "1"
          }
        ],
        "date_creation": null,
        "date_validation": null,
        "tms": 1793176730,
        "user_creation_id": "1",
        "user_validation_id": "1",
        "type": 0,
        "subtype": 0,
        "socid": "2",
        "paye": "0",
        "date": 1793142000,
        "date_lim_reglement": null,
        "close_code": null,
        "close_note": null,
        "ref_supplier": "123456",
        "fk_statut": "1",
        "paid": "0",
        "datec": 1793176726,
        "date_echeance": 1793142000,
        "fk_user_valid": null
      }
    ]
    """
    let decoder = JSONDecoder()
    let invoices = try decoder.decode([DolibarrSupplierInvoice].self, from: Data(json.utf8))
    let invoice = try #require(invoices.first)

    #expect(invoice.ref == "SI2610-0001")
    #expect(invoice.supplierRef == "123456")
    #expect(invoice.thirdPartyId == "2")
    #expect(invoice.status == .validated)
    #expect(invoice.typeCode == "0")
    #expect(invoice.type == .standard)
    #expect(invoice.paidCode == "0")
    #expect(invoice.date == 1793142000)
    #expect(invoice.dateCreation == 1793176726)
    #expect(invoice.dateValidation == nil)
    #expect(invoice.dueDate == 1793142000)
    #expect(invoice.userAuthorId == "1")
    #expect(invoice.paymentMethodId == "2")
    #expect(invoice.paymentTermsId == "7")
    #expect(invoice.lastMainDoc == nil)
    #expect(invoice.closeCode == nil)
    #expect(invoice.lines.count == 1)
    #expect(invoice.lines[0].supplierInvoiceId == "1")
    #expect(invoice.lines[0].supplierProductRef == "P1")
    #expect(invoice.lines[0].productId == "1")

    let encoder = JSONEncoder()
    let redecoded = try decoder.decode(DolibarrSupplierInvoice.self, from: encoder.encode(invoice))
    #expect(redecoded == invoice)
}

// MARK: - Equality and hashing

private func makeContact() -> DolibarrContact {
    DolibarrContact(
        email: "jane@example.com",
        lastname: "Doe",
        firstname: "Jane",
        address: "1 rue de la Paix",
        zipCode: "75002",
        city: "Paris",
        socid: "7",
        phoneMobile: "+33600000000",
        id: "12",
        statusCode: "1"
    )
}

@Test func contactCopyIsEqualWithSameHash() async throws {
    let contact = makeContact()
    let copy = DolibarrContact(copying: contact)

    #expect(copy == contact)
    #expect(copy.hashValue == contact.hashValue)
    #expect(AnyHashable(copy) == AnyHashable(contact))
}

@Test func contactsDifferingInAddressAreNotEqual() async throws {
    let contact = makeContact()
    let edited = DolibarrContact(copying: contact)
    edited.address = "2 avenue Foch"

    #expect(edited != contact)
    #expect(edited.hashValue != contact.hashValue)
    // Generic Equatable path, as used by SwiftUI diffing
    #expect(AnyHashable(edited) != AnyHashable(contact))
    #expect((edited as CommonBusinessObject) != (contact as CommonBusinessObject))
}

@Test func contactsDifferingInPhoneAreNotEqual() async throws {
    let contact = makeContact()
    let edited = DolibarrContact(copying: contact)
    edited.phoneMobile = "+33611111111"

    #expect(edited != contact)
    #expect(edited.hashValue != contact.hashValue)
    #expect(AnyHashable(edited) != AnyHashable(contact))
}

@Test func contactIsNotEqualToBaseObjectWithSameFields() async throws {
    let contact = makeContact()
    let base = CommonBusinessObject(id: contact.id, statusCode: contact.statusCode)

    #expect((contact as CommonBusinessObject) != base)
    #expect(base != (contact as CommonBusinessObject))
}
