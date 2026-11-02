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

    let copy = DolibarrSupplierOrder(copying: order)
    #expect(copy.orderMethodId == "5")
    #expect(copy.orderMethod == "En ligne")

    let encoder = JSONEncoder()
    let redecoded = try decoder.decode(DolibarrSupplierOrder.self, from: encoder.encode(order))
    #expect(redecoded == order)
    #expect(redecoded.orderMethodId == "5")
    #expect(redecoded.orderMethod == "En ligne")
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
