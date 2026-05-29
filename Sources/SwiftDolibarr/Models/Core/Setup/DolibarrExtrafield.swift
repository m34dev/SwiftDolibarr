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
//  DolibarrExtrafield.swift
//  SwiftDolibarr
//
//  Created by William Mead on 29/05/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A Dolibarr extrafield.
///
/// Maps to the Dolibarr `/setup/extrafields` REST API endpoint. Extrafields
/// are user-defined custom attributes attached to a specific Dolibarr object
/// (identified by ``elementType``), allowing the data model to be extended
/// without modifying core tables.
///
/// Each extrafield has a ``type`` (e.g. `varchar`, `int`, `date`, `select`),
/// a display ``label``, and optional metadata such as ``size``,
/// ``default``, ``computed`` expression, ``required`` / ``unique`` flags,
/// display ``position``, and ``visibility`` (list visibility).
///
/// - Note: The ``elementType`` value matches the Dolibarr element it extends
///   (e.g. `societe`, `facture`, `commande`, `propal`, `product`).
/// - SeeAlso: ``DolibarrObject``
public struct DolibarrExtrafield: Hashable, Decodable, Sendable, DolibarrObject {

    // MARK: - Properties

    // Required

    /// Extrafield ID.
    public var id: String

    /// Extrafield data type (e.g. `varchar`, `int`, `double`, `date`, `select`).
    public var type: String

    /// Display label for the extrafield.
    public var label: String

    /// Dolibarr element type this extrafield is attached to (e.g. `societe`,
    /// `facture`, `commande`, `product`).
    ///
    /// Mapped Dolibarr property: **elementtype**
    public var elementType: String

    // Optional

    /// Field size or length, when applicable to the ``type``.
    public var size: String?

    /// Default value applied when the extrafield is not set.
    public var `default`: String?

    /// Computed expression evaluated server-side to derive the field value.
    public var computed: String?

    /// Whether this extrafield is required (`"1"`) or not (`"0"`).
    public var required: String?

    /// Whether this extrafield enforces uniqueness (`"1"`) or not (`"0"`).
    public var unique: String?

    /// Display position used to order extrafields in the UI.
    ///
    /// Mapped Dolibarr property: **pos**
    public var position: String?

    /// List visibility flag controlling whether the extrafield appears in
    /// list views.
    ///
    /// Mapped Dolibarr property: **list**
    public var visibility: String?

    // MARK: - Enums

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case label
        case elementType = "elementtype"
        case size
        case `default`
        case computed
        case required
        case unique
        case position = "pos"
        case visibility = "list"
    }

    // MARK: - Inits

    public init(
        id: String = "",
        type: String = "",
        label: String = "",
        elementType: String = "",
        size: String? = nil,
        default: String? = nil,
        computed: String? = nil,
        required: String? = nil,
        unique: String? = nil,
        position: String? = nil,
        visibility: String? = nil
    ) {
        self.id = id
        self.type = type
        self.label = label
        self.elementType = elementType
        self.size = size
        self.default = `default`
        self.computed = computed
        self.required = required
        self.unique = unique
        self.position = position
        self.visibility = visibility
    }

    public init(from decoder: any Decoder) throws {
        do {
            #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
            Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
            #endif
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(String.self, forKey: .id)
            self.type = try container.decode(String.self, forKey: .type)
            self.label = try container.decode(String.self, forKey: .label)
            self.elementType = try container.decode(String.self, forKey: .elementType)
            self.size = try container.decodeIfPresent(String.self, forKey: .size)
            self.default = try container.decodeIfPresent(String.self, forKey: .default)
            self.computed = try container.decodeIfPresent(String.self, forKey: .computed)
            self.required = try container.decodeIfPresent(String.self, forKey: .required)
            self.unique = try container.decodeIfPresent(String.self, forKey: .unique)
            self.position = try container.decodeIfPresent(String.self, forKey: .position)
            self.visibility = try container.decodeIfPresent(String.self, forKey: .visibility)
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

/// Top-level response wrapper for `/setup/extrafields`.
///
/// Decodes the nested JSON structure (element type → field name → extrafield)
/// into an ordered array of ``DolibarrExtrafieldGroup`` for convenient
/// iteration.
///
/// - SeeAlso: ``DolibarrExtrafield``, ``DolibarrExtrafieldGroup``
public struct DolibarrExtrafields: Hashable, Decodable, Sendable {

    // MARK: - Properties

    /// Extrafield groups, one per Dolibarr element type.
    public var elementGroups: [DolibarrExtrafieldGroup]

    // MARK: - Inits

    public init(elementGroups: [DolibarrExtrafieldGroup] = []) {
        self.elementGroups = elementGroups
    }

    public init(from decoder: any Decoder) throws {
        do {
            #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
            Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
            #endif
            let container = try decoder.singleValueContainer()
            let raw = try container.decode([String: [String: DolibarrExtrafield]].self)
            self.elementGroups = raw.map { elementType, fields in
                DolibarrExtrafieldGroup(
                    elementType: elementType,
                    fields: Array(fields.values)
                )
            }
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

/// A group of extrafields attached to the same Dolibarr element type.
///
/// Produced when decoding a ``DolibarrExtrafields`` response — one group is
/// created per top-level JSON key (the element type, e.g. `societe`).
///
/// - SeeAlso: ``DolibarrExtrafield``, ``DolibarrExtrafields``
public struct DolibarrExtrafieldGroup: Hashable, Sendable {

    // MARK: - Properties

    /// The Dolibarr element type these extrafields are attached to
    /// (e.g. `societe`, `facture`, `commande`, `product`).
    public var elementType: String

    /// The extrafields defined for this element type.
    public var fields: [DolibarrExtrafield]

    // MARK: - Inits

    public init(
        elementType: String = "",
        fields: [DolibarrExtrafield] = []
    ) {
        self.elementType = elementType
        self.fields = fields
    }

}
