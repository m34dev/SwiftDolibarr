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
//  LaReponseArticle.swift
//  SwiftDolibarr
//
//  Created by William Mead on 03/04/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A LaReponse article object from the external Dolibarr module.
///
/// Maps to the Dolibarr `/lareponse/articles` REST API endpoint.
/// Each article has a ``title``, ``content``, ``visibility`` setting,
/// and a ``publishToken`` for sharing.
///
/// - Note: Requires the **LaReponse** external module by CODE42.
/// - SeeAlso: ``LaReponseComment``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class LaReponseArticle: Hashable, Codable, DolibarrObject {

    // MARK: - Properties

    /// Article ID
    ///
    /// - Mapped Dolibarr property: **rowid**
    public var id: String

    /// Article creation date (Unix timestamp)
    ///
    /// - Mapped Dolibarr property: **date_creation**
    public var dateCreate: Int

    /// Article last modification (Unix timestamp)
    ///
    /// - Mapped Dolibarr property: **tms**
    public var dateModify: Int

    /// Article creator user ID
    ///
    /// - Mapped Dolibarr property: **fk_user_creat**
    public var userCreateId: Int

    /// Article last modifier user ID
    ///
    /// - Mapped Dolibarr property: **fk_user_modif**
    public var userModifyId: Int?

    /// Article title
    public var title: String

    /// Article content
    public var content: String?

    /// Article visibility setting
    ///
    /// - Mapped Dolibarr property: **private**
    public var visibilityCode: Int

    /// Article publish token for sharing
    ///
    /// - Mapped Dolibarr property: **publish_token**
    public var publishToken: String?

    /// Article type
    public var typeCode: Int
    
    /// Article favorite
    public var favorite: Int?
    
    /// Article entity ID
    ///
    /// - Mapped Dolibarr property: **entity**
    public var entityId: String?

    // MARK: - Computed properties

    /// Article creation date
    public var dateCreated: Date {
        Date(timeIntervalSince1970: TimeInterval(dateCreate))
    }

    /// Article last modification date
    public var dateModified: Date {
        Date(timeIntervalSince1970: TimeInterval(dateModify))
    }
    
    /// Article has been published
    public var isPublished: Bool {
        guard let publishToken else {
            return false
        }
        return publishToken.isEmpty ? false : true
    }
    
    public var type: ArticleType? {
        switch typeCode {
        case 0:
            return .article
        case 1:
            return .url
        default:
            return nil
        }
    }
    
    public var visibility: ArticleVisibility? {
        switch visibilityCode {
        case 0:
            return .internal
        case 1:
            return .private
        case 2:
            return .closed
        default:
            return nil
        }
    }
    
    public var isFavorite: Bool? {
        switch favorite {
        case 0:
            return false
        case 1:
            return true
        default:
            return nil
        }
    }

    // MARK: - Enums

    enum CodingKeys: String, CodingKey {
        case id = "rowid"
        case dateCreate = "date_creation"
        case dateModify = "tms"
        case userCreateId = "fk_user_creat"
        case userModifyId = "fk_user_modif"
        case title
        case content
        case visibilityCode = "private"
        case publishToken = "publish_token"
        case typeCode = "type"
        case favorite
        case entityId = "entity"
    }
    
    public enum ArticleType {
        case article
        case url
    }
    
    public enum ArticleVisibility {
        case `internal`
        case `private`
        case closed
    }

    // MARK: - Inits

    public init(
        id: String = "",
        dateCreate: Int = 0,
        dateModify: Int = 0,
        userCreateId: Int = 0,
        userModifyId: Int? = nil,
        title: String = "",
        content: String? = nil,
        visibilityCode: Int = 0,
        publishToken: String? = nil,
        typeCode: Int = 0,
        favorite: Int = 0,
        entityId: String = ""
    ) {
        self.id = id
        self.dateCreate = dateCreate
        self.dateModify = dateModify
        self.userCreateId = userCreateId
        self.userModifyId = userModifyId
        self.title = title
        self.content = content
        self.visibilityCode = visibilityCode
        self.publishToken = publishToken
        self.typeCode = typeCode
        self.favorite = favorite
        self.entityId = entityId
    }

    public required init(from decoder: any Decoder) throws {
        do {
            #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
            Logger.logWithoutSignal("\(Self.self).init.decode", level: .info, category: .api)
            #endif
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(MultiType.self, forKey: .id).stringValue
            self.dateCreate = try container.decode(Int.self, forKey: .dateCreate)
            self.dateModify = try container.decode(Int.self, forKey: .dateModify)
            self.userCreateId = try container.decode(Int.self, forKey: .userCreateId)
            self.userModifyId = try container.decodeIfPresent(Int.self, forKey: .userModifyId)
            self.title = try container.decode(String.self, forKey: .title)
            self.content = try container.decodeIfPresent(String.self, forKey: .content)
            self.visibilityCode = try container.decode(Int.self, forKey: .visibilityCode)
            self.publishToken = try container.decodeIfPresent(String.self, forKey: .publishToken)
            self.typeCode = try container.decode(Int.self, forKey: .typeCode)
            self.favorite = try container.decodeIfPresent(Int.self, forKey: .favorite)
            self.entityId = try container.decodeIfPresent(MultiType.self, forKey: .entityId)?.stringValue
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

    public init(copying source: LaReponseArticle) {
        self.id = source.id
        self.dateCreate = source.dateCreate
        self.dateModify = source.dateModify
        self.userCreateId = source.userCreateId
        self.userModifyId = source.userModifyId
        self.title = source.title
        self.content = source.content
        self.visibilityCode = source.visibilityCode
        self.publishToken = source.publishToken
        self.typeCode = source.typeCode
        self.favorite = source.favorite
        self.entityId = source.entityId
    }

    // MARK: - Methods

    public func copy(_ source: LaReponseArticle) {
        self.id = source.id
        self.dateCreate = source.dateCreate
        self.dateModify = source.dateModify
        self.userCreateId = source.userCreateId
        self.userModifyId = source.userModifyId
        self.title = source.title
        self.content = source.content
        self.visibilityCode = source.visibilityCode
        self.publishToken = source.publishToken
        self.typeCode = source.typeCode
        self.favorite = source.favorite
        self.entityId = source.entityId
    }

    // MARK: - Protocol methods

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(dateCreate)
        hasher.combine(dateModify)
        hasher.combine(userCreateId)
        hasher.combine(optional: userModifyId)
        hasher.combine(title)
        hasher.combine(optional: content)
        hasher.combine(visibilityCode)
        hasher.combine(optional: publishToken)
        hasher.combine(typeCode)
        hasher.combine(optional: favorite)
        hasher.combine(optional: entityId)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfNotEmpty(id, forKey: .id)
        try container.encodeIfNotZero(dateCreate, forKey: .dateCreate)
        try container.encodeIfNotZero(dateModify, forKey: .dateModify)
        try container.encodeIfNotZero(userCreateId, forKey: .userCreateId)
        try container.encodeIfPresentAndNotZero(userModifyId, forKey: .userModifyId)
        try container.encodeIfNotEmpty(title, forKey: .title)
        try container.encodeIfPresent(content, forKey: .content)
        try container.encode(visibilityCode, forKey: .visibilityCode)
        try container.encodeIfPresent(publishToken, forKey: .publishToken)
        try container.encode(typeCode, forKey: .typeCode)
        try container.encodeIfPresent(favorite, forKey: .favorite)
        try container.encodeIfPresent(entityId, forKey: .entityId)
    }

    public static func == (lhs: LaReponseArticle, rhs: LaReponseArticle) -> Bool {
        lhs.id == rhs.id
        && lhs.dateCreate == rhs.dateCreate
        && lhs.dateModify == rhs.dateModify
        && lhs.userCreateId == rhs.userCreateId
        && lhs.userModifyId == rhs.userModifyId
        && lhs.title == rhs.title
        && lhs.content == rhs.content
        && lhs.visibilityCode == rhs.visibilityCode
        && lhs.publishToken == rhs.publishToken
        && lhs.typeCode == rhs.typeCode
        && lhs.favorite == rhs.favorite
        && lhs.entityId == rhs.entityId
    }

}
