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
//  DolibarrUser.swift
//  SwiftDolibarr
//
//  Created by William Mead on 26/12/2024.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A Dolibarr user object.
///
/// Maps to the Dolibarr `/users` REST API endpoint. Includes authentication
/// credentials, identity information, and module-level permissions via ``rights``.
///
/// - Note: Requires the **User** module included in Dolibarr core.
/// - SeeAlso: ``DolibarrUserPermissions``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrUser: CommonBusinessObject {

	// MARK: - Properties

	public var admin: String
	public var login: String
	public var lastname: String
	public var firstname: String?
	public var supervisorId: String?
	public var rights: DolibarrUserPermissions?

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case admin
		case login
		case lastname
		case firstname
		case supervisorId = "fk_user"
		case rights
	}

	// MARK: - Inits

	public init(
		admin: String = "",
		login: String = "",
		lastname: String = "",
		firstname: String? = nil,
		supervisorId: String? = nil,
		rights: DolibarrUserPermissions? = nil,
		id: String = "",
		statusCode: String = "",
		arrayOptions: [String: MultiType]? = nil,
		notePublic: String? = nil,
		notePrivate: String? = nil
	) {
		self.admin = admin
		self.login = login
		self.lastname = lastname
		self.firstname = firstname
		self.supervisorId = supervisorId
		self.rights = rights
		super.init(
			id: id,
			statusCode: statusCode,
			arrayOptions: arrayOptions,
			notePublic: notePublic,
			notePrivate: notePrivate
		)
	}

	public required init(from decoder: any Decoder) throws {
		do {
			#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
			Logger.logWithoutSignal("\(Self.self).init.decode", level: .info, category: .api)
			#endif
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.admin = try container.decode(String.self, forKey: .admin)
			self.login = try container.decode(String.self, forKey: .login)
			self.lastname = try container.decode(String.self, forKey: .lastname)
			self.firstname = try container.decodeIfPresent(String.self, forKey: .firstname)
			self.supervisorId = try container.decodeIfPresent(String.self, forKey: .supervisorId)
			self.rights = try container.decodeIfPresent(DolibarrUserPermissions.self, forKey: .rights)
			try super.init(from: decoder)
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
    
    public init(copying source: DolibarrUser) {
        self.admin = source.admin
        self.login = source.login
        self.lastname = source.lastname
        self.firstname = source.firstname
        self.supervisorId = source.supervisorId
        self.rights = source.rights
        super.init(copying: source)
    }
    
    // MARK: - Methods
    
    public func copy(_ source: DolibarrUser) {
        self.admin = source.admin
        self.login = source.login
        self.lastname = source.lastname
        self.firstname = source.firstname
        self.supervisorId = source.supervisorId
        self.rights = source.rights
        super.copy(source)
    }

	// MARK: - Protocol methods

	override public func hash(into hasher: inout Hasher) {
		hasher.combine(admin)
		hasher.combine(login)
		hasher.combine(lastname)
		hasher.combine(optional: firstname)
		hasher.combine(optional: supervisorId)
		hasher.combine(optional: rights)
		super.hash(into: &hasher)
	}

	override public func isEqual(to other: CommonBusinessObject) -> Bool {
		guard let other = other as? DolibarrUser else { return false }
		return admin == other.admin
		&& login == other.login
		&& lastname == other.lastname
		&& firstname == other.firstname
		&& supervisorId == other.supervisorId
		&& rights == other.rights
		&& super.isEqual(to: other)
	}

	override public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(admin, forKey: .admin)
		try container.encode(login, forKey: .login)
		try container.encode(lastname, forKey: .lastname)
		try container.encode(firstname, forKey: .firstname)
		try super.encode(to: encoder)
	}

}
