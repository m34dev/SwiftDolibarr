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
//  DolibarrThirdParty.swift
//  SwiftDolibarr
//
//  Created by William Mead on 30/10/2024.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A Dolibarr third party (company / individual) object.
///
/// Maps to the Dolibarr `/thirdparties` REST API endpoint. A third party
/// can be a customer, a prospect, a supplier, or a combination of these,
/// controlled by the ``client`` and ``supplier`` properties.
///
/// ## Overview
///
/// Includes contact information, address details, professional IDs,
/// legal entity data, and social network links.
///
/// - Note: Requires the **Societe** module to be activated in Dolibarr.
/// - SeeAlso: ``DolibarrContact``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrThirdParty: CommonBusinessObject, DolibarrPeopleObject, Locatable {

    // MARK: - Properties

	// Required

	/// Third party name
	public var name: String

	// Optional

	/// Third party country ID (address)
	///
	/// - Mapped Dolibarr property: **country_id**
	public var countryId: String?

	/// Third party country code (address)
	///
	/// - Mapped Dolibarr property: **country_code**
	public var countryCode: String?

	/// Third party multicurrency code
	///
	/// - Mapped Dolibarr property: **multicurrency_code**
	public var multicurrencyCode: String?

	/// Third party alias
	///
	/// - Mapped Dolibarr property: **name_alias**
	public var nameAlias: String?

	/// Third party telephone number
	public var phone: String?

	/// Third party fax number
	public var fax: String?

	/// Third party email address
	public var email: String?

	/// Third party website address
	public var url: String?

	/// Third party professional ID 1 (e.g. SIREN for France)
	public var idprof1: String?

	/// Third party professional ID 2 (e.g. SIRET for France)
	public var idprof2: String?

	/// Third party professional ID 3 (e.g. APE code for France)
	public var idprof3: String?

	/// Third party professional ID 4 (e.g. RCS for France)
	public var idprof4: String?

	/// Third party professional ID 5
	public var idprof5: String?

	/// Third party intra-community VAT number
	///
	/// - Mapped Dolibarr property: **tva_intra**
	public var tvaIntra: String?

	/// Financial capital of third party company
	public var capital: String?

	/// Third party intra-community VAT number
	///
	/// - Mapped Dolibarr property: **effectif**
	public var workforce: String?

	/// Third party legal entity type
	///
	/// - Mapped Dolibarr property: **forme_juridique**
	public var legalEntityType: String?

	/// Third party client state
	///
	/// - States:
	/// 0 = not customer
	/// 1 = customer not prospect
	/// 2 = prospect not customer
	/// 3 = customer and prospect
	public var client: String?

	/// Third party supplier state
	///
	/// - States:
	/// 0 = not supplier
	/// 1 = supplier
	///
	/// - Mapped Dolibarr property: **fournisseur**
	public var supplier: String?

	/// Third party customer code (e.g. CU2026-0001)
	///
	/// - Mapped Dolibarr property: **code_client**
	public var clientCode: String?

	/// Third party supplier code (e.g. SU2026-0001)
	///
	/// - Mapped Dolibarr property: **code_fournisseur**
	public var supplierCode: String?

	/// Third party parent third party ID
	///
	/// - Mapped Dolibarr property: **parent**
	public var parentId: String?

	/// Third party social networks array
	public var socialnetworks: [String: String]?

	/// Third party address lines
	public var address: String?

	/// Third party zip code (address)
	///
	/// - Mapped Dolibarr property: **zip**
	public var zipCode: String?

	/// Third party number of employees
	///
	/// - Mapped Dolibarr property: **town**
	public var city: String?

	// Computed

	/// Third party website URL, computed from ``url``
	///
	/// Prepends `https://` when the string has no scheme.
	/// Returns `nil` when ``url`` is missing, empty, or not a valid URL.
	public var websiteURL: URL? {
		guard let url, !url.isEmpty else { return nil }
		return URL(string: url.contains("://") ? url : "https://" + url)
	}

	/// Associated third party status type
	override public var status: DolibarrObjectStatus {
		guard let status = DolibarrObjectStatus.thirdPartiesContacts.first(where: { $0.code == statusCode }) else {
			return .unknown
		}
		return status
	}

    // MARK: - Enums

    enum CodingKeys: String, CodingKey {
        case name
        case countryId = "country_id"
        case countryCode = "country_code"
        case multicurrencyCode = "multicurrency_code"
        case nameAlias = "name_alias"
        case phone
        case fax
        case email
        case url
        case idprof1
        case idprof2
        case idprof3
        case idprof4
        case idprof5
        case tvaIntra = "tva_intra"
        case capital
        case workforce = "effectif"
        case legalEntityType = "forme_juridique"
        case client
        case supplier = "fournisseur"
        case clientCode = "code_client"
        case supplierCode = "code_fournisseur"
        case parentId = "parent"
        case socialnetworks
        case address
        case zipCode = "zip"
        case city = "town"
    }

    // MARK: - Inits

	public init(
        name: String = "",
        countryId: String? = nil,
        countryCode: String? = nil,
        multicurrencyCode: String? = nil,
        nameAlias: String? = nil,
        phone: String? = nil,
        fax: String? = nil,
        email: String? = nil,
        url: String? = nil,
        idprof1: String? = nil,
        idprof2: String? = nil,
        idprof3: String? = nil,
        idprof4: String? = nil,
        idprof5: String? = nil,
        tvaIntra: String? = nil,
        capital: String? = nil,
        workforce: String? = nil,
        legalEntityType: String? = nil,
        client: String? = nil,
        supplier: String? = nil,
        clientCode: String? = nil,
        supplierCode: String? = nil,
        parentId: String? = nil,
        socialnetworks: [String: String]? = nil,
        address: String? = nil,
        zipCode: String? = nil,
        city: String? = nil,
        id: String = "",
        statusCode: String = "",
        arrayOptions: [String: MultiType]? = nil,
        notePublic: String? = nil,
        notePrivate: String? = nil
    ) {
        self.name = name
        self.countryId = countryId
        self.countryCode = countryCode
        self.multicurrencyCode = multicurrencyCode
        self.nameAlias = nameAlias
        self.phone = phone
        self.fax = fax
        self.email = email
        self.url = url
        self.idprof1 = idprof1
        self.idprof2 = idprof2
        self.idprof3 = idprof3
        self.idprof4 = idprof4
        self.idprof5 = idprof5
        self.tvaIntra = tvaIntra
        self.capital = capital
        self.workforce = workforce
        self.legalEntityType = legalEntityType
        self.client = client
        self.supplier = supplier
        self.clientCode = clientCode
        self.supplierCode = supplierCode
        self.parentId = parentId
        self.socialnetworks = socialnetworks
        self.address = address
        self.zipCode = zipCode
        self.city = city
		super.init(
			id: id, statusCode: statusCode,
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
            self.name = try container.decode(String.self, forKey: .name)
			self.countryId = try container.decodeIfPresent(MultiType.self, forKey: .countryId)?.stringValue
            self.countryCode = try container.decodeIfPresent(String.self, forKey: .countryCode)
            self.multicurrencyCode = try container.decodeIfPresent(String.self, forKey: .multicurrencyCode)
            self.nameAlias = try container.decodeIfPresent(String.self, forKey: .nameAlias)
            self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
            self.fax = try container.decodeIfPresent(String.self, forKey: .fax)
            self.email = try container.decodeIfPresent(String.self, forKey: .email)
            self.url = try container.decodeIfPresent(String.self, forKey: .url)
            self.idprof1 = try container.decodeIfPresent(String.self, forKey: .idprof1)
            self.idprof2 = try container.decodeIfPresent(String.self, forKey: .idprof2)
            self.idprof3 = try container.decodeIfPresent(String.self, forKey: .idprof3)
            self.idprof4 = try container.decodeIfPresent(String.self, forKey: .idprof4)
            self.idprof5 = try container.decodeIfPresent(String.self, forKey: .idprof5)
            self.tvaIntra = try container.decodeIfPresent(String.self, forKey: .tvaIntra)
			self.capital = try container.decodeIfPresent(MultiType.self, forKey: .capital)?.stringValue
            self.workforce = try container.decodeIfPresent(String.self, forKey: .workforce)
            self.legalEntityType = try container.decodeIfPresent(String.self, forKey: .legalEntityType)
            self.client = try container.decodeIfPresent(String.self, forKey: .client)
            self.supplier = try container.decodeIfPresent(String.self, forKey: .supplier)
            self.clientCode = try container.decodeIfPresent(String.self, forKey: .clientCode)
            self.supplierCode = try container.decodeIfPresent(String.self, forKey: .supplierCode)
            self.parentId = try container.decodeIfPresent(String.self, forKey: .parentId)
            if let dictSocialnetworks = try? container.decode([String: String].self, forKey: .socialnetworks) {
                self.socialnetworks = dictSocialnetworks
            } else {
                self.socialnetworks = nil
            }
            self.address = try container.decodeIfPresent(String.self, forKey: .address)
			self.zipCode = try container.decodeIfPresent(String.self, forKey: .zipCode)
			self.city = try container.decodeIfPresent(String.self, forKey: .city)
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
    
    public init(copying source: DolibarrThirdParty) {
        self.name = source.name
        self.countryId = source.countryId
        self.countryCode = source.countryCode
        self.multicurrencyCode = source.multicurrencyCode
        self.nameAlias = source.nameAlias
        self.phone = source.phone
        self.fax = source.fax
        self.email = source.email
        self.url = source.url
        self.idprof1 = source.idprof1
        self.idprof2 = source.idprof2
        self.idprof3 = source.idprof3
        self.idprof4 = source.idprof4
        self.idprof5 = source.idprof5
        self.tvaIntra = source.tvaIntra
        self.capital = source.capital
        self.workforce = source.workforce
        self.legalEntityType = source.legalEntityType
        self.client = source.client
        self.supplier = source.supplier
        self.clientCode = source.clientCode
        self.supplierCode = source.supplierCode
        self.parentId = source.parentId
        self.socialnetworks = source.socialnetworks
        self.address = source.address
        self.zipCode = source.zipCode
        self.city = source.city
        super.init(copying: source)
    }
    
    // MARK: - Methods
    
    public func copy(_ source: DolibarrThirdParty) {
        self.name = source.name
        self.countryId = source.countryId
        self.countryCode = source.countryCode
        self.multicurrencyCode = source.multicurrencyCode
        self.nameAlias = source.nameAlias
        self.phone = source.phone
        self.fax = source.fax
        self.email = source.email
        self.url = source.url
        self.idprof1 = source.idprof1
        self.idprof2 = source.idprof2
        self.idprof3 = source.idprof3
        self.idprof4 = source.idprof4
        self.idprof5 = source.idprof5
        self.tvaIntra = source.tvaIntra
        self.capital = source.capital
        self.workforce = source.workforce
        self.legalEntityType = source.legalEntityType
        self.client = source.client
        self.supplier = source.supplier
        self.clientCode = source.clientCode
        self.supplierCode = source.supplierCode
        self.parentId = source.parentId
        self.socialnetworks = source.socialnetworks
        self.address = source.address
        self.zipCode = source.zipCode
        self.city = source.city
        super.copy(source)
    }

    // MARK: - Protocol methods

    override public func hash(into hasher: inout Hasher) {
		hasher.combine(name)
		hasher.combine(optional: countryId)
		hasher.combine(optional: countryCode)
		hasher.combine(optional: multicurrencyCode)
		hasher.combine(optional: nameAlias)
		hasher.combine(optional: phone)
		hasher.combine(optional: fax)
		hasher.combine(optional: email)
		hasher.combine(optional: url)
		hasher.combine(optional: idprof1)
		hasher.combine(optional: idprof2)
		hasher.combine(optional: idprof3)
		hasher.combine(optional: idprof4)
		hasher.combine(optional: idprof5)
		hasher.combine(optional: tvaIntra)
		hasher.combine(optional: capital)
		hasher.combine(optional: workforce)
		hasher.combine(optional: legalEntityType)
		hasher.combine(optional: client)
		hasher.combine(optional: supplier)
		hasher.combine(optional: clientCode)
		hasher.combine(optional: supplierCode)
		hasher.combine(optional: parentId)
		hasher.combine(optional: socialnetworks)
		hasher.combine(optional: address)
		hasher.combine(optional: zipCode)
		hasher.combine(optional: city)
		super.hash(into: &hasher)
    }

    override public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfNotEmpty(name, forKey: .name)
		try container.encodeIfPresent(countryId, forKey: .countryId)
		try container.encodeIfPresent(countryCode, forKey: .countryCode)
		try container.encodeIfPresent(multicurrencyCode, forKey: .multicurrencyCode)
		try container.encodeIfPresent(nameAlias, forKey: .nameAlias)
		try container.encodeIfPresent(phone, forKey: .phone)
		try container.encodeIfPresent(fax, forKey: .fax)
		try container.encodeIfPresent(email, forKey: .email)
		try container.encodeIfPresent(url, forKey: .url)
		try container.encodeIfPresent(idprof1, forKey: .idprof1)
		try container.encodeIfPresent(idprof2, forKey: .idprof2)
		try container.encodeIfPresent(idprof3, forKey: .idprof3)
		try container.encodeIfPresent(idprof4, forKey: .idprof4)
		try container.encodeIfPresent(idprof5, forKey: .idprof5)
		try container.encodeIfPresent(tvaIntra, forKey: .tvaIntra)
		try container.encodeIfPresent(capital, forKey: .capital)
		try container.encodeIfPresent(workforce, forKey: .workforce)
		try container.encodeIfPresent(legalEntityType, forKey: .legalEntityType)
		try container.encodeIfPresent(client, forKey: .client)
		try container.encodeIfPresent(supplier, forKey: .supplier)
		try container.encodeIfPresent(clientCode, forKey: .clientCode)
		try container.encodeIfPresent(supplierCode, forKey: .supplierCode)
		try container.encodeIfPresent(parentId, forKey: .parentId)
		try container.encodeIfPresent(socialnetworks, forKey: .socialnetworks)
		try container.encodeIfPresent(address, forKey: .address)
		try container.encodeIfPresent(zipCode, forKey: .zipCode)
		try container.encodeIfPresent(city, forKey: .city)
		try super.encode(to: encoder)
    }

}
