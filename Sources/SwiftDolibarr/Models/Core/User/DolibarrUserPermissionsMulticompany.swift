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
//  DolibarrUserPermissionsMulticompany.swift
//  SwiftDolibarr
//
//  Created by William Mead on 07/07/2026.
//

import Foundation

/// Multicompany module permissions for a Dolibarr user.
///
/// - SeeAlso: ``DolibarrUserPermissions``
public struct DolibarrUserPermissionsMulticompany: Codable, Hashable {

    // MARK: - Properties

    public var read: Int?
    public var write: Int?
    public var delete: Int?
    public var create: Int?

    // MARK: - Enums

    enum CodingKeys: String, CodingKey {
        case read
        case write
        case delete
        case create
    }

    // MARK: - Inits

    public init(
        read: Int? = nil,
        write: Int? = nil,
        delete: Int? = nil,
        create: Int? = nil
    ) {
        self.read = read
        self.write = write
        self.delete = delete
        self.create = create
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.read = try container.decodeIfPresent(Int.self, forKey: .read)
        self.write = try container.decodeIfPresent(Int.self, forKey: .write)
        self.delete = try container.decodeIfPresent(Int.self, forKey: .delete)
        self.create = try container.decodeIfPresent(Int.self, forKey: .create)
    }

}
