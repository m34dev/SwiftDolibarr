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
//  DolibarrBankAccount.swift
//  SwiftDolibarr
//
//  Created by William Mead on 27/11/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A Dolibarr bank or cash account.
///
/// Decoded from `GET /bankaccounts` or `GET /bankaccounts/{id}`. Adding a payment needs one: see ``DolibarrPayment/accountId``.
///
/// Read-only: encoding writes the decoded keys back, but creating or updating an account isn't supported.
///
/// - Note: Requires the **Banque** module to be activated in Dolibarr, and the `banque` `lire` right.
/// - SeeAlso: ``DolibarrPayment``
/// - SeeAlso: ``DolibarrUserPermissionsBank``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrBankAccount: Hashable, Codable, DolibarrObject {

	// MARK: - Properties

	/// Bank account ID
	///
	/// - Mapped Dolibarr property: **id**
	public var id: String

	/// Short reference
	///
	/// - Mapped Dolibarr property: **ref**
	public var ref: String

	/// Label
	///
	/// - Mapped Dolibarr property: **label**
	public var label: String

	/// Account type code: `0` savings, `1` current, `2` cash
	///
	/// - Mapped Dolibarr property: **type**, or **courant**
	public var typeCode: String?

	/// Whether the account is closed
	///
	/// - Mapped Dolibarr property: **clos**, or **status** (`1` closed)
	public var isClosed: Bool

	/// Account currency code, e.g. `EUR`
	///
	/// - Mapped Dolibarr property: **currency_code**
	public var currencyCode: String?

	/// Bank name
	///
	/// - Mapped Dolibarr property: **bank**
	public var bank: String?

	/// Balance, only returned by `GET /bankaccounts` and `GET /bankaccounts/{id}?includebalance=1`
	///
	/// - Mapped Dolibarr property: **balance**
	public var balance: String?

	// MARK: - Computed properties

	/// Account type
	public var type: AccountType? {
		typeCode.flatMap(AccountType.init(rawValue:))
	}

	/// Balance as a number
	public var balanceValue: Double? {
		balance.flatMap(Double.init)
	}

	// MARK: - Enums

	/// Kind of bank account
	public enum AccountType: String, Hashable, Sendable {
		/// Savings account
		case savings = "0"
		/// Current or credit card account
		case current = "1"
		/// Cash account
		case cash = "2"
	}

	enum CodingKeys: String, CodingKey {
		case id
		case ref
		case label
		case type
		case current = "courant"
		case closed = "clos"
		case status
		case currencyCode = "currency_code"
		case bank
		case balance
	}

	// MARK: - Inits

	public init(
		id: String = "",
		ref: String = "",
		label: String = "",
		typeCode: String? = nil,
		isClosed: Bool = false,
		currencyCode: String? = nil,
		bank: String? = nil,
		balance: String? = nil
	) {
		self.id = id
		self.ref = ref
		self.label = label
		self.typeCode = typeCode
		self.isClosed = isClosed
		self.currencyCode = currencyCode
		self.bank = bank
		self.balance = balance
	}

	public required init(from decoder: any Decoder) throws {
		do {
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
			#endif
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.id = try container.decode(MultiType.self, forKey: .id).stringValue
			self.ref = try container.decodeIfPresent(MultiType.self, forKey: .ref)?.stringValue ?? ""
			self.label = try container.decodeIfPresent(String.self, forKey: .label) ?? ""
			let typeCode = try container.decodeIfPresent(MultiType.self, forKey: .type) ?? container.decodeIfPresent(MultiType.self, forKey: .current)
			self.typeCode = typeCode.map(\.stringValue).flatMap { $0.isEmpty ? nil : $0 }
			let closed = try container.decodeIfPresent(MultiType.self, forKey: .closed) ?? container.decodeIfPresent(MultiType.self, forKey: .status)
			self.isClosed = closed?.intValue == 1
			self.currencyCode = try container.decodeIfPresent(String.self, forKey: .currencyCode).flatMap { $0.isEmpty ? nil : $0 }
			self.bank = try container.decodeIfPresent(String.self, forKey: .bank).flatMap { $0.isEmpty ? nil : $0 }
			self.balance = try container.decodeIfPresent(MultiType.self, forKey: .balance)?.stringValue
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

	public init(copying source: DolibarrBankAccount) {
		self.id = source.id
		self.ref = source.ref
		self.label = source.label
		self.typeCode = source.typeCode
		self.isClosed = source.isClosed
		self.currencyCode = source.currencyCode
		self.bank = source.bank
		self.balance = source.balance
	}

	// MARK: - Methods

	public func copy(_ source: DolibarrBankAccount) {
		self.id = source.id
		self.ref = source.ref
		self.label = source.label
		self.typeCode = source.typeCode
		self.isClosed = source.isClosed
		self.currencyCode = source.currencyCode
		self.bank = source.bank
		self.balance = source.balance
	}

	// MARK: - Protocol methods

	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(ref)
		hasher.combine(label)
		hasher.combine(typeCode)
		hasher.combine(isClosed)
		hasher.combine(currencyCode)
		hasher.combine(bank)
		hasher.combine(balance)
	}

	public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(ref, forKey: .ref)
		try container.encode(label, forKey: .label)
		try container.encodeIfPresent(typeCode, forKey: .type)
		try container.encode(isClosed ? "1" : "0", forKey: .closed)
		try container.encodeIfPresent(currencyCode, forKey: .currencyCode)
		try container.encodeIfPresent(bank, forKey: .bank)
		try container.encodeIfPresent(balance, forKey: .balance)
	}

	public static func == (lhs: DolibarrBankAccount, rhs: DolibarrBankAccount) -> Bool {
		lhs.id == rhs.id
		&& lhs.ref == rhs.ref
		&& lhs.label == rhs.label
		&& lhs.typeCode == rhs.typeCode
		&& lhs.isClosed == rhs.isClosed
		&& lhs.currencyCode == rhs.currencyCode
		&& lhs.bank == rhs.bank
		&& lhs.balance == rhs.balance
	}

}
