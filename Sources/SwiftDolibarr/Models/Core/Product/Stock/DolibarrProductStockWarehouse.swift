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
//  DolibarrProductStockWarehouse.swift
//  SwiftDolibarr
//
//  Created by William Mead on 02/07/2025.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A container mapping warehouse IDs to their stock levels for a product.
///
/// - SeeAlso: ``DolibarrProductWarehouseStock``
/// - SeeAlso: ``DolibarrProduct``
public struct DolibarrProductStockWarehouse: Hashable, Equatable, Decodable {

	// MARK: - Properties

    // Required

	public var stockWarehouses: [String: DolibarrProductWarehouseStock]

    // Optional

    public var stockReal: Int?
    public var stockTheoretical: Int?

    // MARK: - Enums

    enum CodingKeys: String, CodingKey {
        case stockReal = "stock_reel"
        case stockTheoretical = "stock_theorique"
        case stockWarehouse = "stock_warehouse"
        case stockWarehouses = "stock_warehouses"
    }

    // MARK: - Inits

    public init(
        stockWarehouses: [String : DolibarrProductWarehouseStock] = [:],
        stockReal: Int? = nil,
        stockTheoretical: Int? = nil
    ) {
        self.stockWarehouses = stockWarehouses
        self.stockReal = stockReal
        self.stockTheoretical = stockTheoretical
    }

    public init(from decoder: any Decoder) throws {
        do {
            #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
            Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
            #endif
            let container = try decoder.container(keyedBy: CodingKeys.self)
			if let empty = try? container.decode([String].self, forKey: .stockWarehouse), empty.isEmpty { // Workaround for Dolibarr returning empty array [] when no stock.
				self.stockWarehouses = [:]
			} else if let productStock = try? container.decode([String: DolibarrProductWarehouseStock].self, forKey: .stockWarehouse) {
                self.stockWarehouses = productStock
            } else if let productStock = try? container.decode([String: DolibarrProductWarehouseStock].self, forKey: .stockWarehouses) {
                self.stockWarehouses = productStock
			} else {
				self.stockWarehouses = [:]
			}
            self.stockReal = try container.decodeIfPresent(Int.self, forKey: .stockReal)
            self.stockTheoretical = try container.decodeIfPresent(Int.self, forKey: .stockTheoretical)
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

}

/// The stock level of a product in a specific warehouse.
///
/// - SeeAlso: ``DolibarrProductStockWarehouse``
/// - SeeAlso: ``DolibarrWarehouse``
public struct DolibarrProductWarehouseStock: Codable, Hashable, Equatable, DolibarrObject {

	// MARK: - Properties

	public var id: String
	public var real: String

}
