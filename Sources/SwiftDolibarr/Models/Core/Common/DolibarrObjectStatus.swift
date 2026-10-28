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
//  DolibarrObjectStatus.swift
//  SwiftDolibarr
//
//  Created by William Mead on 09/02/2026.
//

import Foundation

/// Represents the status of a Dolibarr business object.
///
/// Each status has a ``code`` and a ``domain`` that identifies which
/// object type the status applies to. Predefined static instances cover
/// statuses for third parties, products, warehouses, quotes, orders,
/// invoices, interventions, expense reports, projects, tasks, and
/// agenda events.
///
/// - SeeAlso: ``DolibarrObjectDomain``
/// - SeeAlso: ``DolibarrBusinessObject``
public struct DolibarrObjectStatus: Identifiable, Equatable, Hashable, Sendable {

	// MARK: - Properties

	public var id: UUID = UUID()
	public var code: String
	public var domain: DolibarrObjectDomain

	// MARK: - Static properties

	// Generic

	public static let canceled: DolibarrObjectStatus = .init(
		code: "-1",
		domain: .generic
	)
	public static let draft: DolibarrObjectStatus = .init(
		code: "0",
		domain: .generic
	)
	public static let validated: DolibarrObjectStatus = .init(
		code: "1",
		domain: .generic
	)
	public static let unknown: DolibarrObjectStatus = .init(
		code: "",
		domain: .generic
	)

	// ThirdParty & Contacts

	public static let inactive: DolibarrObjectStatus = .init(
		code: "0",
		domain: .thirdParty
	)
	public static let active: DolibarrObjectStatus = .init(
		code: "1",
		domain: .thirdParty
	)

	public static let thirdPartiesContacts: [DolibarrObjectStatus] = [inactive, active]

	// Products & Services

	public static let forSaleForPurchase: DolibarrObjectStatus = .init(
		code: "11",
		domain: .product
	)
	public static let forSaleNotForPurchase: DolibarrObjectStatus = .init(
		code: "10",
		domain: .product
	)
	public static let forPurchaseNotForSale: DolibarrObjectStatus = .init(
		code: "01",
		domain: .product
	)
	public static let notForSaleNotForPurchase: DolibarrObjectStatus = .init(
		code: "00",
		domain: .product
	)

	public static let productsServices: [DolibarrObjectStatus] = [
		forSaleForPurchase, forSaleNotForPurchase, forPurchaseNotForSale, notForSaleNotForPurchase
	]

	// Warehouse

	public static let warehouseClosed: DolibarrObjectStatus = .init(
		code: "0",
		domain: .warehouse
	)
	public static let warehouseOpen: DolibarrObjectStatus = .init(
		code: "1",
		domain: .warehouse
	)

	public static let warehouses: [DolibarrObjectStatus] = [warehouseClosed, warehouseOpen]

	// Quote

	public static let quoteSigned: DolibarrObjectStatus = .init(
		code: "2",
		domain: .quote
	)
	public static let quoteNotSigned: DolibarrObjectStatus = .init(
		code: "3",
		domain: .quote
	)
	public static let quoteBilled: DolibarrObjectStatus = .init(
		code: "4",
		domain: .quote
	)

	public static let quotes: [DolibarrObjectStatus] = [
		canceled, draft, validated, quoteSigned, quoteNotSigned, quoteBilled
	]

	// Order

	public static let orderBackorder: DolibarrObjectStatus = .init(
		code: "-3",
		domain: .order
	)
	public static let orderShipped: DolibarrObjectStatus = .init(
		code: "2",
		domain: .order
	)
	public static let orderClosed: DolibarrObjectStatus = .init(
		code: "3",
		domain: .order
	)

	public static let orders: [DolibarrObjectStatus] = [
		orderBackorder, canceled, draft, validated, orderShipped, orderClosed
	]

	// Invoice

	public static let invoiceClosed: DolibarrObjectStatus = .init(
		code: "2",
		domain: .invoice
	)
	public static let invoiceAbandoned: DolibarrObjectStatus = .init(
		code: "3",
		domain: .invoice
	)

	public static let invoices: [DolibarrObjectStatus] = [draft, validated, invoiceClosed, invoiceAbandoned]

	// Intervention

	public static let interventionBilled: DolibarrObjectStatus = .init(
		code: "2",
		domain: .intervention
	)
	public static let interventionClosed: DolibarrObjectStatus = .init(
		code: "3",
		domain: .intervention
	)

	public static let interventions: [DolibarrObjectStatus] = [draft, validated, interventionBilled, interventionClosed]

	// Expense report

	public static let expenseReportValidated: DolibarrObjectStatus = .init(
		code: "2",
		domain: .expenseReport
	)
	public static let expenseReportCanceled: DolibarrObjectStatus = .init(
		code: "4",
		domain: .expenseReport
	)
	public static let expenseReportApproved: DolibarrObjectStatus = .init(
		code: "5",
		domain: .expenseReport
	)
	public static let expenseReportClosed: DolibarrObjectStatus = .init(
		code: "6",
		domain: .expenseReport
	)
	public static let expenseReportRefused: DolibarrObjectStatus = .init(
		code: "99",
		domain: .expenseReport
	)

	public static let expenseReports: [DolibarrObjectStatus] = [
		draft, expenseReportValidated, expenseReportCanceled, expenseReportApproved, expenseReportClosed, expenseReportRefused
	]

	// Project

	public static let projectClosed: DolibarrObjectStatus = .init(
		code: "2",
		domain: .project
	)

	public static let projects: [DolibarrObjectStatus] = [draft, validated, projectClosed]

	// Task

    public static let taskInProgress: DolibarrObjectStatus = .init(
        code: "2",
        domain: .task
    )
    
	public static let taskClosed: DolibarrObjectStatus = .init(
		code: "3",
		domain: .task
	)

	public static let taskTransferred: DolibarrObjectStatus = .init(
		code: "4",
		domain: .task
	)

	public static let taskCanceled: DolibarrObjectStatus = .init(
		code: "9",
		domain: .task
	)

	public static let tasks: [DolibarrObjectStatus] = [
        draft, validated, .taskInProgress, taskClosed, taskTransferred, taskCanceled
	]

	// Agenda event

	public static let agendaEventNA: DolibarrObjectStatus = .init(
		code: "-1",
		domain: .agendaEvent
	)
	public static let agendaEventToDo: DolibarrObjectStatus = .init(
		code: "0",
		domain: .agendaEvent
	)
	public static let agendaEventInProgress: DolibarrObjectStatus = .init(
		code: "50",
		domain: .agendaEvent
	)
	public static let agendaEventFinished: DolibarrObjectStatus = .init(
		code: "100",
		domain: .agendaEvent
	)

	public static let agendaEvents: [DolibarrObjectStatus] = [
		agendaEventNA, agendaEventToDo, agendaEventInProgress, agendaEventFinished
	]

	// Supplier order

	public static let supplierOrderApproved: DolibarrObjectStatus = .init(
		code: "2",
		domain: .supplierOrder
	)
	public static let supplierOrderSent: DolibarrObjectStatus = .init(
		code: "3",
		domain: .supplierOrder
	)
	public static let supplierOrderReceivedPartially: DolibarrObjectStatus = .init(
		code: "4",
		domain: .supplierOrder
	)
	public static let supplierOrderReceivedCompletely: DolibarrObjectStatus = .init(
		code: "5",
		domain: .supplierOrder
	)
	public static let supplierOrderCanceled: DolibarrObjectStatus = .init(
		code: "6",
		domain: .supplierOrder
	)
	public static let supplierOrderCanceledAfterOrder: DolibarrObjectStatus = .init(
		code: "7",
		domain: .supplierOrder
	)
	public static let supplierOrderRefused: DolibarrObjectStatus = .init(
		code: "9",
		domain: .supplierOrder
	)

	public static let supplierOrders: [DolibarrObjectStatus] = [
		draft, validated, supplierOrderApproved, supplierOrderSent, supplierOrderReceivedPartially,
		supplierOrderReceivedCompletely, supplierOrderCanceled, supplierOrderCanceledAfterOrder, supplierOrderRefused
	]

	// Supplier invoice

	public static let supplierInvoiceClosed: DolibarrObjectStatus = .init(
		code: "2",
		domain: .supplierInvoice
	)
	public static let supplierInvoiceAbandoned: DolibarrObjectStatus = .init(
		code: "3",
		domain: .supplierInvoice
	)

	public static let supplierInvoices: [DolibarrObjectStatus] = [
		draft, validated, supplierInvoiceClosed, supplierInvoiceAbandoned
	]

	// MARK: - Protocol methods

	public static func == (lhs: DolibarrObjectStatus, rhs: DolibarrObjectStatus) -> Bool {
		lhs.id == rhs.id &&
		lhs.code == rhs.code
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(code)
		hasher.combine(domain)
	}

}
