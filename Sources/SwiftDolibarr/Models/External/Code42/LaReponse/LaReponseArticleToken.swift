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
//  LaReponseArticleToken.swift
//  SwiftDolibarr
//
//  Created by William Mead on 09/11/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A LaReponse article publish token from the external Dolibarr module.
///
/// Returned by the `GET` and `POST /lareponse/articles/{id}/token` REST API endpoints.
/// The ``publishToken`` gives public access to a published ``LaReponseArticle``.
///
/// - Note: Requires the **LaReponse** external module by CODE42.
/// - SeeAlso: ``LaReponseArticle``
public struct LaReponseArticleToken: Hashable, Decodable, Sendable {

    // MARK: - Properties

    /// Article ID.
    public var id: Int

    /// Article public token.
    ///
    /// - Mapped Dolibarr property: **publish_token**
    public var publishToken: String

    // MARK: - Enums

    enum CodingKeys: String, CodingKey {
        case id
        case publishToken = "publish_token"
    }

    // MARK: - Inits

    public init(
        id: Int = 0,
        publishToken: String = "",
    ) {
        self.id = id
        self.publishToken = publishToken
    }

    public init(from decoder: any Decoder) throws {
        do {
            #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
            Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
            #endif
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: .id)
            self.publishToken = try container.decode(String.self, forKey: .publishToken)
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
