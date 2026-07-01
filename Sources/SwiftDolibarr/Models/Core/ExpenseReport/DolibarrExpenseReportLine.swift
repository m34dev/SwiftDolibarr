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
//  DolibarrExpenseReportLine.swift
//  SwiftDolibarr
//
//  Created by William Mead on 27/05/2025.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A single line item within a Dolibarr expense report.
///
/// Each line represents an individual expense with a fee type, quantity,
/// unit price, tax rate, and totals.
///
/// - Note: Requires the **Expensereport** module to be activated in Dolibarr.
/// - SeeAlso: ``DolibarrExpenseReport``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrExpenseReportLine: CommonBusinessObjectLine {

    // MARK: - Properties

	/// Expense report line quantity
	///
	/// - Mapped Dolibarr property: **qty**
	public var quantity: String

	/// Expense report line unit price including tax
	///
	/// - Mapped Dolibarr property: **value_unit**
	public var unitPriceInclTax: String

	/// Expense report line date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **dates**
	public var date: Int

	/// Expense report line fee type ID
	///
	/// - Mapped Dolibarr property: **fk_c_type_fees**
	public var feeTypeId: String

	/// Expense report line fee type code
	///
	/// - Mapped Dolibarr property: **type_fees_code**
	public var feeTypeCode: String

	/// Expense report line fee type label
	///
	/// - Mapped Dolibarr property: **type_fees_libelle**
	public var feeTypeLabel: String

	/// Expense report line total amount excluding tax
	///
	/// - Mapped Dolibarr property: **total_ht**
	public var totalExclTax: String

	/// Expense report line total tax amount
	///
	/// - Mapped Dolibarr property: **total_tva**
	public var totalTax: String

	/// Expense report line total amount including tax
	///
	/// - Mapped Dolibarr property: **total_ttc**
	public var totalInclTax: String

	/// Expense report line tax rate
	///
	/// - Mapped Dolibarr property: **tva_tx**
	public var taxRate: String

	/// Expense report line comments
	public var comments: String?

    // Computed

	/// Expense report line date
	public var dateIncurred: Date {
		Date(timeIntervalSince1970: TimeInterval(date))
	}

    // MARK: - Enums

    enum CodingKeys: String, CodingKey {
        case quantity = "qty"
        case unitPriceInclTax = "value_unit"
        case dateDecode = "dates"
        case dateEncode = "date"
        case feeTypeId = "fk_c_type_fees"
        case feeTypeCode = "type_fees_code"
        case feeTypeLabel = "type_fees_libelle"
        case totalExclTax = "total_ht"
        case totalTax = "total_tva"
        case totalInclTax = "total_ttc"
        case taxRateDecode = "tva_tx"
		case taxRateEncode = "vatrate"
        case comments
    }

    // MARK: - Inits

    public init(
        quantity: String,
        unitPriceInclTax: String,
        date: Int,
        feeTypeId: String,
        feeTypeCode: String,
        feeTypeLabel: String,
        totalExclTax: String,
        totalTax: String,
        totalInclTax: String,
        taxRate: String,
        comments: String? = nil,
        id: String = "",
        rang: String = ""
    ) {
        self.quantity = quantity
        self.unitPriceInclTax = unitPriceInclTax
        self.date = date
        self.feeTypeId = feeTypeId
        self.feeTypeCode = feeTypeCode
        self.feeTypeLabel = feeTypeLabel
        self.totalExclTax = totalExclTax
        self.totalTax = totalTax
        self.totalInclTax = totalInclTax
        self.taxRate = taxRate
        self.comments = comments
        super.init(id: id, rang: rang)
    }

	required public init(from decoder: any Decoder) throws {
        do {
            #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
            Logger.logWithoutSignal("\(Self.self).init.decode", level: .info, category: .api)
            #endif
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.quantity = try container.decode(String.self, forKey: .quantity)
            self.unitPriceInclTax = try container.decode(String.self, forKey: .unitPriceInclTax)
            self.date = try container.decode(Int.self, forKey: .dateDecode)
            self.feeTypeId = try container.decode(String.self, forKey: .feeTypeId)
            self.feeTypeCode = try container.decode(String.self, forKey: .feeTypeCode)
            self.feeTypeLabel = try container.decode(String.self, forKey: .feeTypeLabel)
            self.totalExclTax = try container.decode(String.self, forKey: .totalExclTax)
            self.totalTax = try container.decode(String.self, forKey: .totalTax)
            self.totalInclTax = try container.decode(String.self, forKey: .totalInclTax)
            self.taxRate = try container.decode(String.self, forKey: .taxRateDecode)
            self.comments = try container.decodeIfPresent(String.self, forKey: .comments)
            try super.init(from: decoder)
            #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
            Logger.logWithoutSignal("\(Self.self).init.decoded", level: .info, category: .api)
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
    
    public init(copying source: DolibarrExpenseReportLine) {
        self.quantity = source.quantity
        self.unitPriceInclTax = source.unitPriceInclTax
        self.date = source.date
        self.feeTypeId = source.feeTypeId
        self.feeTypeCode = source.feeTypeCode
        self.feeTypeLabel = source.feeTypeLabel
        self.totalExclTax = source.totalExclTax
        self.totalTax = source.totalTax
        self.totalInclTax = source.totalInclTax
        self.taxRate = source.taxRate
        self.comments = source.comments
        super.init(copying: source)
    }

    // MARK: - Methods

    public func copy(_ source: DolibarrExpenseReportLine) {
        self.quantity = source.quantity
        self.unitPriceInclTax = source.unitPriceInclTax
        self.date = source.date
        self.feeTypeId = source.feeTypeId
        self.feeTypeCode = source.feeTypeCode
        self.feeTypeLabel = source.feeTypeLabel
        self.totalExclTax = source.totalExclTax
        self.totalTax = source.totalTax
        self.totalInclTax = source.totalInclTax
        self.taxRate = source.taxRate
        self.comments = source.comments
        super.copy(source)
    }

    // MARK: - Protocol methods

	override public func hash(into hasher: inout Hasher) {
        hasher.combine(quantity)
		hasher.combine(unitPriceInclTax)
        hasher.combine(date)
		hasher.combine(feeTypeId)
		hasher.combine(feeTypeCode)
		hasher.combine(feeTypeLabel)
		hasher.combine(totalExclTax)
		hasher.combine(totalTax)
		hasher.combine(totalInclTax)
		hasher.combine(taxRate)
        hasher.combine(optional: comments)
        super.hash(into: &hasher)
    }

	override public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(quantity, forKey: .quantity)
		try container.encode(unitPriceInclTax, forKey: .unitPriceInclTax)
		try container.encode(date, forKey: .dateEncode)
		try container.encode(feeTypeId, forKey: .feeTypeId)
		try container.encode(feeTypeCode, forKey: .feeTypeCode)
		try container.encode(feeTypeLabel, forKey: .feeTypeLabel)
		try container.encode(totalExclTax, forKey: .totalExclTax)
		try container.encode(totalTax, forKey: .totalTax)
		try container.encode(totalInclTax, forKey: .totalInclTax)
		try container.encode(taxRate, forKey: .taxRateEncode)
		try container.encodeIfPresent(comments, forKey: .comments)
        try super.encode(to: encoder)
    }

	static public func == (lhs: DolibarrExpenseReportLine, rhs: DolibarrExpenseReportLine) -> Bool {
		lhs.quantity == rhs.quantity &&
		lhs.unitPriceInclTax == rhs.unitPriceInclTax &&
		lhs.date == rhs.date &&
		lhs.feeTypeId == rhs.feeTypeId &&
		lhs.feeTypeCode == rhs.feeTypeCode &&
		lhs.feeTypeLabel == rhs.feeTypeLabel &&
		lhs.totalExclTax == rhs.totalExclTax &&
		lhs.totalTax == rhs.totalTax &&
		lhs.totalInclTax == rhs.totalInclTax &&
		lhs.taxRate == rhs.taxRate &&
		lhs.comments == rhs.comments &&
		(lhs as CommonBusinessObjectLine) == (rhs as CommonBusinessObjectLine)
	}

}
