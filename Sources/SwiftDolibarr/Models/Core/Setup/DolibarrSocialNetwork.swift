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
//  DolibarrSocialNetwork.swift
//  SwiftDolibarr
//
//  Created by William Mead on 18/11/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A Dolibarr social network.
///
/// Maps to the Dolibarr `/setup/dictionary/socialnetworks` REST API endpoint
/// (table `c_socialnetworks`). Each entry has a ``code`` (e.g. `facebook`, `linkedin`),
/// which is the key used in ``DolibarrThirdParty/socialnetworks`` and ``DolibarrContact/socialnetworks``,
/// a ``label`` for display, and a ``url`` template where `{socialid}` is replaced by the stored value.
///
/// - Note: Dolibarr answers this endpoint with a 400 error when the Social networks module is disabled,
///   which is the only way for a non-admin user to know whether the module is enabled.
/// - SeeAlso: ``DolibarrThirdParty``, ``DolibarrContact``
public struct DolibarrSocialNetwork: Hashable, Decodable, Sendable, DolibarrObject {

    // MARK: - Properties

    /// Social network ID.
    ///
    /// - Mapped Dolibarr property: **rowid**
    public var id: String

    /// Social network code (e.g. `facebook`, `linkedin`, `twitter`, `whatsapp`).
    public var code: String

    /// Display label for the social network.
    public var label: String

    /// Link template, e.g. `https://www.facebook.com/{socialid}`.
    ///
    /// `{socialid}` alone means the stored value is used as is.
    public var url: String?

    /// Font Awesome icon name used by Dolibarr, e.g. `fa-facebook`.
    public var icon: String?

    /// Whether the social network is active in the dictionary.
    public var active: Bool

    // MARK: - Enums

    enum CodingKeys: String, CodingKey {
        case id = "rowid"
        case code
        case label
        case url
        case icon
        case active
    }

    // MARK: - Inits

    public init(
        id: String = "",
        code: String = "",
        label: String = "",
        url: String? = nil,
        icon: String? = nil,
        active: Bool = true
    ) {
        self.id = id
        self.code = code
        self.label = label
        self.url = url
        self.icon = icon
        self.active = active
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
            self.url = try container.decodeIfPresent(String.self, forKey: .url)
            self.icon = try container.decodeIfPresent(String.self, forKey: .icon)
            self.active = (try container.decodeIfPresent(MultiType.self, forKey: .active)?.intValue ?? 1) == 1
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
