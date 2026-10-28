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
//  DolibarrContact.swift
//  SwiftDolibarr
//
//  Created by William Mead on 16/12/2024.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A Dolibarr contact object.
///
/// Maps to the Dolibarr `/contacts` REST API endpoint. A contact is
/// typically associated with a ``DolibarrThirdParty`` via ``socid``.
///
/// ## Overview
///
/// Includes personal details such as name, phone numbers, email, address,
/// job position, and social network links.
///
/// - Note: Requires the **Societe** module to be activated in Dolibarr.
/// - SeeAlso: ``DolibarrThirdParty``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrContact: CommonBusinessObject, DolibarrPeopleObject, Locatable {

	// MARK: - Properties

	// Required

	/// Contact last name
	public var lastname: String

	// Optional

	/// Contact country ID (address)
	///
	/// - Mapped Dolibarr property: **country_id**
	public var countryId: String?

	/// Contact country code (address)
	///
	/// - Mapped Dolibarr property: **country_code**
	public var countryCode: String?

	/// Contact email address
	public var email: String?

	/// Contact first name
	public var firstname: String?

	/// Contact civility code
	///
	/// - Mapped Dolibarr property: **civility_code**
	public var titleCode: String?

	/// Contact address lines
	public var address: String?

	/// Contact zip code (address)
	///
	/// - Mapped Dolibarr property: **zip**
	public var zipCode: String?

	/// Contact city (address)
	///
	/// - Mapped Dolibarr property: **town**
	public var city: String?

	/// Contact job position
	public var poste: String?

	/// Associated third party ID
	public var socid: String?

	/// Contact social networks
	public var socialnetworks: [String: String]?

	/// Contact professional phone number
	///
	/// - Mapped Dolibarr property: **phone_pro**
	public var phonePro: String?

	/// Contact personal phone number
	///
	/// - Mapped Dolibarr property: **phone_perso**
	public var phonePerso: String?

	/// Contact mobile phone number
	///
	/// - Mapped Dolibarr property: **phone_mobile**
	public var phoneMobile: String?

	/// Contact fax number
	public var fax: String?

	/// Contact birthday (Unix timestamp)
	public var birthday: Int?

	// Computed

	/// Associated contact status type
	override public var status: DolibarrObjectStatus {
		guard let status = DolibarrObjectStatus.thirdPartiesContacts.first(where: { $0.code == statusCode }) else {
			return .unknown
		}
		return status
	}

	/// Contact full name (firstname + lastname)
	public var name: String {
		guard let firstname = firstname, !firstname.isEmpty else { return lastname }
		return "\(firstname) \(lastname)"
	}

	// MARK: - Enums

	enum CodingKeys: String, CodingKey {
		case countryId = "country_id"
		case countryCode = "country_code"
		case email
		case lastname
		case firstname
		case titleCode = "civility_code"
		case address
		case zipCode = "zip"
		case city = "town"
		case poste
		case socid
		case socialnetworks
		case phonePro = "phone_pro"
		case phonePerso = "phone_perso"
		case phoneMobile = "phone_mobile"
		case fax
		case birthday
	}

	// MARK: - Inits

	public init(
		countryId: String? = nil,
		countryCode: String? = nil,
		email: String? = nil,
		lastname: String = "",
		firstname: String? = nil,
		titleCode: String? = nil,
		address: String? = nil,
		zipCode: String? = nil,
		city: String? = nil,
		poste: String? = nil,
		socid: String? = nil,
		socialnetworks: [String: String]? = [:],
		phonePro: String? = nil,
		phonePerso: String? = nil,
		phoneMobile: String? = nil,
		fax: String? = nil,
		birthday: Int? = nil,
		id: String = "",
		statusCode: String = "",
		arrayOptions: [String: MultiType]? = nil,
		notePublic: String? = nil,
		notePrivate: String? = nil
	) {
		self.countryId = countryId
		self.countryCode = countryCode
		self.email = email
		self.lastname = lastname
		self.firstname = firstname
		self.titleCode = titleCode
		self.address = address
		self.zipCode = zipCode
		self.city = city
		self.poste = poste
		self.socid = socid
		self.socialnetworks = socialnetworks
		self.phonePro = phonePro
		self.phonePerso = phonePerso
		self.phoneMobile = phoneMobile
		self.fax = fax
		self.birthday = birthday
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
			Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
			#endif
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.countryId = try container.decodeIfPresent(String.self, forKey: .countryId)
			self.countryCode = try container.decodeIfPresent(String.self, forKey: .countryCode)
			self.email = try? container.decodeIfPresent(String.self, forKey: .email)
			self.lastname = try container.decode(String.self, forKey: .lastname)
			self.firstname = try container.decodeIfPresent(String.self, forKey: .firstname)
			self.titleCode = try container.decodeIfPresent(String.self, forKey: .titleCode)
			self.address = try container.decodeIfPresent(String.self, forKey: .address)
			self.zipCode = try container.decodeIfPresent(String.self, forKey: .zipCode)
			self.city = try container.decodeIfPresent(String.self, forKey: .city)
			self.poste = try container.decodeIfPresent(String.self, forKey: .poste)
			self.socid = try container.decodeIfPresent(String.self, forKey: .socid)
			if let dictSocialnetworks = try? container.decode([String: String].self, forKey: .socialnetworks) {
				self.socialnetworks = dictSocialnetworks
			} else {
				self.socialnetworks = nil
			}
			self.phonePro = try container.decodeIfPresent(String.self, forKey: .phonePro)
			self.phonePerso = try container.decodeIfPresent(String.self, forKey: .phonePerso)
			self.phoneMobile = try container.decodeIfPresent(String.self, forKey: .phoneMobile)
			self.fax = try container.decodeIfPresent(String.self, forKey: .fax)
			if let birthday = try? container.decodeIfPresent(Int.self, forKey: .birthday) {
				self.birthday = birthday
			} else {
				self.birthday = nil
			}
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
    
    public init(copying source: DolibarrContact) {
        self.countryId = source.countryId
        self.countryCode = source.countryCode
        self.email = source.email
        self.lastname = source.lastname
        self.firstname = source.firstname
        self.titleCode = source.titleCode
        self.address = source.address
        self.zipCode = source.zipCode
        self.city = source.city
        self.poste = source.poste
        self.socid = source.socid
        self.socialnetworks = source.socialnetworks
        self.phonePro = source.phonePro
        self.phonePerso = source.phonePerso
        self.phoneMobile = source.phoneMobile
        self.fax = source.fax
        self.birthday = source.birthday
        super.init(copying: source)
    }
    
    // MARK: - Methods
    
    public func copy(_ source: DolibarrContact) {
        self.countryId = source.countryId
        self.countryCode = source.countryCode
        self.email = source.email
        self.lastname = source.lastname
        self.firstname = source.firstname
        self.titleCode = source.titleCode
        self.address = source.address
        self.zipCode = source.zipCode
        self.city = source.city
        self.poste = source.poste
        self.socid = source.socid
        self.socialnetworks = source.socialnetworks
        self.phonePro = source.phonePro
        self.phonePerso = source.phonePerso
        self.phoneMobile = source.phoneMobile
        self.fax = source.fax
        self.birthday = source.birthday
        super.copy(source)
    }

	// MARK: - Protocol methods

	override public func hash(into hasher: inout Hasher) {
		hasher.combine(lastname)
		hasher.combine(optional: countryId)
		hasher.combine(optional: countryCode)
		hasher.combine(optional: email)
		hasher.combine(optional: firstname)
		hasher.combine(optional: titleCode)
		hasher.combine(optional: address)
		hasher.combine(optional: zipCode)
		hasher.combine(optional: city)
		hasher.combine(optional: poste)
		hasher.combine(optional: socid)
		hasher.combine(optional: socialnetworks)
		hasher.combine(optional: phonePro)
		hasher.combine(optional: phonePerso)
		hasher.combine(optional: phoneMobile)
		hasher.combine(optional: fax)
		hasher.combine(optional: birthday)
		super.hash(into: &hasher)
	}

	override public func isEqual(to other: CommonBusinessObject) -> Bool {
		guard let other = other as? DolibarrContact else { return false }
		return lastname == other.lastname
		&& countryId == other.countryId
		&& countryCode == other.countryCode
		&& email == other.email
		&& firstname == other.firstname
		&& titleCode == other.titleCode
		&& address == other.address
		&& zipCode == other.zipCode
		&& city == other.city
		&& poste == other.poste
		&& socid == other.socid
		&& socialnetworks == other.socialnetworks
		&& phonePro == other.phonePro
		&& phonePerso == other.phonePerso
		&& phoneMobile == other.phoneMobile
		&& fax == other.fax
		&& birthday == other.birthday
		&& super.isEqual(to: other)
	}

	override public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfNotEmpty(lastname, forKey: .lastname)
		try container.encodeIfPresent(countryId, forKey: .countryId)
		try container.encodeIfPresent(countryCode, forKey: .countryCode)
		try container.encodeIfPresent(email, forKey: .email)
		try container.encodeIfPresent(firstname, forKey: .firstname)
		try container.encodeIfPresent(titleCode, forKey: .titleCode)
		try container.encodeIfPresent(address, forKey: .address)
		try container.encodeIfPresent(zipCode, forKey: .zipCode)
		try container.encodeIfPresent(city, forKey: .city)
		try container.encodeIfPresent(poste, forKey: .poste)
		try container.encodeIfPresent(socid, forKey: .socid)
		try container.encodeIfPresent(phonePro, forKey: .phonePro)
		try container.encodeIfPresent(phonePerso, forKey: .phonePerso)
		try container.encodeIfPresent(phoneMobile, forKey: .phoneMobile)
		try container.encodeIfPresent(fax, forKey: .fax)
		try container.encodeIfPresent(socialnetworks, forKey: .socialnetworks)
		try container.encodeIfPresent(birthday, forKey: .birthday)
		try super.encode(to: encoder)
	}

}
