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
        "methode_commande_id": "2",
        "methode_commande": "Phone",
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
    #expect(order.orderMethodId == "2")
    #expect(order.orderMethod == "Phone")

    let encoder = JSONEncoder()
    let redecoded = try decoder.decode(DolibarrSupplierOrder.self, from: encoder.encode(order))
    #expect(redecoded == order)
    #expect(redecoded.orderMethodId == "2")
    #expect(redecoded.orderMethod == "Phone")
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

/// Live user permissions `fournisseur` node from Dolibarr v21
@Test func decodeSupplierUserPermissions() async throws {
    let json = """
    {
        "user": {
            "user": {"lire": 1},
            "self": {"creer": 1},
            "user_advance": {"readperms": 1},
            "self_advance": {"readperms": 1},
            "group_advance": {"read": 1}
        },
        "fournisseur": {
            "lire": 1,
            "commande": {
                "lire": 1,
                "creer": 1,
                "approuver": 1,
                "commander": 1,
                "receptionner": 1,
                "supprimer": 1,
                "export": 1
            },
            "supplier_order_advance": {
                "validate": 1
            },
            "commande_advance": {
                "check": 1
            },
            "facture": {
                "lire": 1,
                "creer": 1,
                "supprimer": 1,
                "export": 1
            },
            "supplier_invoice_advance": {
                "validate": 1,
                "send": 1
            }
        }
    }
    """
    let decoder = JSONDecoder()
    let permissions = try decoder.decode(DolibarrUserPermissions.self, from: Data(json.utf8))
    let supplier = try #require(permissions.fournisseur)

    #expect(supplier.lire == 1)
    #expect(supplier.commande?.lire == 1)
    #expect(supplier.commande?.approuver == 1)
    #expect(supplier.commande?.approve2 == nil)
    #expect(supplier.commande?.commander == 1)
    #expect(supplier.commande?.receptionner == 1)
    #expect(supplier.commande?.export == 1)
    #expect(supplier.supplierOrderAdvance?["validate"] == 1)
    #expect(supplier.commandeAdvance?["check"] == 1)
    #expect(supplier.facture?.lire == 1)
    #expect(supplier.facture?.supprimer == 1)
    #expect(supplier.supplierInvoiceAdvance?["validate"] == 1)
    #expect(supplier.supplierInvoiceAdvance?["send"] == 1)

    let encoder = JSONEncoder()
    let redecoded = try decoder.decode(DolibarrUserPermissions.self, from: encoder.encode(permissions))
    #expect(redecoded == permissions)
}

/// `fournisseur.commande` node with `SUPPLIER_ORDER_3_STEPS_TO_BE_APPROVED` enabled
@Test func decodeSupplierOrderSecondLevelApprovalPermission() async throws {
    let json = """
    {
        "lire": 1,
        "creer": 1,
        "approuver": 1,
        "approve2": 1,
        "commander": 1,
        "receptionner": 1,
        "supprimer": 1,
        "export": 1
    }
    """
    let decoder = JSONDecoder()
    let permissions = try decoder.decode(DolibarrUserPermissionsSupplierOrder.self, from: Data(json.utf8))

    #expect(permissions.approuver == 1)
    #expect(permissions.approve2 == 1)

    let redecoded = try decoder.decode(DolibarrUserPermissionsSupplierOrder.self, from: JSONEncoder().encode(permissions))
    #expect(redecoded == permissions)
    #expect(redecoded.approve2 == 1)
}

/// Live `GET /supplierorders` response from Dolibarr v23 (draft order, and validated order with a line)
@Test func decodeLiveSupplierOrdersV23() async throws {
    let json = """
    [
      {
        "id": "1",
        "entity": "1",
        "array_options": [],
        "contacts_ids": null,
        "contacts_ids_internal": null,
        "linkedObjectsIds": null,
        "fk_project": null,
        "ref": "(PROV1)",
        "statut": "0",
        "status": "0",
        "mode_reglement_id": null,
        "cond_reglement_id": null,
        "multicurrency_code": "EUR",
        "model_pdf": "cornas",
        "last_main_doc": null,
        "note_public": "",
        "note_private": "",
        "total_ht": "0.00000000",
        "total_tva": "0.00000000",
        "total_ttc": "0.00000000",
        "lines": [],
        "civility_code": null,
        "date_creation": 1770736891,
        "date_validation": null,
        "user_creation_id": null,
        "user_validation_id": null,
        "totalpaid_multicurrency": null,
        "ref_supplier": "",
        "ref_fourn": null,
        "billed": "0",
        "socid": "22",
        "fourn_id": "22",
        "date": 1770736891,
        "date_valid": "",
        "date_approve": "",
        "date_approve2": "",
        "date_commande": "",
        "methode_commande_id": "0",
        "methode_commande": null,
        "delivery_date": "",
        "user_author_id": "1",
        "user_approve_id": null,
        "user_approve_id2": null
      },
      {
        "id": "2",
        "entity": "1",
        "array_options": [],
        "contacts_ids": null,
        "contacts_ids_internal": null,
        "linkedObjectsIds": null,
        "fk_project": "1",
        "ref": "PO2610-0001",
        "statut": "1",
        "status": "1",
        "mode_reglement_id": "2",
        "cond_reglement_id": "2",
        "multicurrency_code": "EUR",
        "model_pdf": "cornas",
        "last_main_doc": "fournisseur/commande/PO2610-0001/PO2610-0001.pdf",
        "note_public": "",
        "note_private": "",
        "total_ht": "100.00000000",
        "total_tva": "10.00000000",
        "total_ttc": "110.00000000",
        "lines": [
          {
            "id": "1",
            "array_options": {
              "options_soustotal_level": null,
              "options_soustotal_type": null,
              "options_soustotal_hidden": null,
              "options_soustotal_fk_free": null,
              "options_soustotal_always_shown": null,
              "options_soustotal_page_break": null
            },
            "contacts_ids_internal": null,
            "ref": "produit_1",
            "total_ht": "100.00000000",
            "total_tva": "10.00000000",
            "total_ttc": "110.00000000",
            "product_type": "0",
            "fk_product": "2",
            "desc": "<br>",
            "description": "<br>",
            "product_ref": "produit_1",
            "product_label": "produit 1",
            "product_custom_code": null,
            "qty": "10",
            "remise_percent": "0",
            "special_code": "0",
            "subprice": "10.00000000",
            "subprice_ttc": "11.00000000",
            "tva_tx": "10.0000",
            "fk_commande": "2",
            "rang": "1",
            "pu_ht": "10.00000000",
            "date_start": "",
            "date_end": "",
            "ref_supplier": "Aze",
            "ref_fourn": "Aze",
            "pu_ttc": "11.00000000"
          }
        ],
        "civility_code": null,
        "date_creation": 1793203889,
        "date_validation": null,
        "user_creation_id": null,
        "user_validation_id": "1",
        "totalpaid_multicurrency": null,
        "ref_supplier": "123456",
        "ref_fourn": null,
        "billed": "0",
        "socid": "2",
        "fourn_id": "2",
        "date": 1793203889,
        "date_valid": 1793203902,
        "date_approve": "",
        "date_approve2": "",
        "date_commande": "",
        "delivery_date": 1793142000,
        "cond_reglement_code": "30D",
        "mode_reglement_code": "VIR",
        "user_author_id": "1",
        "user_approve_id": null,
        "user_approve_id2": null
      }
    ]
    """
    let decoder = JSONDecoder()
    let orders = try decoder.decode([DolibarrSupplierOrder].self, from: Data(json.utf8))
    #expect(orders.count == 2)

    let draft = orders[0]
    #expect(draft.ref == "(PROV1)")
    #expect(draft.status == .draft)
    #expect(draft.thirdPartyId == "22")
    #expect(draft.pdfModel == "cornas")
    #expect(draft.dateCreation == 1770736891)
    #expect(draft.dateValidation == nil)
    #expect(draft.projectId == nil)
    #expect(draft.dateApproval == nil)
    #expect(draft.dateOrder == nil)
    #expect(draft.deliveryDate == nil)
    #expect(draft.userApproveId == nil)
    #expect(draft.lines.isEmpty)
    #expect(draft.orderMethodId == "0")
    #expect(draft.orderMethod == nil)

    let validated = orders[1]
    #expect(validated.ref == "PO2610-0001")
    #expect(validated.status == .validated)
    #expect(validated.supplierRef == "123456")
    #expect(validated.dateValidation == 1793203902)
    #expect(validated.deliveryDate == 1793142000)
    #expect(validated.paymentMethodId == "2")
    #expect(validated.paymentTermsId == "2")
    #expect(validated.lastMainDoc == "fournisseur/commande/PO2610-0001/PO2610-0001.pdf")
    #expect(validated.projectId == "1")
    #expect(validated.lines.count == 1)

    let line = validated.lines[0]
    #expect(line.supplierOrderId == "2")
    #expect(line.supplierProductRef == "Aze")
    #expect(line.productId == "2")
    #expect(line.quantity == "10")
    #expect(line.arrayOptions?.count == 6)
    #expect(line.arrayOptions?["soustotal_level"] != nil)

    let encoder = JSONEncoder()
    let redecoded = try decoder.decode([DolibarrSupplierOrder].self, from: encoder.encode(orders))
    #expect(redecoded == orders)
}

/// Live `GET /supplierorders/{id}` response from Dolibarr v23 (ordered order, with ordering method)
@Test func decodeLiveSupplierOrderV23Ordered() async throws {
    let json = """
    {
      "id": "2",
      "entity": "1",
      "array_options": [],
      "linkedObjectsIds": null,
      "fk_project": "1",
      "ref": "PO2610-0001",
      "statut": "3",
      "status": "3",
      "mode_reglement_id": "2",
      "cond_reglement_id": "2",
      "multicurrency_code": "EUR",
      "model_pdf": "cornas",
      "last_main_doc": "fournisseur/commande/PO2610-0001/PO2610-0001.pdf",
      "note_public": "",
      "note_private": "Commentaire: test",
      "total_ht": "100.00000000",
      "total_tva": "10.00000000",
      "total_ttc": "110.00000000",
      "lines": [],
      "date_creation": 1793203889,
      "user_validation_id": "1",
      "ref_supplier": "123456",
      "billed": "1",
      "socid": "2",
      "fourn_id": "2",
      "date": 1793228400,
      "date_valid": 1793266243,
      "date_approve": 1793267823,
      "date_approve2": "",
      "date_commande": 1793228400,
      "methode_commande_id": "5",
      "methode_commande": "En ligne",
      "delivery_date": 1793142000,
      "user_author_id": "1",
      "user_approve_id": "1",
      "user_approve_id2": null
    }
    """
    let decoder = JSONDecoder()
    let order = try decoder.decode(DolibarrSupplierOrder.self, from: Data(json.utf8))

    #expect(order.status == .supplierOrderSent)
    #expect(order.dateOrder == 1793228400)
    #expect(order.dateApproval == 1793267823)
    #expect(order.userApproveId == "1")
    #expect(order.billed == "1")
    #expect(order.orderMethodId == "5")
    #expect(order.orderMethod == "En ligne")
    #expect(order.projectId == "1")

    let copy = DolibarrSupplierOrder(copying: order)
    #expect(copy.orderMethodId == "5")
    #expect(copy.orderMethod == "En ligne")
    #expect(copy.projectId == "1")

    let encoder = JSONEncoder()
    let redecoded = try decoder.decode(DolibarrSupplierOrder.self, from: encoder.encode(order))
    #expect(redecoded == order)
    #expect(redecoded.orderMethodId == "5")
    #expect(redecoded.orderMethod == "En ligne")
    #expect(redecoded.projectId == "1")
}

/// `GET /setup/dictionary/ordering_methods` response (`rowid` as string or integer)
@Test func decodeOrderingMethods() async throws {
    let json = """
    [
        { "rowid": "1", "code": "OrderByMail", "label": "Courrier", "module": null },
        { "rowid": 5, "code": "OrderByWWW", "label": "En ligne", "module": null }
    ]
    """
    let decoder = JSONDecoder()
    let methods = try decoder.decode([DolibarrOrderingMethod].self, from: Data(json.utf8))

    #expect(methods.count == 2)
    #expect(methods[0] == DolibarrOrderingMethod(id: "1", code: "OrderByMail", label: "Courrier"))
    #expect(methods[1].id == "5")
    #expect(methods[1].code == "OrderByWWW")
    #expect(methods[1].label == "En ligne")
}

/// Live `GET /orders` response from Dolibarr v24 (`subprice` and `subprice_ttc` returned as numbers)
@Test func decodeLiveOrdersV24() async throws {
    let json = """
    [
      {
        "id": "1",
        "entity": "1",
        "import_key": null,
        "array_options": {
          "options_test": null,
          "options_onepagebasket_hide_documents": null
        },
        "array_languages": null,
        "contacts_ids": null,
        "contacts_ids_internal": null,
        "linkedObjectsIds": {
          "facture": {
            "2": "1",
            "18": "6",
            "24": "11"
          },
          "shipping": {
            "12": "1"
          },
          "propal": {
            "1": "2"
          }
        },
        "canvas": null,
        "fk_project": null,
        "contact_id": null,
        "user": null,
        "product": null,
        "origin_type": null,
        "origin_id": null,
        "ref": "CO2504-0001",
        "ref_ext": null,
        "statut": "3",
        "status": "3",
        "country_id": null,
        "country_code": null,
        "state_id": null,
        "region_id": null,
        "mode_reglement_id": null,
        "cond_reglement_id": "2",
        "demand_reason_id": null,
        "transport_mode_id": null,
        "shipping_method_id": null,
        "shipping_method": null,
        "multicurrency_code": "EUR",
        "multicurrency_tx": "1.00000000",
        "multicurrency_total_ht": "80.00000000",
        "multicurrency_total_tva": "0.00000000",
        "multicurrency_total_localtax1": null,
        "multicurrency_total_localtax2": null,
        "multicurrency_total_ttc": "80.00000000",
        "model_pdf": "eratosthene",
        "last_main_doc": "commande/CO2504-0001/CO2504-0001.pdf",
        "fk_account": null,
        "note_public": "",
        "note_private": "",
        "total_ht": "80.00000000",
        "total_tva": "0.00000000",
        "total_localtax1": "0.00000000",
        "total_localtax2": "0.00000000",
        "total_ttc": "80.00000000",
        "lines": [
          {
            "id": "1",
            "entity": null,
            "import_key": null,
            "array_options": {
              "options_soustotal_level": null,
              "options_soustotal_type": null,
              "options_soustotal_hidden": null,
              "options_soustotal_fk_free": null,
              "options_soustotal_always_shown": null,
              "options_soustotal_page_break": null
            },
            "array_languages": null,
            "contacts_ids": null,
            "contacts_ids_internal": null,
            "linkedObjectsIds": null,
            "canvas": null,
            "origin_type": null,
            "origin_id": null,
            "ref": "produit2",
            "ref_ext": "",
            "statut": null,
            "status": null,
            "multicurrency_tx": null,
            "multicurrency_total_ht": "80.00000000",
            "multicurrency_total_tva": "0.00000000",
            "multicurrency_total_ttc": "80.00000000",
            "last_main_doc": null,
            "total_ht": "80.00000000",
            "total_tva": "0.00000000",
            "total_localtax1": "0.00000000",
            "total_localtax2": "0.00000000",
            "total_ttc": "80.00000000",
            "lines": null,
            "specimen": 0,
            "extraparams": [],
            "rowid": "1",
            "weight_units": "0",
            "volume_units": "0",
            "product_type": "0",
            "fk_product": "3",
            "desc": "produit 1",
            "description": "produit 1",
            "product_ref": "produit2",
            "product_label": "produit 2",
            "product_desc": "produit 1",
            "product_custom_code": "",
            "fk_product_type": "0",
            "qty": "4",
            "remise_percent": "0",
            "info_bits": "0",
            "special_code": "0",
            "subprice": 20,
            "subprice_ttc": 0,
            "tva_tx": "0.0000",
            "multicurrency_subprice": "20.00000000",
            "multicurrency_subprice_ttc": "0.00000000",
            "libelle": "produit 2",
            "price": "20",
            "localtax1_tx": "0.0000",
            "localtax2_tx": "0.0000",
            "fk_commande": "1",
            "commande_id": "1",
            "rang": "1",
            "pa_ht": "0.00000000",
            "marge_tx": "",
            "marque_tx": 100,
            "date_start": "",
            "date_end": ""
          }
        ],
        "date_creation": 1743773588,
        "date_validation": 1743773595,
        "date_modification": 1773132910,
        "user_creation_id": "3",
        "user_validation_id": "3",
        "user_modification_id": "5",
        "specimen": 0,
        "extraparams": [],
        "socid": "2",
        "ref_client": null,
        "billed": "0",
        "cond_reglement_code": "30D",
        "date": 1743717600,
        "date_commande": 1743717600,
        "delivery_date": "",
        "source": "0",
        "signed_status": 0,
        "user_author_id": "3"
      }
    ]
    """
    let decoder = JSONDecoder()
    let orders = try decoder.decode([DolibarrOrder].self, from: Data(json.utf8))
    let order = try #require(orders.first)

    #expect(order.ref == "CO2504-0001")
    #expect(order.thirdPartyId == "2")
    #expect(order.totalExclTax == "80.00000000")
    #expect(order.projectId == nil)
    #expect(order.lines.count == 1)

    let line = order.lines[0]
    #expect(line.orderId == "1")
    #expect(line.quantity == "4")
    #expect(line.unitPriceExclTax == "20")
    #expect(line.unitPriceInclTax == "0")

    let encoder = JSONEncoder()
    let redecoded = try decoder.decode([DolibarrOrder].self, from: encoder.encode(orders))
    #expect(redecoded == orders)
}

@Test func warehousesDifferingInLabelAreNotEqual() async throws {
    let warehouse = DolibarrWarehouse(label: "Main", city: "Lyon", id: "3", statusCode: "1")
    let copy = DolibarrWarehouse(copying: warehouse)

    #expect(copy == warehouse)
    #expect(copy.hashValue == warehouse.hashValue)

    copy.label = "Annex"

    #expect(copy != warehouse)
    #expect(AnyHashable(copy) != AnyHashable(warehouse))
    #expect((copy as CommonBusinessObject) != (warehouse as CommonBusinessObject))
}

private func makeInvoice() -> DolibarrInvoice {
    DolibarrInvoice(
        date: 1700000000,
        lines: [DolibarrInvoiceLine(invoiceId: "5", quantity: "2", id: "51", rang: "1")],
        thirdPartyId: "7",
        statusCode: "1",
        ref: "FA2026-0001",
        totalExclTax: "100.00",
        id: "5"
    )
}

@Test func invoiceCopyIsEqualWithSameHash() async throws {
    let invoice = makeInvoice()
    let copy = DolibarrInvoice(copying: invoice)

    #expect(copy == invoice)
    #expect(copy.hashValue == invoice.hashValue)
    #expect(AnyHashable(copy) == AnyHashable(invoice))
}

@Test func invoicesDifferingInSubclassOrCommercialFieldsAreNotEqual() async throws {
    let invoice = makeInvoice()

    let paid = DolibarrInvoice(copying: invoice)
    paid.paidCode = "1"
    #expect(paid != invoice)
    #expect(AnyHashable(paid) != AnyHashable(invoice))
    #expect((paid as CommonBusinessObject) != (invoice as CommonBusinessObject))

    let renamed = DolibarrInvoice(copying: invoice)
    renamed.ref = "FA2026-0002"
    #expect(renamed != invoice)
    #expect((renamed as CommonBusinessObject) != (invoice as CommonBusinessObject))
}

@Test func linesDifferingInSubclassOrCommercialFieldsAreNotEqual() async throws {
    let line = DolibarrInvoiceLine(invoiceId: "5", quantity: "2", id: "51", rang: "1")
    let copy = DolibarrInvoiceLine(copying: line)

    #expect(copy == line)
    #expect(copy.hashValue == line.hashValue)

    let moved = DolibarrInvoiceLine(copying: line)
    moved.invoiceId = "6"
    #expect(moved != line)
    #expect(AnyHashable(moved) != AnyHashable(line))
    #expect((moved as CommonBusinessObjectLine) != (line as CommonBusinessObjectLine))

    let requantified = DolibarrInvoiceLine(copying: line)
    requantified.quantity = "3"
    #expect(requantified != line)

    let orderLine = DolibarrOrderLine(orderId: "8", quantity: "2", id: "81", rang: "1")
    let editedOrderLine = DolibarrOrderLine(copying: orderLine)
    editedOrderLine.orderId = "9"
    #expect(editedOrderLine != orderLine)
}

@Test func lineIsNotEqualToLineOfAnotherTypeWithSameFields() async throws {
    let invoiceLine = DolibarrInvoiceLine(id: "1", rang: "1")
    let orderLine = DolibarrOrderLine(id: "1", rang: "1")

    #expect((invoiceLine as CommonBusinessObjectLine) != (orderLine as CommonBusinessObjectLine))
}

@Test func categoriesWithSameIdButDifferentLabelAreNotEqual() async throws {
    let category = DolibarrCategory(id: "4", label: "Clients")
    let renamed = DolibarrCategory(id: "4", label: "Prospects")

    #expect(renamed != category)
    #expect(DolibarrCategory(id: "4", label: "Clients") == category)
}

/// `GET /categories` returns `type` and `fk_parent` as numbers or numeric strings, and `description` or `color` may be null
@Test func decodeCategories() async throws {
    let json = """
    [
        {
            "id": "4",
            "fk_parent": 0,
            "label": "Clothing",
            "description": "All clothes",
            "type": 0,
            "color": "ff0000"
        },
        {
            "id": "5",
            "fk_parent": "4",
            "label": "Women",
            "description": null,
            "type": "0",
            "color": null
        },
        {
            "id": "6",
            "fk_parent": 0,
            "label": "VIP"
        }
    ]
    """
    let categories = try JSONDecoder().decode([DolibarrCategory].self, from: Data(json.utf8))

    #expect(categories.count == 3)
    #expect(categories[0].parentId == 0)
    #expect(categories[0].type == 0)
    #expect(categories[0].color == "ff0000")
    #expect(categories[0].description == "All clothes")
    #expect(categories[1].parentId == 4)
    #expect(categories[1].type == 0)
    #expect(categories[1].description.isEmpty)
    #expect(categories[1].color.isEmpty)
    #expect(categories[2].type == nil)
}

@Test func encodeCategoryWithoutTypeAndWithClearableFields() async throws {
    let category = DolibarrCategory(id: "5", parentId: 4, label: "Women", description: "", type: 2, color: "")
    let data = try JSONEncoder().encode(category)
    let body = try #require(try JSONSerialization.jsonObject(with: data) as? [String: Any])

    // Dolibarr ignores type changes on update, so it is never sent
    #expect(body["type"] == nil)
    #expect(body["fk_parent"] as? Int == 4)
    #expect(body["label"] as? String == "Women")
    // Empty values are sent so they can be cleared
    #expect(body["description"] as? String == "")
    #expect(body["color"] as? String == "")
}

@Test func copiedCategoryIsEqualUntilEdited() async throws {
    let category = DolibarrCategory(id: "5", parentId: 4, label: "Women", description: "Clothes", type: 0, color: "00ff00")
    let edited = DolibarrCategory(copying: category)

    #expect(edited == category)
    edited.color = "0000ff"
    #expect(edited != category)
    category.copy(edited)
    #expect(category.color == "0000ff")
    #expect(category.type == 0)
}

@Test func objectStatusesDifferingInDomainAreNotEqual() async throws {
    var status = DolibarrObjectStatus.draft
    status.domain = .warehouse

    #expect(status != .draft)
    #expect(Set([status, .draft]).count == 2)
}

/// Live user permissions `categorie` node from Dolibarr v21
@Test func decodeCategoryUserPermissions() async throws {
    let json = """
    {
        "user": {
            "user": {"lire": 1},
            "self": {"creer": 1},
            "user_advance": {"readperms": 1},
            "self_advance": {"readperms": 1},
            "group_advance": {"read": 1}
        },
        "categorie": {
            "lire": 1,
            "creer": 1,
            "supprimer": 1
        }
    }
    """
    let decoder = JSONDecoder()
    let permissions = try decoder.decode(DolibarrUserPermissions.self, from: Data(json.utf8))
    let category = try #require(permissions.categorie)

    #expect(category.lire == 1)
    #expect(category.creer == 1)
    #expect(category.supprimer == 1)

    let encoder = JSONEncoder()
    let redecoded = try decoder.decode(DolibarrUserPermissions.self, from: encoder.encode(permissions))
    #expect(redecoded == permissions)
}

/// Live `GET /documents` response from Dolibarr v21 (supplier order, `db` object and server path removed)
@Test func decodeLiveDocumentsV21() async throws {
    let json = """
    [
      {
        "name": null,
        "path": "/var/www/documents/fournisseur/commande/PO2506-0001",
        "level1name": "PO2506-0001",
        "relativename": "PO2506-0001.pdf",
        "fullname": "/var/www/documents/fournisseur/commande/PO2506-0001/PO2506-0001.pdf",
        "date": 1749823249,
        "size": 8248,
        "type": "file",
        "module": null,
        "id": "4",
        "entity": "1",
        "error": null,
        "errors": [],
        "\\u0000CommonObject\\u0000validateFieldsErrors": [],
        "element": null,
        "array_options": [],
        "\\u0000CommonObject\\u0000linkedObjectsFullLoaded": [],
        "ref": "4",
        "description": "",
        "label": "d89621cbceecf537199642ec40f6ebd2",
        "filename": "PO2506-0001.pdf",
        "filepath": "fournisseur/commande/PO2506-0001",
        "fullpath_orig": "",
        "keywords": "",
        "content": null,
        "cover": null,
        "position": "1",
        "gen_or_uploaded": "generated",
        "date_c": 1749822350,
        "date_m": 1749823249,
        "fk_user_c": "1",
        "fk_user_m": "1",
        "acl": null,
        "src_object_type": "commande_fournisseur",
        "src_object_id": "1",
        "share": null
      }
    ]
    """
    let decoder = JSONDecoder()
    let documents = try decoder.decode([DolibarrDocument].self, from: Data(json.utf8))
    #expect(documents.count == 1)

    let document = documents[0]
    #expect(document.id == "4")
    #expect(document.name == nil)
    #expect(document.path == "/var/www/documents/fournisseur/commande/PO2506-0001")
    #expect(document.level1name == "PO2506-0001")
    #expect(document.relativename == "PO2506-0001.pdf")
    #expect(document.fullname == "/var/www/documents/fournisseur/commande/PO2506-0001/PO2506-0001.pdf")
    #expect(document.date == 1749823249)
    #expect(document.size == 8248)
    #expect(document.type == "file")
    #expect(document.filename == "PO2506-0001.pdf")
    #expect(document.filepath == "fournisseur/commande/PO2506-0001")
    #expect(document.genOrUploaded == "generated")
    #expect(document.srcObjectType == "commande_fournisseur")
    #expect(document.srcObjectId == "1")
    #expect(document.share == nil)
}

/// `GET /documents` response shape from Dolibarr v23 (dol_dir_list row merged with the ECM line)
@Test func decodeLiveDocumentsV23() async throws {
    let json = """
    [
      {
        "name": null,
        "path": "/var/www/documents/fournisseur/commande/PO2506-0001",
        "level1name": "PO2506-0001",
        "relativename": "PO2506-0001.pdf",
        "fullname": "/var/www/documents/fournisseur/commande/PO2506-0001/PO2506-0001.pdf",
        "date": 1749823249,
        "size": 8248,
        "type": "file",
        "id": "4",
        "ref": "4",
        "label": "d89621cbceecf537199642ec40f6ebd2",
        "filename": "PO2506-0001.pdf",
        "filepath": "fournisseur/commande/PO2506-0001",
        "position": "1",
        "gen_or_uploaded": "generated",
        "date_c": 1749822350,
        "src_object_type": "commande_fournisseur",
        "src_object_id": "1",
        "share": null,
        "content-type": "application/pdf"
      }
    ]
    """
    let decoder = JSONDecoder()
    let document = try #require(try decoder.decode([DolibarrDocument].self, from: Data(json.utf8)).first)

    #expect(document.id == "4")
    #expect(document.filename == "PO2506-0001.pdf")
    #expect(document.filepath == "fournisseur/commande/PO2506-0001")
    #expect(document.genOrUploaded == "generated")
    #expect(document.srcObjectType == "commande_fournisseur")
    #expect(document.srcObjectId == "1")
}

/// Live `GET /documents` response from Dolibarr v24 (supplier order, no `id`, `path`, `fullname` or `src_object_*`)
@Test func decodeLiveDocumentsV24() async throws {
    let json = """
    [
      {
        "name": "PO2610-0005.pdf",
        "level1name": "PO2610-0005",
        "relativename": "PO2610-0005.pdf",
        "date": 1793380987,
        "size": 19673,
        "type": "file",
        "ref": "136",
        "label": "299f507314c0e063aa90056eee746a08",
        "filepath": "fournisseur/commande/PO2610-0005",
        "filename": "PO2610-0005.pdf",
        "fullpath_orig": "",
        "position": "1",
        "gen_or_uploaded": "generated",
        "description": null,
        "keywords": "",
        "cover": null,
        "share": null,
        "date_c": 1793380987,
        "agenda_id": null,
        "fk_user_c": "1",
        "fk_user_m": null,
        "note_private": null,
        "note_public": null,
        "content-type": "application/pdf"
      }
    ]
    """
    let decoder = JSONDecoder()
    let documents = try decoder.decode([DolibarrDocument].self, from: Data(json.utf8))
    #expect(documents.count == 1)

    let document = documents[0]
    #expect(document.id == "136")
    #expect(document.name == "PO2610-0005.pdf")
    #expect(document.path == "")
    #expect(document.level1name == "PO2610-0005")
    #expect(document.relativename == "PO2610-0005.pdf")
    #expect(document.fullname == "")
    #expect(document.date == 1793380987)
    #expect(document.size == 19673)
    #expect(document.type == "file")
    #expect(document.filename == "PO2610-0005.pdf")
    #expect(document.filepath == "fournisseur/commande/PO2610-0005")
    #expect(document.genOrUploaded == "generated")
    #expect(document.srcObjectType == "")
    #expect(document.srcObjectId == "")
    #expect(document.share == nil)
}

/// `GET /documents` response shape from Dolibarr develop (v24 shape plus `date_creation`)
@Test func decodeDocumentsDevelop() async throws {
    let json = """
    [
      {
        "name": "PO2610-0005.pdf",
        "level1name": "PO2610-0005",
        "relativename": "PO2610-0005.pdf",
        "date": 1793380987,
        "size": 19673,
        "type": "file",
        "ref": "136",
        "filepath": "fournisseur/commande/PO2610-0005",
        "filename": "PO2610-0005.pdf",
        "gen_or_uploaded": "generated",
        "share": null,
        "date_c": 1793380987,
        "date_creation": 1793380987,
        "content-type": "application/pdf"
      }
    ]
    """
    let decoder = JSONDecoder()
    let document = try #require(try decoder.decode([DolibarrDocument].self, from: Data(json.utf8)).first)

    #expect(document.id == "136")
    #expect(document.filename == "PO2610-0005.pdf")
}

/// `GET /documents` item for a file without an ECM entry (dol_dir_list fields only)
@Test func decodeDocumentWithoutEcmRow() async throws {
    let json = """
    {
        "name": "photo.jpg",
        "level1name": "PO2610-0005",
        "relativename": "photo.jpg",
        "date": 1793380987,
        "size": 1024,
        "type": "file"
    }
    """
    let decoder = JSONDecoder()
    let document = try decoder.decode(DolibarrDocument.self, from: Data(json.utf8))

    #expect(document.id == "PO2610-0005/photo.jpg")
    #expect(document.filename == "photo.jpg")
    #expect(document.filepath == "")
    #expect(document.genOrUploaded == "")
    #expect(document.path == "")
    #expect(document.fullname == "")
    #expect(document.srcObjectType == "")
}

/// `GET /documents` item from Dolibarr v24 with the ECM rowid `ref` returned as a number
@Test func decodeDocumentWithNumericRef() async throws {
    let json = """
    {
        "name": "PO2610-0005.pdf",
        "level1name": "PO2610-0005",
        "relativename": "PO2610-0005.pdf",
        "date": 1793380987,
        "size": 19673,
        "type": "file",
        "ref": 136,
        "filepath": "fournisseur/commande/PO2610-0005",
        "filename": "PO2610-0005.pdf"
    }
    """
    let decoder = JSONDecoder()
    let document = try decoder.decode(DolibarrDocument.self, from: Data(json.utf8))

    #expect(document.id == "136")
}

/// `GET /documents` response from Dolibarr v24 mixing a file with and a file without an ECM entry
@Test func decodeMixedDocumentList() async throws {
    let json = """
    [
      {
        "name": "PO2610-0005.pdf",
        "level1name": "PO2610-0005",
        "relativename": "PO2610-0005.pdf",
        "date": 1793380987,
        "size": 19673,
        "type": "file",
        "ref": "136",
        "filepath": "fournisseur/commande/PO2610-0005",
        "filename": "PO2610-0005.pdf",
        "gen_or_uploaded": "generated"
      },
      {
        "name": "photo.jpg",
        "level1name": "PO2610-0005",
        "relativename": "photo.jpg",
        "date": 1793380990,
        "size": 1024,
        "type": "file"
      }
    ]
    """
    let decoder = JSONDecoder()
    let documents = try decoder.decode([DolibarrDocument].self, from: Data(json.utf8))

    #expect(documents.count == 2)
    #expect(documents[0].id == "136")
    #expect(documents[1].id == "PO2610-0005/photo.jpg")
    #expect(documents[0] != documents[1])
}

@Test func decodeDocumentMissingRequiredKeyFails() async throws {
    let json = """
    {
        "name": "photo.jpg",
        "level1name": "PO2610-0005",
        "relativename": "photo.jpg",
        "date": 1793380987,
        "type": "file"
    }
    """
    let decoder = JSONDecoder()
    #expect(throws: DecodingError.self) {
        try decoder.decode(DolibarrDocument.self, from: Data(json.utf8))
    }
}

@Test func documentsWithSameFilenameInDifferentObjectsAreNotEqual() async throws {
    let first = """
    {"name": "photo.jpg", "level1name": "PO2610-0005", "relativename": "photo.jpg", "date": 1793380987, "size": 1024, "type": "file"}
    """
    let second = """
    {"name": "photo.jpg", "level1name": "PO2610-0006", "relativename": "photo.jpg", "date": 1793380987, "size": 1024, "type": "file"}
    """
    let decoder = JSONDecoder()
    let firstDocument = try decoder.decode(DolibarrDocument.self, from: Data(first.utf8))
    let secondDocument = try decoder.decode(DolibarrDocument.self, from: Data(second.utf8))

    #expect(firstDocument != secondDocument)
}

/// `fk_project` returned as a string or number, with `null`, missing, empty and zero values meaning no project
@Test(arguments: [
    (#""fk_project": "12","#, "12" as String?),
    (#""fk_project": 12,"#, "12"),
    (#""fk_project": null,"#, nil),
    ("", nil),
    (#""fk_project": "","#, nil),
    (#""fk_project": "0","#, nil),
    (#""fk_project": 0,"#, nil)
])
func decodeProjectId(field: String, expected: String?) async throws {
    let json = """
    { \(field) "id": "3", "label": "Main" }
    """
    let warehouse = try JSONDecoder().decode(DolibarrWarehouse.self, from: Data(json.utf8))

    #expect(warehouse.projectId == expected)
}

@Test func commercialTransactionsPassProjectIdToSuperclass() async throws {
    #expect(DolibarrQuote(projectId: "7").projectId == "7")
    #expect(DolibarrOrder(projectId: "7").projectId == "7")
    #expect(DolibarrInvoice(projectId: "7").projectId == "7")
    #expect(DolibarrSupplierOrder(projectId: "7").projectId == "7")
    #expect(DolibarrSupplierInvoice(projectId: "7").projectId == "7")
}

@Test func commercialTransactionProjectIdRoundTrip() async throws {
    let order = DolibarrSupplierOrder(thirdPartyId: "2", ref: "PO2610-0001", projectId: "7", id: "1")
    let data = try JSONEncoder().encode(order)
    let encoded = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])

    #expect(encoded["fk_project"] as? String == "7")
    #expect(try JSONDecoder().decode(DolibarrSupplierOrder.self, from: data) == order)
    #expect(DolibarrSupplierOrder(copying: order).projectId == "7")
    #expect(order != DolibarrSupplierOrder(thirdPartyId: "2", ref: "PO2610-0001", projectId: "8", id: "1"))
}

@Test func agendaEventProjectIdRoundTrip() async throws {
    let json = """
    {
        "id": "1", "ref": "1", "label": "Call", "percentage": "0", "fulldayevent": "0",
        "datep": 1793228400, "datef": 1793232000, "fk_project": 7
    }
    """
    let decoder = JSONDecoder()
    let event = try decoder.decode(DolibarrAgendaEvent.self, from: Data(json.utf8))

    #expect(event.projectId == "7")
    #expect(DolibarrAgendaEvent(copying: event).projectId == "7")

    let redecoded = try decoder.decode(DolibarrAgendaEvent.self, from: JSONEncoder().encode(event))
    #expect(redecoded == event)

    let other = DolibarrAgendaEvent(copying: event)
    other.projectId = "8"
    #expect(other != event)
}

@Test func warehouseProjectIdRoundTrip() async throws {
    let warehouse = DolibarrWarehouse(label: "Main", projectId: "7", id: "3", statusCode: "1")
    let redecoded = try JSONDecoder().decode(DolibarrWarehouse.self, from: JSONEncoder().encode(warehouse))

    #expect(redecoded.projectId == "7")
    #expect(redecoded == warehouse)
    #expect(DolibarrWarehouse(copying: warehouse).projectId == "7")
    #expect(warehouse != DolibarrWarehouse(label: "Main", projectId: "8", id: "3", statusCode: "1"))
}

@Test func interventionAndTaskDecodeNumericProjectId() async throws {
    let interventionJson = """
    { "id": "1", "socid": "2", "ref": "FI2504-0001", "lines": [], "fk_project": 7 }
    """
    let taskJson = """
    { "id": "1", "ref": "TK1", "label": "Build", "fk_project": 7, "fk_task_parent": "0" }
    """
    let decoder = JSONDecoder()

    #expect(try decoder.decode(DolibarrIntervention.self, from: Data(interventionJson.utf8)).projectId == "7")
    #expect(try decoder.decode(DolibarrTask.self, from: Data(taskJson.utf8)).projectId == "7")
}

@Test func commercialTransactionsPassRefToSuperclass() async throws {
    #expect(DolibarrQuote(ref: "PR2504-0001").ref == "PR2504-0001")
    #expect(DolibarrOrder(ref: "CO2504-0001").ref == "CO2504-0001")
    #expect(DolibarrInvoice(ref: "FA2504-0001").ref == "FA2504-0001")
    #expect(DolibarrSupplierOrder(ref: "PO2610-0001").ref == "PO2610-0001")
    #expect(DolibarrSupplierInvoice(ref: "SI2504-0001").ref == "SI2504-0001")
}

// MARK: - Contracts

@Test func decodeContract() async throws {
    let json = """
    {
        "id": "12",
        "socid": "26",
        "ref": "CT2610-0012",
        "status": 2,
        "total_ht": 90.5,
        "total_tva": 18.1,
        "total_ttc": 108.6,
        "fk_project": "4",
        "fk_contract_type": 1,
        "date_contrat": "1792101600",
        "date_validation": "",
        "ref_customer": "CUST-1",
        "ref_supplier": "SUP-1",
        "signed_status": 0,
        "commercial_signature_id": 3,
        "commercial_suivi_id": "0",
        "nbofservices": "2",
        "nbofservicesclosed": 0,
        "lines": [{
            "id": "1",
            "rang": "1",
            "fk_contrat": 12,
            "statut": "5",
            "tva_tx": 20,
            "subprice": 100,
            "remise_percent": 10,
            "total_ht": 90.5,
            "total_tva": 18.1,
            "total_ttc": 108.6,
            "fk_product": 38,
            "qty": 1,
            "desc": "Maintenance",
            "date_start": 1792101600,
            "date_end_real": "1792144800",
            "fk_user_cloture": 3,
            "fk_unit": "0",
            "commentaire": "Done"
        }]
    }
    """
    let decoder = JSONDecoder()
    let contract = try decoder.decode(DolibarrContract.self, from: Data(json.utf8))
    let line = try #require(contract.lines.first)

    #expect(contract.thirdPartyId == "26")
    #expect(contract.status == .contractClosed)
    #expect(contract.totalExclTax == "90.5")
    #expect(contract.projectId == "4")
    #expect(contract.contractType == "1")
    #expect(contract.dateContract == 1792101600)
    #expect(contract.dateContracted == Date(timeIntervalSince1970: 1792101600))
    #expect(contract.dateValidation == nil)
    #expect(contract.customerRef == "CUST-1")
    #expect(contract.supplierRef == "SUP-1")
    #expect(contract.signedStatus == "0")
    #expect(contract.salesSignatureUserId == "3")
    #expect(contract.salesFollowUpUserId == nil)
    #expect(contract.serviceCount == 2)
    #expect(contract.servicesClosedCount == 0)

    #expect(line.contractId == "12")
    #expect(line.status == .contractLineClosed)
    #expect(line.specialCode == "0")
    #expect(line.taxRate == "20")
    #expect(line.discountRate == "10")
    #expect(line.productId == "38")
    #expect(line.quantity == "1")
    #expect(line.description == "Maintenance")
    #expect(line.dateStarted == Date(timeIntervalSince1970: 1792101600))
    #expect(line.dateEndReal == 1792144800)
    #expect(line.userCloseId == "3")
    #expect(line.unitId == nil)
    #expect(line.comment == "Done")

    let redecoded = try decoder.decode(DolibarrContract.self, from: JSONEncoder().encode(contract))
    #expect(redecoded == contract)
}

/// Live contract list from Dolibarr v24, trimmed to mapped and representative keys
@Test func decodeLiveContractsV24() async throws {
    let json = """
    [{
        "id": "1", "entity": "1", "import_key": null, "array_options": [], "array_languages": null,
        "contacts_ids": null, "contacts_ids_internal": null, "linkedObjectsIds": null, "fk_project": null,
        "ref": "CT2610-0001", "ref_ext": null, "statut": "1", "status": "1", "multicurrency_code": null,
        "model_pdf": null, "last_main_doc": "contract/(PROV1)/(PROV1).pdf", "note_public": null, "note_private": null,
        "total_ht": 0, "total_tva": 0, "total_localtax1": null, "total_localtax2": null, "total_ttc": 0,
        "lines": [{
            "id": "1", "entity": null, "import_key": null, "array_options": [], "ref": "S500", "statut": "4", "status": "4",
            "total_ht": "0.00000000", "total_tva": "0.00000000", "total_localtax1": "0.00000000",
            "total_localtax2": "0.00000000", "total_ttc": "0.00000000", "lines": null, "date_creation": null,
            "rowid": null, "fk_unit": null, "date_debut_prevue": null, "product_type": "1", "fk_product": "38",
            "desc": "", "description": "", "product_ref": "S500", "product_label": "Serv 500", "product_desc": "",
            "qty": "1", "remise_percent": "0", "info_bits": "0", "special_code": null, "subprice": "0.00000000",
            "subprice_ttc": null, "tva_tx": "0.0000", "fk_contrat": "1", "type": "1", "label": null,
            "date_commande": null, "date_start": "", "date_start_real": 1792144800, "date_end": "", "date_end_real": "",
            "vat_src_code": null, "fk_user_author": "0", "fk_user_ouverture": "3", "fk_user_cloture": null,
            "commentaire": null, "rang": "1"
        }],
        "date_creation": 1792101600, "date_validation": null, "date_modification": null, "tms": null,
        "extraparams": null, "ref_customer": null, "from": null, "ref_supplier": null, "socid": "26", "fk_soc": "26",
        "fk_user_author": null, "user_author_id": "3", "date_contrat": 1792101600, "commercial_signature_id": "3",
        "fk_commercial_signature": null, "commercial_suivi_id": "3", "fk_commercial_suivi": null, "nbofservices": 1,
        "nbofserviceswait": 0, "nbofservicesopened": 1, "nbofservicesexpired": 0, "nbofservicesclosed": 0,
        "signed_status": "0"
    }]
    """
    let decoder = JSONDecoder()
    let contracts = try decoder.decode([DolibarrContract].self, from: Data(json.utf8))
    let contract = try #require(contracts.first)
    let line = try #require(contract.lines.first)

    #expect(contract.ref == "CT2610-0001")
    #expect(contract.statusCode == "1")
    #expect(contract.status == .validated)
    #expect(contract.thirdPartyId == "26")
    #expect(contract.totalExclTax == "0")
    #expect(contract.totalTax == "0")
    #expect(contract.totalInclTax == "0")
    #expect(contract.projectId == nil)
    #expect(contract.arrayOptions == nil)
    #expect(contract.dateCreation == contract.dateContract)
    #expect(contract.userAuthorId == "3")
    #expect(contract.servicesOpenCount == 1)

    #expect(line.status == .contractLineOpen)
    #expect(line.specialCode == "0")
    #expect(line.dateStart == nil)
    #expect(line.dateStartReal == 1792144800)
    #expect(line.dateEnd == nil)
    #expect(line.userOpenId == "3")
    #expect(line.productRef == "S500")

    let redecoded = try decoder.decode([DolibarrContract].self, from: JSONEncoder().encode(contracts))
    #expect(redecoded == contracts)
}

/// Live contract list from Dolibarr v21, trimmed to mapped and representative keys
@Test func decodeLiveContractsV21() async throws {
    let json = """
    [{
        "module": null, "id": "1", "entity": "1", "import_key": null,
        "array_options": {
            "options_label": null,
            "options_trainingsession_type": "1",
            "options_trainingsession_location": "Centre",
            "options_trainingsession_opco_financing": null
        },
        "contacts_ids": null, "linkedObjectsIds": null, "fk_project": null, "ref": "CT2603-0001", "statut": "1",
        "status": "1", "multicurrency_code": null, "last_main_doc": "contract/CT2603-0001/CT2603-0001.pdf",
        "note_public": null, "note_private": null, "total_ht": 90, "total_tva": 18, "total_localtax1": null,
        "total_localtax2": null, "total_ttc": 108,
        "lines": [{
            "module": null, "id": "2", "entity": null, "array_options": [], "ref": "entretien", "statut": "4", "status": "4",
            "total_ht": "90.00000000", "total_tva": "18.00000000", "total_localtax1": "0.00000000",
            "total_localtax2": "0.00000000", "total_ttc": "108.00000000", "lines": null, "fk_unit": null,
            "product_type": "1", "fk_product": "4", "desc": "", "description": "", "product_ref": "entretien",
            "product_label": "entretien", "qty": "1", "remise_percent": "10", "special_code": null,
            "subprice": "100.00000000", "tva_tx": "20.0000", "fk_contrat": "1", "date_start": "",
            "date_start_real": 1772492400, "date_end": "", "date_end_real": "", "vat_src_code": "", "price": "100",
            "fk_user_author": "0", "fk_user_ouverture": "1", "fk_user_cloture": null, "commentaire": null, "rang": "1"
        }],
        "date_creation": 1772492400, "date_validation": null, "ref_customer": null, "ref_supplier": null, "socid": "2",
        "fk_soc": "2", "user_author_id": "1", "date_contrat": 1772492400, "commercial_signature_id": "1",
        "commercial_suivi_id": "1", "nbofservices": 1, "nbofserviceswait": 0, "nbofservicesopened": 1,
        "nbofservicesexpired": 0, "nbofservicesclosed": 0, "signed_status": "0"
    }]
    """
    let decoder = JSONDecoder()
    let contracts = try decoder.decode([DolibarrContract].self, from: Data(json.utf8))
    let contract = try #require(contracts.first)
    let line = try #require(contract.lines.first)

    #expect(contract.totalExclTax == "90")
    #expect(contract.totalTax == "18")
    #expect(contract.totalInclTax == "108")
    #expect(contract.pdfModel == nil)
    #expect(contract.arrayOptions?["trainingsession_type"] == .string("1"))
    #expect(contract.arrayOptions?["trainingsession_location"] == .string("Centre"))
    #expect(contract.arrayOptions?["options_trainingsession_type"] == nil)

    #expect(line.id == "2")
    #expect(line.discountRate == "10")
    #expect(line.unitPriceExclTax == "100.00000000")
    #expect(line.unitPriceInclTax == nil)
    #expect(line.taxRate == "20.0000")
    #expect(line.totalInclTax == "108.00000000")
    #expect(line.dateStartReal == 1772492400)

    let redecoded = try decoder.decode([DolibarrContract].self, from: JSONEncoder().encode(contracts))
    #expect(redecoded == contracts)
}

@Test func decodeContractWithoutLines() async throws {
    let json = """
    { "id": "1", "socid": "26", "ref": "CT1", "status": "0", "total_ht": 0, "total_tva": 0, "total_ttc": 0 }
    """
    let contract = try JSONDecoder().decode(DolibarrContract.self, from: Data(json.utf8))

    #expect(contract.lines.isEmpty)
    #expect(contract.status == .draft)
}

@Test func contractLineFallsBackToDescriptionKey() async throws {
    let json = """
    {
        "id": "1", "rang": "1", "fk_contrat": "1", "status": "0", "tva_tx": "0", "subprice": "0",
        "remise_percent": "0", "total_ht": "0", "total_tva": "0", "total_ttc": "0",
        "description": "Support"
    }
    """
    let line = try JSONDecoder().decode(DolibarrContractLine.self, from: Data(json.utf8))

    #expect(line.description == "Support")
    #expect(line.status == .contractLineInactive)
}

@Test func contractAndLineStatusesUseTheirOwnCodes() async throws {
    #expect(DolibarrContract(statusCode: "0").status == .draft)
    #expect(DolibarrContract(statusCode: "1").status == .validated)
    #expect(DolibarrContract(statusCode: "2").status == .contractClosed)
    #expect(DolibarrContract(statusCode: "4").status == .unknown)

    #expect(DolibarrContractLine(statusCode: "0").status == .contractLineInactive)
    #expect(DolibarrContractLine(statusCode: "4").status == .contractLineOpen)
    #expect(DolibarrContractLine(statusCode: "5").status == .contractLineClosed)
    #expect(DolibarrContractLine(statusCode: "1").status == .unknown)
}

private func makeContract() -> DolibarrContract {
    DolibarrContract(
        lines: [DolibarrContractLine(contractId: "5", statusCode: "4", quantity: "1", id: "51", rang: "1")],
        dateContract: 1700000000,
        thirdPartyId: "7",
        statusCode: "1",
        ref: "CT2026-0001",
        projectId: "3",
        linkedObjectsIds: ["commande": ["1": "2"]],
        id: "5"
    )
}

@Test func contractCopyIsEqualWithSameHash() async throws {
    let contract = makeContract()
    let copy = DolibarrContract(copying: contract)

    #expect(copy == contract)
    #expect(copy.hashValue == contract.hashValue)
    #expect(AnyHashable(copy) == AnyHashable(contract))
    #expect(copy.ref == "CT2026-0001")
    #expect(copy.projectId == "3")

    let target = DolibarrContract()
    target.copy(contract)
    #expect(target == contract)
}

@Test func contractsDifferingInSubclassOrCommercialFieldsAreNotEqual() async throws {
    let contract = makeContract()

    let redated = DolibarrContract(copying: contract)
    redated.dateContract = 1700000001
    #expect(redated != contract)
    #expect(AnyHashable(redated) != AnyHashable(contract))
    #expect((redated as CommonBusinessObject) != (contract as CommonBusinessObject))

    let renamed = DolibarrContract(copying: contract)
    renamed.ref = "CT2026-0002"
    #expect(renamed != contract)
    #expect((renamed as CommonBusinessObject) != (contract as CommonBusinessObject))
}

@Test func contractLinesDifferingInSubclassOrCommercialFieldsAreNotEqual() async throws {
    let line = DolibarrContractLine(contractId: "5", statusCode: "4", quantity: "1", id: "51", rang: "1")
    let copy = DolibarrContractLine(copying: line)

    #expect(copy == line)
    #expect(copy.hashValue == line.hashValue)

    let closed = DolibarrContractLine(copying: line)
    closed.statusCode = "5"
    #expect(closed != line)
    #expect(AnyHashable(closed) != AnyHashable(line))
    #expect((closed as CommonBusinessObjectLine) != (line as CommonBusinessObjectLine))

    let requantified = DolibarrContractLine(copying: line)
    requantified.quantity = "3"
    #expect(requantified != line)

    let orderLine = DolibarrOrderLine(id: "51", rang: "1")
    #expect((DolibarrContractLine(id: "51", rang: "1") as CommonBusinessObjectLine) != (orderLine as CommonBusinessObjectLine))
}

@Test func commercialLinesDecodeNumericFieldsAndMissingSpecialCode() async throws {
    let json = """
    {
        "id": "1", "rang": "1", "fk_commande": "8", "tva_tx": 20, "subprice": 100, "remise_percent": 10.5,
        "total_ht": 90, "total_tva": 18, "total_ttc": 108, "fk_product": 38, "qty": 2
    }
    """
    let line = try JSONDecoder().decode(DolibarrOrderLine.self, from: Data(json.utf8))

    #expect(line.specialCode == "0")
    #expect(line.taxRate == "20")
    #expect(line.discountRate == "10.5")
    #expect(line.totalExclTax == "90")
    #expect(line.totalTax == "18")
    #expect(line.totalInclTax == "108")
    #expect(line.productId == "38")
    #expect(line.quantity == "2")
}

@Test func commercialTransactionsExposeLinkedContractIds() async throws {
    let order = DolibarrOrder()
    order.linkedObjectsIds = ["contrat": ["3": "1"]]

    #expect(order.linkedContractIds == ["3": "1"])
    #expect(DolibarrOrder().linkedContractIds == nil)
}

@Test func decodeContractUserPermissions() async throws {
    let json = """
    {
        "user": {
            "user": {"lire": 1},
            "self": {"creer": 1},
            "user_advance": {"readperms": 1},
            "self_advance": {"readperms": 1},
            "group_advance": {"read": 1}
        },
        "contrat": {
            "lire": 1,
            "creer": 1,
            "activer": 1,
            "desactiver": 1,
            "supprimer": 1
        }
    }
    """
    let decoder = JSONDecoder()
    let permissions = try decoder.decode(DolibarrUserPermissions.self, from: Data(json.utf8))
    let contract = try #require(permissions.contrat)

    #expect(contract.lire == 1)
    #expect(contract.creer == 1)
    #expect(contract.activer == 1)
    #expect(contract.desactiver == 1)
    #expect(contract.supprimer == 1)

    let redecoded = try decoder.decode(DolibarrUserPermissions.self, from: JSONEncoder().encode(permissions))
    #expect(redecoded == permissions)
}

/// `GET /setup/dictionary/availability` response (`rowid` as string or integer)
@Test func decodeAvailabilities() async throws {
    let json = """
    [
        { "rowid": "1", "code": "AV_1D", "label": "1 jour", "type_duration": "d", "qty": "1" },
        { "rowid": 7, "code": "AV_2W", "label": "2 semaines", "type_duration": "w", "qty": "2" }
    ]
    """
    let availabilities = try JSONDecoder().decode([DolibarrAvailability].self, from: Data(json.utf8))

    #expect(availabilities.count == 2)
    #expect(availabilities[0] == DolibarrAvailability(id: "1", code: "AV_1D", label: "1 jour"))
    #expect(availabilities[1] == DolibarrAvailability(id: "7", code: "AV_2W", label: "2 semaines"))
}

/// `GET /setup/dictionary/ordering_origins` response (`rowid` as string or integer)
@Test func decodeBusinessOrigins() async throws {
    let json = """
    [
        { "rowid": "1", "code": "SRC_INTE", "label": "Site web" },
        { "rowid": 5, "code": "SRC_COMM", "label": "Contact commercial" }
    ]
    """
    let origins = try JSONDecoder().decode([DolibarrBusinessOrigin].self, from: Data(json.utf8))

    #expect(origins.count == 2)
    #expect(origins[0] == DolibarrBusinessOrigin(id: "1", code: "SRC_INTE", label: "Site web"))
    #expect(origins[1] == DolibarrBusinessOrigin(id: "5", code: "SRC_COMM", label: "Contact commercial"))
}

/// `GET /thirdparties/{id}/representatives?mode=0` response (full user objects, null first name)
@Test func decodeRepresentatives() async throws {
    let json = """
    [
        { "id": "1", "login": "admin", "lastname": "Mead", "firstname": "William", "email": "admin@example.com" },
        { "id": 2, "login": "sales", "lastname": "Sales", "firstname": null }
    ]
    """
    let representatives = try JSONDecoder().decode([DolibarrRepresentative].self, from: Data(json.utf8))

    #expect(representatives.count == 2)
    #expect(representatives[0] == DolibarrRepresentative(id: "1", lastname: "Mead", firstname: "William"))
    #expect(representatives[1] == DolibarrRepresentative(id: "2", lastname: "Sales", firstname: ""))
}

/// `GET /documents/download` response
@Test func decodeDownloadedDocument() async throws {
    let json = """
    {
        "filename": "PR2401-0001.pdf",
        "content-type": "application/pdf",
        "filesize": 5,
        "content": "SGVsbG8=",
        "encoding": "base64"
    }
    """
    let document = try JSONDecoder().decode(DolibarrDownloadedDocument.self, from: Data(json.utf8))

    #expect(document.filename == "PR2401-0001.pdf")
    #expect(document.contentType == "application/pdf")
    #expect(document.filesize == 5)
    #expect(document.encoding == "base64")
    #expect(document.data == Data("Hello".utf8))
}

/// `GET /documents/download` response missing the content type fails to decode
@Test func decodeDownloadedDocumentMissingContentTypeFails() async throws {
    let json = """
    { "filename": "a.pdf", "filesize": 0, "content": "", "encoding": "base64" }
    """
    #expect(throws: DecodingError.self) {
        try JSONDecoder().decode(DolibarrDownloadedDocument.self, from: Data(json.utf8))
    }
}

/// `GET /lareponse/articles/{id}/token` response
@Test func decodeLaReponseArticleToken() async throws {
    let json = """
    { "id": 12, "publish_token": "a1b2c3" }
    """
    let token = try JSONDecoder().decode(LaReponseArticleToken.self, from: Data(json.utf8))

    #expect(token == LaReponseArticleToken(id: 12, publishToken: "a1b2c3"))
}

/// `GET /setup/company` response from Dolibarr 18 (no currency code, int IDs, empty values)
@Test func decodeOrganizationV18() async throws {
    let json = """
    {
        "module": "societe",
        "id": 0,
        "entity": 1,
        "name": "Doli Test 18",
        "address": "1 rue de la Paix",
        "zip": "75002",
        "town": "Paris",
        "state_id": 12,
        "state_code": "75",
        "country_id": 1,
        "country_code": "FR",
        "phone": "",
        "email": "contact@example.com",
        "tva_intra": "FR12345678901",
        "socialnetworks": [],
        "logo": "logo.png",
        "logo_small": "logo_small.png",
        "logo_mini": "",
        "logo_squarred": "",
        "logo_squarred_small": "",
        "logo_squarred_mini": ""
    }
    """
    let organization = try JSONDecoder().decode(DolibarrOrganization.self, from: Data(json.utf8))

    #expect(organization.name == "Doli Test 18")
    #expect(organization.stateId == "12")
    #expect(organization.countryId == "1")
    #expect(organization.currencyCode == nil)
    #expect(organization.phone == nil)
    #expect(organization.vatNumber == "FR12345678901")
    #expect(organization.logoMini == nil)
    #expect(organization.preferredLogoOriginalFile == "logos/thumbs/logo_small.png")
}

/// `GET /setup/company` live response from Dolibarr 22 without a logo
@Test func decodeOrganizationV22() async throws {
    let json = """
    {
      "module": "societe",
      "id": 0,
      "entity": 1,
      "import_key": null,
      "array_options": [],
      "array_languages": null,
      "contacts_ids": null,
      "contacts_ids_internal": null,
      "linkedObjectsIds": null,
      "canvas": null,
      "fk_project": null,
      "user": null,
      "origin_type": null,
      "origin_id": null,
      "ref": null,
      "ref_ext": null,
      "statut": null,
      "status": 1,
      "country_id": 1,
      "country_code": "FR",
      "state_id": 0,
      "region_id": null,
      "barcode_type": null,
      "barcode_type_coder": null,
      "mode_reglement_id": null,
      "cond_reglement_id": null,
      "demand_reason_id": null,
      "transport_mode_id": null,
      "shipping_method_id": null,
      "shipping_method": null,
      "fk_multicurrency": null,
      "multicurrency_code": null,
      "multicurrency_tx": null,
      "multicurrency_total_ht": null,
      "multicurrency_total_tva": null,
      "multicurrency_total_localtax1": null,
      "multicurrency_total_localtax2": null,
      "multicurrency_total_ttc": null,
      "last_main_doc": null,
      "fk_account": null,
      "note_public": null,
      "note_private": "",
      "actiontypecode": null,
      "name": "Doli Test 22 1",
      "civility_code": null,
      "date_creation": null,
      "date_validation": null,
      "date_modification": null,
      "tms": null,
      "date_cloture": null,
      "user_author": null,
      "user_creation": null,
      "user_creation_id": null,
      "user_valid": null,
      "user_validation": null,
      "user_validation_id": null,
      "user_closing_id": null,
      "user_modification": null,
      "user_modification_id": null,
      "fk_user_creat": null,
      "fk_user_modif": null,
      "specimen": 0,
      "totalpaid": null,
      "extraparams": [],
      "product": null,
      "deposit_percent": null,
      "retained_warranty_fk_cond_reglement": null,
      "warehouse_id": null,
      "SupplierCategories": [],
      "prefixCustomerIsRequired": null,
      "name_alias": null,
      "particulier": null,
      "phone": "0665240151",
      "phone_mobile": "",
      "fax": "",
      "email": "",
      "no_email": null,
      "skype": null,
      "twitter": null,
      "facebook": null,
      "linkedin": null,
      "url": "",
      "barcode": null,
      "idprof1": "",
      "siren": null,
      "idprof2": "",
      "siret": null,
      "idprof3": "",
      "ape": null,
      "idprof4": "",
      "idprof5": "",
      "idprof6": "",
      "idprof7": "",
      "idprof8": "",
      "idprof9": "",
      "idprof10": "",
      "socialobject": "",
      "tva_assuj": 1,
      "tva_intra": "",
      "vat_reverse_charge": 0,
      "localtax1_assuj": 0,
      "localtax1_value": null,
      "localtax2_assuj": 0,
      "localtax2_value": null,
      "managers": "",
      "capital": 0,
      "typent_id": 0,
      "typent_code": null,
      "remise_percent": null,
      "remise_supplier_percent": null,
      "code_client": null,
      "code_fournisseur": null,
      "code_compta_client": null,
      "accountancy_code_customer_general": null,
      "accountancy_code_customer": null,
      "code_compta_fournisseur": null,
      "accountancy_code_supplier_general": null,
      "accountancy_code_supplier": null,
      "code_compta_product": null,
      "stcomm_id": null,
      "stcomm_picto": null,
      "status_prospect_label": null,
      "price_level": null,
      "outstanding_limit": null,
      "order_min_amount": null,
      "supplier_order_min_amount": null,
      "commercial_id": null,
      "parent": null,
      "default_lang": "fr_FR",
      "ip": null,
      "webservices_url": null,
      "webservices_key": null,
      "logo": "",
      "logo_small": "",
      "logo_mini": "",
      "logo_squarred": "",
      "logo_squarred_small": "",
      "logo_squarred_mini": "",
      "accountancy_code_sell": null,
      "accountancy_code_buy": null,
      "currency_code": "EUR",
      "fk_warehouse": null,
      "termsofsale": "",
      "partnerships": [],
      "bank_account": null,
      "code_compta": null,
      "socialnetworks": [],
      "address": "",
      "zip": "",
      "town": ""
    }
    """
    let organization = try JSONDecoder().decode(DolibarrOrganization.self, from: Data(json.utf8))

    #expect(organization.name == "Doli Test 22 1")
    #expect(organization.countryId == "1")
    #expect(organization.countryCode == "FR")
    #expect(organization.stateId == nil)
    #expect(organization.currencyCode == "EUR")
    #expect(organization.defaultLanguage == "fr_FR")
    #expect(organization.phone == "0665240151")
    #expect(organization.phoneMobile == nil)
    #expect(organization.email == nil)
    #expect(organization.address == nil)
    for variant in DolibarrOrganization.LogoVariant.allCases {
        #expect(organization.logoOriginalFile(variant) == nil)
    }
    #expect(organization.preferredLogoOriginalFile == nil)
}

/// `GET /setup/company` response with string IDs and logos
@Test func decodeOrganizationWithLogo() async throws {
    let json = """
    {
        "name": "M34D",
        "country_id": "1",
        "state_id": "0",
        "currency_code": "EUR",
        "logo": "mylogo.png",
        "logo_small": "mylogo_small.png",
        "logo_mini": "mylogo_mini.png",
        "logo_squarred": "mysquare.png",
        "logo_squarred_small": "mysquare_small.png",
        "logo_squarred_mini": "mysquare_mini.png"
    }
    """
    let organization = try JSONDecoder().decode(DolibarrOrganization.self, from: Data(json.utf8))

    #expect(organization.countryId == "1")
    #expect(organization.stateId == nil)
    #expect(organization.logo == "mylogo.png")
    #expect(organization.logoSmall == "mylogo_small.png")
    #expect(organization.logoSquarredMini == "mysquare_mini.png")
}

/// Organization logo original files and preferred logo order
@Test func organizationLogoOriginalFile() async throws {
    let organization = DolibarrOrganization(
        name: "M34D",
        logo: "a.png",
        logoSmall: "a_small.png",
        logoMini: "a_mini.png",
        logoSquarred: "s.png",
        logoSquarredSmall: "s_small.png",
        logoSquarredMini: "s_mini.png"
    )

    #expect(DolibarrOrganization.documentModulePart == "mycompany")
    #expect(organization.logoOriginalFile(.main) == "logos/a.png")
    #expect(organization.logoOriginalFile(.small) == "logos/thumbs/a_small.png")
    #expect(organization.logoOriginalFile(.mini) == "logos/thumbs/a_mini.png")
    #expect(organization.logoOriginalFile(.squarred) == "logos/s.png")
    #expect(organization.logoOriginalFile(.squarredSmall) == "logos/thumbs/s_small.png")
    #expect(organization.logoOriginalFile(.squarredMini) == "logos/thumbs/s_mini.png")
    #expect(organization.preferredLogoOriginalFile == "logos/thumbs/a_small.png")

    #expect(DolibarrOrganization(logo: "a.png", logoSquarredSmall: "s_small.png").preferredLogoOriginalFile == "logos/a.png")
    #expect(DolibarrOrganization(logoSquarred: "s.png", logoSquarredSmall: "s_small.png").preferredLogoOriginalFile == "logos/thumbs/s_small.png")
    #expect(DolibarrOrganization(logoSquarred: "s.png").preferredLogoOriginalFile == "logos/s.png")
    #expect(DolibarrOrganization(logo: "").logoOriginalFile(.main) == nil)
    #expect(DolibarrOrganization().preferredLogoOriginalFile == nil)
}

/// Organization encodes and decodes to an equal value, for caching
@Test func organizationRoundTrip() async throws {
    let organization = DolibarrOrganization(
        name: "M34D",
        town: "Paris",
        stateId: "12",
        countryId: "1",
        countryCode: "FR",
        currencyCode: "EUR",
        logo: "mylogo.png",
        logoSmall: "mylogo_small.png"
    )
    let data = try JSONEncoder().encode(organization)
    let decoded = try JSONDecoder().decode(DolibarrOrganization.self, from: data)

    #expect(decoded == organization)
}

/// Live `GET /multicompany` response from Dolibarr 22.0.4 with Multicompany 22.0.0
@Test func decodeLiveMulticompanyEntitiesV22() async throws {
    let json = """
    [
     {"module":null,"id":"1","entity":[],"array_options":[],"country_id":"1","country_code":"FR","label":"dolitest22 1","description":"Entité maître, ne peut pas être supprimée","url":null,"currency_code":"EUR","language_code":"fr_FR","options":[],"options_json":null,"entities":[],"visible":"1","active":"1","currency":null},
     {"module":null,"id":"2","entity":[],"array_options":[],"country_id":"1","country_code":"FR","state_id":"0","label":"dolitest22 2","description":"","url":null,"currency_code":"EUR","language_code":"fr_FR","options":[],"options_json":null,"entities":[],"visible":"1","active":"1","currency":null},
     {"module":null,"id":"3","entity":[],"array_options":[],"country_id":"","country_code":"","state_id":"0","label":"dolitest22 3","description":"","url":null,"currency_code":"EUR","language_code":"auto","options":[],"options_json":null,"entities":[],"visible":"0","active":"1","currency":null}
    ]
    """
    let entities = try JSONDecoder().decode([MulticompanyEntity].self, from: Data(json.utf8))

    #expect(entities.count == 3)
    #expect(entities.map(\.id) == ["1", "2", "3"])
    #expect(entities[0].label == "dolitest22 1")
    #expect(entities[0].description == "Entité maître, ne peut pas être supprimée")
    #expect(entities[0].countryId == "1")
    #expect(entities[0].countryCode == "FR")
    #expect(entities[0].currencyCode == "EUR")
    #expect(entities[0].visible == "1")
    #expect(entities[0].active == "1")
    #expect(entities[2].countryId == "")
    #expect(entities[2].countryCode == "")
    #expect(entities[2].visible == "0")
    #expect(entities[2].active == "1")
    #expect(entities.allSatisfy { $0.arrayOptions == nil })
}

/// Multicompany entities with null or missing optional fields must not break the list
@Test func decodeMulticompanyEntitiesWithNullAndMissingFields() async throws {
    let json = """
    [
     {"id":"1","label":"Null fields","description":null,"country_id":null,"country_code":null,"currency_code":null,"visible":null,"active":"1","array_options":[]},
     {"id":4,"label":"Minimal"}
    ]
    """
    let entities = try JSONDecoder().decode([MulticompanyEntity].self, from: Data(json.utf8))

    #expect(entities.count == 2)
    #expect(entities[0] == MulticompanyEntity(id: "1", label: "Null fields", active: "1"))
    #expect(entities[1] == MulticompanyEntity(id: "4", label: "Minimal"))
}

/// Live `GET /multicompany` response from Dolibarr 18 with Multicompany 18.0.7
@Test func decodeLiveMulticompanyEntitiesV18() async throws {
    let json = """
    [
      {
        "id": "1",
        "label": "Master entity",
        "description": "Master entity, can not be deleted",
        "currency_code": "EUR",
        "language_code": "en_US",
        "options": [],
        "options_json": null,
        "entity": [],
        "entities": [],
        "visible": "1",
        "active": "1",
        "currency": null,
        "module": null,
        "array_options": [],
        "array_languages": null,
        "contacts_ids": null,
        "linked_objects": null,
        "oldref": null,
        "status": null,
        "country_id": "1",
        "country_code": "FR",
        "region_id": null,
        "demand_reason_id": null,
        "transport_mode_id": null,
        "shipping_method": null,
        "multicurrency_code": null,
        "multicurrency_tx": null,
        "model_pdf": null,
        "last_main_doc": null,
        "fk_bank": null,
        "lines": null,
        "date_creation": null,
        "date_validation": null,
        "date_modification": null,
        "date_update": null,
        "date_cloture": null,
        "user_author": null,
        "user_creation": null,
        "user_creation_id": null,
        "user_valid": null,
        "user_validation": null,
        "user_validation_id": null,
        "user_closing_id": null,
        "user_modification": null,
        "user_modification_id": null,
        "fk_user_creat": null,
        "fk_user_modif": null,
        "specimen": 0,
        "labelStatus": null,
        "showphoto_on_popup": null,
        "nb": [],
        "output": null,
        "extraparams": []
      }
    ]
    """
    let entities = try JSONDecoder().decode([MulticompanyEntity].self, from: Data(json.utf8))

    #expect(entities.count == 1)
    #expect(entities[0] == MulticompanyEntity(
        id: "1",
        label: "Master entity",
        description: "Master entity, can not be deleted",
        countryId: "1",
        countryCode: "FR",
        currencyCode: "EUR",
        visible: "1",
        active: "1"
    ))
}

// MARK: - Computed value properties

@Test func commercialTransactionTotalValuesParseStrings() async throws {
	let order = DolibarrOrder(totalExclTax: "1000.50000000", totalTax: "200.1", totalInclTax: "1200.60")
	#expect(order.totalExclTaxValue == 1000.5)
	#expect(order.totalTaxValue == 200.1)
	#expect(order.totalInclTaxValue == 1200.6)
}

@Test func commercialTransactionTotalValuesDefaultToZero() async throws {
	let order = DolibarrOrder(totalExclTax: "", totalTax: "abc", totalInclTax: "")
	#expect(order.totalExclTaxValue == 0)
	#expect(order.totalTaxValue == 0)
	#expect(order.totalInclTaxValue == 0)
}

@Test func commercialTransactionLineValues() async throws {
	let line = DolibarrOrderLine(
		taxRate: "20.000",
		unitPriceExclTax: "50.00000000",
		discountRate: "10",
		totalExclTax: "90.00",
		totalInclTax: "108.00",
		totalTax: "18.00",
		quantity: "2"
	)
	#expect(line.unitPriceExclTaxValue == 50)
	#expect(line.taxRateFraction == 0.2)
	#expect(abs(line.unitPriceInclTaxValue - 60) < 0.000001)
	#expect(line.discountFraction == 0.1)
	#expect(line.quantityValue == 2)
	#expect(line.totalExclTaxValue == 90)
	#expect(line.totalTaxValue == 18)
	#expect(line.totalInclTaxValue == 108)
}

@Test func commercialTransactionLineValuesDefaultToZero() async throws {
	let line = DolibarrOrderLine(taxRate: "", unitPriceExclTax: "", discountRate: "", quantity: nil)
	#expect(line.unitPriceExclTaxValue == 0)
	#expect(line.unitPriceInclTaxValue == 0)
	#expect(line.taxRateFraction == 0)
	#expect(line.discountFraction == 0)
	#expect(line.quantityValue == 0)
}

@Test func orderDatesConvertTimestamps() async throws {
	let order = DolibarrOrder(dateCreation: 1700000000, dateOrder: nil, dateValidation: 1700000100, deliveryDate: 1700100000)
	#expect(order.dateCreated == Date(timeIntervalSince1970: 1700000000))
	#expect(order.dateOrdered == nil)
	#expect(order.dateValidated == Date(timeIntervalSince1970: 1700000100))
	#expect(order.dateDelivery == Date(timeIntervalSince1970: 1700100000))
}

@Test func projectUsageFlagsAndDates() async throws {
	let project = DolibarrProject(usageLead: 1, usageTask: 0, usageBillTime: 1, usageOrganizeEvent: 0)
	#expect(project.usesLeads)
	#expect(!project.usesTasks)
	#expect(project.usesBillTime)
	#expect(!project.usesEventOrganization)
	#expect(project.dateStarted == nil)
}
