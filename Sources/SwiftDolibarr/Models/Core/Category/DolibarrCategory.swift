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
//  DolibarrCategory.swift
//  SwiftDolibarr
//
//  Created by William Mead on 28/12/2024.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A Dolibarr category object.
///
/// Maps to the Dolibarr `/categories` REST API endpoint. Categories are used
/// to classify and organize other Dolibarr objects such as products, third parties,
/// contacts, and more.
///
/// ## Overview
///
/// Each category has a ``label``, an optional ``description``, and can be nested
/// under a parent category via ``parentId`` to form a tree structure.
///
/// - Note: Requires the **Categories** module to be activated in Dolibarr.
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrCategory: Equatable, Hashable, Codable, DolibarrObject {

    // MARK: - Properties

    // Required

    /// The unique identifier of the category.
    public var id: String

    /// The identifier of the parent category, or `0` if this is a root category.
    public var parentId: Int

    /// The display name of the category.
    public var label: String

    /// A textual description of the category.
    public var description: String

    // MARK: - Enums

    enum CodingKeys: String, CodingKey {
        case id
        case parentId = "fk_parent"
        case label
        case description
    }

    // MARK: - Inits

    public init(
        id: String = "",
        parentId: Int = 0,
        label: String = "",
        description: String = "",
    ) {
        self.id = id
        self.parentId = parentId
        self.label = label
        self.description = description
    }

    public init(from decoder: any Decoder) throws {
        do {
            #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
            Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
            #endif
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(String.self, forKey: .id)
            self.parentId = try container.decode(Int.self, forKey: .parentId)
            self.label = try container.decode(String.self, forKey: .label)
            self.description = try container.decode(String.self, forKey: .description)
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

    // MARK: - Protocol methods

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(parentId)
        hasher.combine(label)
        hasher.combine(description)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfNotEmpty(id, forKey: .id)
        try container.encode(parentId, forKey: .parentId)
        try container.encodeIfNotEmpty(label, forKey: .label)
        try container.encodeIfNotEmpty(description, forKey: .description)
    }

    public static func == (lhs: DolibarrCategory, rhs: DolibarrCategory) -> Bool {
        lhs.id == rhs.id
        && lhs.parentId == rhs.parentId
        && lhs.label == rhs.label
        && lhs.description == rhs.description
    }

}
