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
//  DolibarrPayment.swift
//  SwiftDolibarr
//
//  Created by William Mead on 27/11/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A payment on a Dolibarr client or supplier invoice.
///
/// Decoded from two shapes:
/// - a client payment from `GET /paiements` or `GET /paiements/{id}` (v23+), with its ID,
///   timestamp date (`datepaye`), `type_code`, `type_label`, `num_payment`, `fk_account` and note;
/// - an entry of `GET /invoices/{id}/payments` or `GET /supplierinvoices/{id}/payments`,
///   which has no ID: its date is a `YYYY-MM-DD HH:MM:SS` string, its type is `type`,
///   its number is `num`, and `amount` is the part of the payment allocated to that invoice.
///   Since v21, `typeline` tells payments from credit notes, deposits and excess received (`discount`),
///   whose `ref` is the source invoice reference.
///
/// Encoded as the body to add a payment, depending on ``invoiceKind``:
/// - ``InvoiceKind/invoice``: `POST /invoices/paymentsdistributed` (v8+), which takes an amount,
///   unlike `POST /invoices/{id}/payments` that always pays the remaining amount;
/// - ``InvoiceKind/supplierInvoice``: `POST /supplierinvoices/{id}/payments`, whose amount needs v19+.
///
/// Both return the new payment ID. Both need a bank account ID (``accountId``), from `GET /bankaccounts`.
///
/// - Note: Requires the **Facture** module, or the **Fournisseur** module for supplier invoices, to be activated in Dolibarr.
///   Adding a client payment needs the `facture` `paiement` right, a supplier payment the `fournisseur` `facture` `creer` right.
///   With the **Banque** module, a client cheque payment (`CHQ`) needs ``chequeIssuer``.
/// - SeeAlso: ``DolibarrInvoice``
/// - SeeAlso: ``DolibarrSupplierInvoice``
/// - SeeAlso: ``DolibarrBankAccount``
/// - SeeAlso: ``DolibarrPaymentMethod``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrPayment: Hashable, Codable, DolibarrObject {

	// MARK: - Properties

	/// Payment ID
	///
	/// Invoice payment entries have no ID: it is then built from ``lineType`` and ``ref``,
	/// e.g. `payment-PAY2611-0001`, which is not a Dolibarr ID.
	///
	/// - Mapped Dolibarr property: **id**
	public var id: String

	/// Payment reference, or the source invoice reference of a ``LineType/discount`` entry
	///
	/// - Mapped Dolibarr property: **ref**
	public var ref: String

	/// External reference
	///
	/// Not sent for supplier invoices.
	///
	/// - Mapped Dolibarr property: **ref_ext**
	public var refExt: String?

	/// Payment date (Unix timestamp)
	///
	/// Invoice payment entries return the database date string, in the server's time zone,
	/// read here as GMT: Dolibarr stores payment dates at noon, so the day is right.
	///
	/// - Mapped Dolibarr property: **datepaye**, or **date** on invoice payment entries
	public var dateTimestamp: Int?

	/// Amount: the payment total, or on invoice payment entries the part allocated to that invoice
	///
	/// - Mapped Dolibarr property: **amount**
	public var amount: String

	/// Amount in the invoice currency, read-only
	///
	/// - Mapped Dolibarr property: **multicurrency_amount**
	public var multicurrencyAmount: String?

	/// Payment number, e.g. a cheque or transfer number
	///
	/// - Mapped Dolibarr property: **num_payment**, or **num** on invoice payment entries
	public var number: String?

	/// Payment type code, e.g. `CHQ`, read-only
	///
	/// On a ``LineType/discount`` entry, the discount description instead.
	///
	/// - Mapped Dolibarr property: **type_code**, or **type** on invoice payment entries
	public var typeCode: String?

	/// Payment type label, untranslated, read-only
	///
	/// - Mapped Dolibarr property: **type_label**
	public var typeLabel: String?

	/// Private note, sent as the comment when adding a payment
	///
	/// - Mapped Dolibarr property: **note_private**, **comment** when written
	public var notePrivate: String?

	/// Status code, read-only
	///
	/// - Mapped Dolibarr property: **statut**
	public var status: String?

	/// Bank account ID
	///
	/// - Mapped Dolibarr property: **fk_account**, **accountid** when written
	public var accountId: String?

	/// Bank transaction line ID, read-only
	///
	/// - Mapped Dolibarr property: **bank_line**, or **fk_bank_line** on invoice payment entries (v18+)
	public var bankLineId: String?

	/// External payment ID, e.g. from an online payment, read-only
	///
	/// - Mapped Dolibarr property: **ext_payment_id**
	public var externalPaymentId: String?

	/// External payment site, e.g. `stripe`, read-only
	///
	/// - Mapped Dolibarr property: **ext_payment_site**
	public var externalPaymentSite: String?

	/// Kind of invoice payment entry, read-only, nil before Dolibarr v21 and on `/paiements`
	///
	/// - Mapped Dolibarr property: **typeline**
	public var lineType: LineType?

	/// Invoice ID to pay, write only
	public var invoiceId: String

	/// Kind of invoice to pay, which sets the body encoded, write only
	public var invoiceKind: InvoiceKind

	/// Payment type ID, from the payment types dictionary, write only
	///
	/// - Mapped Dolibarr property: **paymentid**, or **payment_mode_id** for supplier invoices
	public var paymentTypeId: String?

	/// Whether Dolibarr classifies the invoice as paid when the payment covers it, write only
	///
	/// - Mapped Dolibarr property: **closepaidinvoices** (`yes` or `no`)
	public var closePaidInvoices: Bool

	/// Cheque issuer, write only, mandatory for a client cheque payment with the Banque module
	///
	/// - Mapped Dolibarr property: **chqemetteur**
	public var chequeIssuer: String?

	/// Cheque issuer bank name, write only
	///
	/// - Mapped Dolibarr property: **chqbank**
	public var chequeBank: String?

	/// Whether Dolibarr accepts a client payment higher than the remaining amount, write only
	///
	/// Not sent for supplier invoices.
	///
	/// - Mapped Dolibarr property: **accepthigherpayment**
	public var acceptHigherPayment: Bool

	// MARK: - Type properties

	/// Format of the date string of invoice payment entries: `YYYY-MM-DD HH:MM:SS`, read as GMT
	static let entryDateParseStrategy = Date.ParseStrategy(
		format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)",
		timeZone: .gmt
	)

	/// Format of a date-only string: `YYYY-MM-DD`, read as GMT
	static let entryDayParseStrategy = Date.ParseStrategy(
		format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)",
		timeZone: .gmt
	)

	// MARK: - Computed properties

	/// Payment date
	public var date: Date? {
		get {
			guard let dateTimestamp else { return nil }
			return Date(timeIntervalSince1970: TimeInterval(dateTimestamp))
		}
		set {
			dateTimestamp = newValue.map { Int($0.timeIntervalSince1970) }
		}
	}

	/// Amount as a number, `0` when the value can't be parsed
	public var amountValue: Double {
		Double(amount) ?? 0
	}

	/// Amount in the invoice currency as a number
	public var multicurrencyAmountValue: Double? {
		multicurrencyAmount.flatMap(Double.init)
	}

	/// Whether the entry is a credit note, deposit or excess received used on the invoice, not a payment
	public var isDiscount: Bool {
		lineType == .discount
	}

	// MARK: - Enums

	/// Kind of invoice payment entry
	public enum LineType: String, Hashable, Sendable {
		/// A payment
		case payment
		/// A credit note, deposit or excess received used on the invoice
		case discount
	}

	/// Kind of invoice a payment is added to
	public enum InvoiceKind: Hashable, Sendable {
		/// Client invoice
		case invoice
		/// Supplier invoice
		case supplierInvoice
	}

	enum CodingKeys: String, CodingKey {
		case id
		case ref
		case refExt = "ref_ext"
		case datePaid = "datepaye"
		case date
		case amount
		case multicurrencyAmount = "multicurrency_amount"
		case paymentNumber = "num_payment"
		case entryNumber = "num"
		case typeCode = "type_code"
		case type
		case typeLabel = "type_label"
		case notePrivate = "note_private"
		case status = "statut"
		case accountId = "fk_account"
		case bankLineId = "bank_line"
		case entryBankLineId = "fk_bank_line"
		case externalPaymentId = "ext_payment_id"
		case externalPaymentSite = "ext_payment_site"
		case lineType = "typeline"
	}

	/// Keys of the add body
	enum WriteCodingKeys: String, CodingKey {
		case amounts = "arrayofamounts"
		case datePaid = "datepaye"
		case paymentId = "paymentid"
		case paymentModeId = "payment_mode_id"
		case closePaidInvoices = "closepaidinvoices"
		case accountId = "accountid"
		case number = "num_payment"
		case comment
		case chequeIssuer = "chqemetteur"
		case chequeBank = "chqbank"
		case refExt = "ref_ext"
		case acceptHigherPayment = "accepthigherpayment"
		case amount
	}

	/// Keys of an invoice amount in `arrayofamounts`
	enum AmountCodingKeys: String, CodingKey {
		case amount
		case multicurrencyAmount = "multicurrency_amount"
	}

	/// Invoice ID key of `arrayofamounts`
	struct InvoiceIdCodingKey: CodingKey {
		var stringValue: String
		var intValue: Int? { nil }

		init(stringValue: String) {
			self.stringValue = stringValue
		}

		init?(intValue: Int) {
			self.stringValue = String(intValue)
		}
	}

	// MARK: - Inits

	public init(
		id: String = "",
		ref: String = "",
		refExt: String? = nil,
		dateTimestamp: Int? = nil,
		amount: String = "",
		multicurrencyAmount: String? = nil,
		number: String? = nil,
		typeCode: String? = nil,
		typeLabel: String? = nil,
		notePrivate: String? = nil,
		status: String? = nil,
		accountId: String? = nil,
		bankLineId: String? = nil,
		externalPaymentId: String? = nil,
		externalPaymentSite: String? = nil,
		lineType: LineType? = nil,
		invoiceId: String = "",
		invoiceKind: InvoiceKind = .invoice,
		paymentTypeId: String? = nil,
		closePaidInvoices: Bool = false,
		chequeIssuer: String? = nil,
		chequeBank: String? = nil,
		acceptHigherPayment: Bool = false
	) {
		self.id = id
		self.ref = ref
		self.refExt = refExt
		self.dateTimestamp = dateTimestamp
		self.amount = amount
		self.multicurrencyAmount = multicurrencyAmount
		self.number = number
		self.typeCode = typeCode
		self.typeLabel = typeLabel
		self.notePrivate = notePrivate
		self.status = status
		self.accountId = accountId
		self.bankLineId = bankLineId
		self.externalPaymentId = externalPaymentId
		self.externalPaymentSite = externalPaymentSite
		self.lineType = lineType
		self.invoiceId = invoiceId
		self.invoiceKind = invoiceKind
		self.paymentTypeId = paymentTypeId
		self.closePaidInvoices = closePaidInvoices
		self.chequeIssuer = chequeIssuer
		self.chequeBank = chequeBank
		self.acceptHigherPayment = acceptHigherPayment
	}

	public required init(from decoder: any Decoder) throws {
		do {
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
			#endif
			let container = try decoder.container(keyedBy: CodingKeys.self)
			let ref = try container.decodeIfPresent(MultiType.self, forKey: .ref)?.stringValue ?? ""
			let lineType = try container.decodeIfPresent(String.self, forKey: .lineType).flatMap(LineType.init(rawValue:))
			self.id = try container.decodeIdIfPresent(forKey: .id) ?? "\((lineType ?? .payment).rawValue)-\(ref)"
			self.ref = ref
			self.lineType = lineType
			self.refExt = try container.decodeIfPresent(String.self, forKey: .refExt).flatMap { $0.isEmpty ? nil : $0 }
			if let datePaid = try container.decodeIfPresent(MultiType.self, forKey: .datePaid)?.intValue {
				self.dateTimestamp = datePaid
			} else if let date = try container.decodeIfPresent(MultiType.self, forKey: .date) {
				self.dateTimestamp = date.intValue ?? Self.timestamp(fromEntryDate: date.stringValue)
			} else {
				self.dateTimestamp = nil
			}
			self.amount = try container.decodeIfPresent(MultiType.self, forKey: .amount)?.stringValue ?? ""
			self.multicurrencyAmount = try container.decodeIfPresent(MultiType.self, forKey: .multicurrencyAmount)?.stringValue
			let number = try container.decodeIfPresent(MultiType.self, forKey: .paymentNumber) ?? container.decodeIfPresent(MultiType.self, forKey: .entryNumber)
			self.number = number.map(\.stringValue).flatMap { $0.isEmpty ? nil : $0 }
			let typeCode = try container.decodeIfPresent(String.self, forKey: .typeCode) ?? container.decodeIfPresent(String.self, forKey: .type)
			self.typeCode = typeCode.flatMap { $0.isEmpty ? nil : $0 }
			self.typeLabel = try container.decodeIfPresent(String.self, forKey: .typeLabel)
			self.notePrivate = try container.decodeIfPresent(String.self, forKey: .notePrivate)
			self.status = try container.decodeIfPresent(MultiType.self, forKey: .status)?.stringValue
			self.accountId = try container.decodeIdIfPresent(forKey: .accountId)
			self.bankLineId = try container.decodeIdIfPresent(forKey: .bankLineId) ?? container.decodeIdIfPresent(forKey: .entryBankLineId)
			self.externalPaymentId = try container.decodeIfPresent(String.self, forKey: .externalPaymentId)
			self.externalPaymentSite = try container.decodeIfPresent(String.self, forKey: .externalPaymentSite)
			self.invoiceId = ""
			self.invoiceKind = .invoice
			self.paymentTypeId = nil
			self.closePaidInvoices = false
			self.chequeIssuer = nil
			self.chequeBank = nil
			self.acceptHigherPayment = false
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logWithoutSignal("\(Self.self).init.decoded", category: .api)
			#endif
		} catch let error as DecodingError {
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logDecodingError(error, decodeContext: "\(Self.self).init")
			#endif
			throw error
		} catch {
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logErrorWithSignal(error, context: "\(Self.self).init", category: .api)
			#endif
			throw error
		}
	}

	public init(copying source: DolibarrPayment) {
		self.id = source.id
		self.ref = source.ref
		self.refExt = source.refExt
		self.dateTimestamp = source.dateTimestamp
		self.amount = source.amount
		self.multicurrencyAmount = source.multicurrencyAmount
		self.number = source.number
		self.typeCode = source.typeCode
		self.typeLabel = source.typeLabel
		self.notePrivate = source.notePrivate
		self.status = source.status
		self.accountId = source.accountId
		self.bankLineId = source.bankLineId
		self.externalPaymentId = source.externalPaymentId
		self.externalPaymentSite = source.externalPaymentSite
		self.lineType = source.lineType
		self.invoiceId = source.invoiceId
		self.invoiceKind = source.invoiceKind
		self.paymentTypeId = source.paymentTypeId
		self.closePaidInvoices = source.closePaidInvoices
		self.chequeIssuer = source.chequeIssuer
		self.chequeBank = source.chequeBank
		self.acceptHigherPayment = source.acceptHigherPayment
	}

	// MARK: - Methods

	public func copy(_ source: DolibarrPayment) {
		self.id = source.id
		self.ref = source.ref
		self.refExt = source.refExt
		self.dateTimestamp = source.dateTimestamp
		self.amount = source.amount
		self.multicurrencyAmount = source.multicurrencyAmount
		self.number = source.number
		self.typeCode = source.typeCode
		self.typeLabel = source.typeLabel
		self.notePrivate = source.notePrivate
		self.status = source.status
		self.accountId = source.accountId
		self.bankLineId = source.bankLineId
		self.externalPaymentId = source.externalPaymentId
		self.externalPaymentSite = source.externalPaymentSite
		self.lineType = source.lineType
		self.invoiceId = source.invoiceId
		self.invoiceKind = source.invoiceKind
		self.paymentTypeId = source.paymentTypeId
		self.closePaidInvoices = source.closePaidInvoices
		self.chequeIssuer = source.chequeIssuer
		self.chequeBank = source.chequeBank
		self.acceptHigherPayment = source.acceptHigherPayment
	}

	/// Unix timestamp of an invoice payment entry date, `YYYY-MM-DD HH:MM:SS` or `YYYY-MM-DD`, read as GMT
	static func timestamp(fromEntryDate string: String) -> Int? {
		let string = string.trimmingCharacters(in: .whitespaces)
		guard !string.isEmpty else { return nil }
		let date = (try? Date(string, strategy: entryDateParseStrategy)) ?? (try? Date(string, strategy: entryDayParseStrategy))
		return date.map { Int($0.timeIntervalSince1970) }
	}

	/// Positive ID value, or nil when empty, zero or not a number
	private static func positiveId(_ id: String?) -> Int? {
		guard let id, let value = Int(id), value > 0 else { return nil }
		return value
	}

	// MARK: - Protocol methods

	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(ref)
		hasher.combine(refExt)
		hasher.combine(dateTimestamp)
		hasher.combine(amount)
		hasher.combine(multicurrencyAmount)
		hasher.combine(number)
		hasher.combine(typeCode)
		hasher.combine(typeLabel)
		hasher.combine(notePrivate)
		hasher.combine(status)
		hasher.combine(accountId)
		hasher.combine(bankLineId)
		hasher.combine(externalPaymentId)
		hasher.combine(externalPaymentSite)
		hasher.combine(lineType)
		hasher.combine(invoiceId)
		hasher.combine(invoiceKind)
		hasher.combine(paymentTypeId)
		hasher.combine(closePaidInvoices)
		hasher.combine(chequeIssuer)
		hasher.combine(chequeBank)
		hasher.combine(acceptHigherPayment)
	}

	/// Encodes the add body for ``invoiceKind``
	///
	/// - Throws: `EncodingError.invalidValue` when ``invoiceId`` or ``date`` is missing,
	///   ``amount`` is not a positive number, or ``paymentTypeId`` or ``accountId`` is not a positive ID
	public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: WriteCodingKeys.self)
		func invalid(_ key: WriteCodingKeys, _ description: String) -> EncodingError {
			EncodingError.invalidValue(self, EncodingError.Context(codingPath: encoder.codingPath + [key], debugDescription: description))
		}
		guard !invoiceId.isEmpty else {
			throw invalid(.amounts, "Payment invoice ID is required")
		}
		guard let dateTimestamp else {
			throw invalid(.datePaid, "Payment date is required")
		}
		let amountText = amount.trimmingCharacters(in: .whitespaces)
		guard let amountValue = Decimal(string: amountText, locale: Locale(identifier: "en_US_POSIX")), amountValue > 0 else {
			throw invalid(invoiceKind == .invoice ? .amounts : .amount, "Payment amount must be a positive number")
		}
		guard let paymentTypeId = Self.positiveId(paymentTypeId) else {
			throw invalid(invoiceKind == .invoice ? .paymentId : .paymentModeId, "Payment type ID is required")
		}
		guard let accountId = Self.positiveId(accountId) else {
			throw invalid(.accountId, "Payment bank account ID is required")
		}
		switch invoiceKind {
		case .invoice:
			var amounts = container.nestedContainer(keyedBy: InvoiceIdCodingKey.self, forKey: .amounts)
			var invoiceAmount = amounts.nestedContainer(keyedBy: AmountCodingKeys.self, forKey: InvoiceIdCodingKey(stringValue: invoiceId))
			try invoiceAmount.encode(amountText, forKey: .amount)
			try invoiceAmount.encode("", forKey: .multicurrencyAmount)
			try container.encode(String(dateTimestamp), forKey: .datePaid)
			try container.encode(paymentTypeId, forKey: .paymentId)
			try container.encodeIfPresentAndNotEmpty(refExt, forKey: .refExt)
			try container.encode(acceptHigherPayment, forKey: .acceptHigherPayment)
		case .supplierInvoice:
			try container.encode(amountValue, forKey: .amount)
			try container.encode(dateTimestamp, forKey: .datePaid)
			try container.encode(paymentTypeId, forKey: .paymentModeId)
		}
		try container.encode(closePaidInvoices ? "yes" : "no", forKey: .closePaidInvoices)
		try container.encode(accountId, forKey: .accountId)
		try container.encodeIfPresentAndNotEmpty(number, forKey: .number)
		try container.encodeIfPresentAndNotEmpty(notePrivate, forKey: .comment)
		try container.encodeIfPresentAndNotEmpty(chequeIssuer, forKey: .chequeIssuer)
		try container.encodeIfPresentAndNotEmpty(chequeBank, forKey: .chequeBank)
	}

	public static func == (lhs: DolibarrPayment, rhs: DolibarrPayment) -> Bool {
		lhs.id == rhs.id
		&& lhs.ref == rhs.ref
		&& lhs.refExt == rhs.refExt
		&& lhs.dateTimestamp == rhs.dateTimestamp
		&& lhs.amount == rhs.amount
		&& lhs.multicurrencyAmount == rhs.multicurrencyAmount
		&& lhs.number == rhs.number
		&& lhs.typeCode == rhs.typeCode
		&& lhs.typeLabel == rhs.typeLabel
		&& lhs.notePrivate == rhs.notePrivate
		&& lhs.status == rhs.status
		&& lhs.accountId == rhs.accountId
		&& lhs.bankLineId == rhs.bankLineId
		&& lhs.externalPaymentId == rhs.externalPaymentId
		&& lhs.externalPaymentSite == rhs.externalPaymentSite
		&& lhs.lineType == rhs.lineType
		&& lhs.invoiceId == rhs.invoiceId
		&& lhs.invoiceKind == rhs.invoiceKind
		&& lhs.paymentTypeId == rhs.paymentTypeId
		&& lhs.closePaidInvoices == rhs.closePaidInvoices
		&& lhs.chequeIssuer == rhs.chequeIssuer
		&& lhs.chequeBank == rhs.chequeBank
		&& lhs.acceptHigherPayment == rhs.acceptHigherPayment
	}

}
