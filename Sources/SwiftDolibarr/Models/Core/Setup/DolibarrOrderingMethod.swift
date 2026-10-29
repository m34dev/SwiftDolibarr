// Copyright 2026 M34D - William Mead
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//
//  DolibarrOrderingMethod.swift
//  SwiftDolibarr
//
//  Created by William Mead on 29/10/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A Dolibarr ordering method.
///
/// Maps to the Dolibarr `/setup/dictionary/ordering_methods` REST API endpoint
/// (table `c_input_method`). Each ordering method has a ``code``
/// (e.g. `OrderByMail`, `OrderByPhone`, `OrderByWWW`) and a ``label`` for display.
///
/// - Note: The ordering method ID is required when ordering a supplier order
///   via `POST /supplierorders/{id}/makeorder`.
/// - SeeAlso: ``DolibarrSupplierOrder``
public struct DolibarrOrderingMethod: Hashable, Decodable, Sendable, DolibarrObject {

    // MARK: - Properties

    /// Ordering method ID.
    public var id: String

    /// Ordering method code (e.g. `OrderByMail`, `OrderByPhone`, `OrderByWWW`).
    public var code: String

    /// Display label for the ordering method.
    public var label: String

    // MARK: - Enums

    enum CodingKeys: String, CodingKey {
        case id = "rowid"
        case code
        case label
    }

    // MARK: - Inits

    public init(
        id: String = "",
        code: String = "",
        label: String = "",
    ) {
        self.id = id
        self.code = code
        self.label = label
    }

    public init(from decoder: any Decoder) throws {
        do {
            #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
            Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
            #endif
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(MultiType.self, forKey: .id).stringValue
            self.code = try container.decode(String.self, forKey: .code)
            self.label = try container.decode(String.self, forKey: .label)
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
