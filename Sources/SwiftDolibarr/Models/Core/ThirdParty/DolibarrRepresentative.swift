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
//  DolibarrRepresentative.swift
//  SwiftDolibarr
//
//  Created by William Mead on 09/11/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A Dolibarr sales representative of a third party.
///
/// Maps to the Dolibarr `/thirdparties/{id}/representatives` REST API endpoint.
/// Each representative is a Dolibarr user identified by its ``id``,
/// with a ``firstname`` and a ``lastname``.
///
/// - SeeAlso: ``DolibarrThirdParty``, ``DolibarrUser``
public struct DolibarrRepresentative: Hashable, Decodable, Sendable, DolibarrObject {

    // MARK: - Properties

    /// Representative user ID.
    public var id: String

    /// Representative last name.
    public var lastname: String

    /// Representative first name.
    public var firstname: String

    // MARK: - Enums

    enum CodingKeys: String, CodingKey {
        case id
        case lastname
        case firstname
    }

    // MARK: - Inits

    public init(
        id: String = "",
        lastname: String = "",
        firstname: String = "",
    ) {
        self.id = id
        self.lastname = lastname
        self.firstname = firstname
    }

    public init(from decoder: any Decoder) throws {
        do {
            #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
            Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
            #endif
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(MultiType.self, forKey: .id).stringValue
            self.lastname = try container.decodeIfPresent(String.self, forKey: .lastname) ?? ""
            self.firstname = try container.decodeIfPresent(String.self, forKey: .firstname) ?? ""
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
