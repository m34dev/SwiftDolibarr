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
//  DolibarrOrganization.swift
//  SwiftDolibarr
//
//  Created by William Mead on 10/11/2026.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// The organization (own company) of a Dolibarr instance.
///
/// Returned by the Dolibarr `GET /setup/company` REST API endpoint, which is
/// open to admin users only, or to the login set in the
/// `API_LOGINS_ALLOWED_FOR_GET_COMPANY` constant.
///
/// Maps the Dolibarr `$mysoc` object, built from the `MAIN_INFO_SOCIETE_*`
/// constants. It is not a third party record, so it has no meaningful ID.
///
/// Empty strings sent by Dolibarr for unset values are decoded as `nil`.
///
/// Logo files are downloaded with `GET /documents/download` using
/// ``documentModulePart`` and ``logoOriginalFile(_:)``, which any API user can access.
///
/// - SeeAlso: ``DolibarrDownloadedDocument``
public struct DolibarrOrganization: Hashable, Codable, Sendable {

    // MARK: - Properties

    // Required

    /// Organization name.
    public var name: String

    // Optional

    /// Street address.
    public var address: String?

    /// Postal code.
    public var zip: String?

    /// Town.
    public var town: String?

    /// State or province ID, `nil` when none is set.
    ///
    /// - Mapped Dolibarr property: **state_id**
    public var stateId: String?

    /// State or province code.
    ///
    /// - Mapped Dolibarr property: **state_code**
    public var stateCode: String?

    /// Country ID, `nil` when none is set.
    ///
    /// - Mapped Dolibarr property: **country_id**
    public var countryId: String?

    /// Country ISO code (e.g. `FR`).
    ///
    /// - Mapped Dolibarr property: **country_code**
    public var countryCode: String?

    /// Main currency code (e.g. `EUR`), only sent by recent Dolibarr versions.
    ///
    /// - Mapped Dolibarr property: **currency_code**
    public var currencyCode: String?

    /// Default language (e.g. `fr_FR`).
    ///
    /// - Mapped Dolibarr property: **default_lang**
    public var defaultLanguage: String?

    /// Email address.
    public var email: String?

    /// Phone number.
    public var phone: String?

    /// Mobile phone number, only sent by recent Dolibarr versions.
    ///
    /// - Mapped Dolibarr property: **phone_mobile**
    public var phoneMobile: String?

    /// Website URL.
    public var url: String?

    /// Intra-community VAT number.
    ///
    /// - Mapped Dolibarr property: **tva_intra**
    public var vatNumber: String?

    /// Managers' names.
    public var managers: String?

    /// Main logo file name, stored in `logos/`.
    public var logo: String?

    /// Small main logo thumbnail file name, stored in `logos/thumbs/`.
    ///
    /// - Mapped Dolibarr property: **logo_small**
    public var logoSmall: String?

    /// Mini main logo thumbnail file name, stored in `logos/thumbs/`.
    ///
    /// - Mapped Dolibarr property: **logo_mini**
    public var logoMini: String?

    /// Squared logo file name, stored in `logos/`.
    ///
    /// - Mapped Dolibarr property: **logo_squarred**
    public var logoSquarred: String?

    /// Small squared logo thumbnail file name, stored in `logos/thumbs/`.
    ///
    /// - Mapped Dolibarr property: **logo_squarred_small**
    public var logoSquarredSmall: String?

    /// Mini squared logo thumbnail file name, stored in `logos/thumbs/`.
    ///
    /// - Mapped Dolibarr property: **logo_squarred_mini**
    public var logoSquarredMini: String?

    // MARK: - Static properties

    /// Module part to use with `GET /documents/download` to download logo files.
    public static let documentModulePart = "mycompany"

    // MARK: - Computed properties

    /// Original file of the logo best suited for display, or `nil` if no logo is set.
    ///
    /// Tries the small main logo, then the main logo, then the small squared logo, then the squared logo.
    public var preferredLogoOriginalFile: String? {
        logoOriginalFile(.small)
            ?? logoOriginalFile(.main)
            ?? logoOriginalFile(.squarredSmall)
            ?? logoOriginalFile(.squarred)
    }

    // MARK: - Enums

    /// Logo file variants.
    public enum LogoVariant: Sendable, CaseIterable {
        case main
        case small
        case mini
        case squarred
        case squarredSmall
        case squarredMini
    }

    enum CodingKeys: String, CodingKey {
        case name
        case address
        case zip
        case town
        case stateId = "state_id"
        case stateCode = "state_code"
        case countryId = "country_id"
        case countryCode = "country_code"
        case currencyCode = "currency_code"
        case defaultLanguage = "default_lang"
        case email
        case phone
        case phoneMobile = "phone_mobile"
        case url
        case vatNumber = "tva_intra"
        case managers
        case logo
        case logoSmall = "logo_small"
        case logoMini = "logo_mini"
        case logoSquarred = "logo_squarred"
        case logoSquarredSmall = "logo_squarred_small"
        case logoSquarredMini = "logo_squarred_mini"
    }

    // MARK: - Inits

    public init(
        name: String = "",
        address: String? = nil,
        zip: String? = nil,
        town: String? = nil,
        stateId: String? = nil,
        stateCode: String? = nil,
        countryId: String? = nil,
        countryCode: String? = nil,
        currencyCode: String? = nil,
        defaultLanguage: String? = nil,
        email: String? = nil,
        phone: String? = nil,
        phoneMobile: String? = nil,
        url: String? = nil,
        vatNumber: String? = nil,
        managers: String? = nil,
        logo: String? = nil,
        logoSmall: String? = nil,
        logoMini: String? = nil,
        logoSquarred: String? = nil,
        logoSquarredSmall: String? = nil,
        logoSquarredMini: String? = nil
    ) {
        self.name = name
        self.address = address
        self.zip = zip
        self.town = town
        self.stateId = stateId
        self.stateCode = stateCode
        self.countryId = countryId
        self.countryCode = countryCode
        self.currencyCode = currencyCode
        self.defaultLanguage = defaultLanguage
        self.email = email
        self.phone = phone
        self.phoneMobile = phoneMobile
        self.url = url
        self.vatNumber = vatNumber
        self.managers = managers
        self.logo = logo
        self.logoSmall = logoSmall
        self.logoMini = logoMini
        self.logoSquarred = logoSquarred
        self.logoSquarredSmall = logoSquarredSmall
        self.logoSquarredMini = logoSquarredMini
    }

    public init(from decoder: any Decoder) throws {
        do {
            #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
            Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
            #endif
            let container = try decoder.container(keyedBy: CodingKeys.self)
            func string(_ key: CodingKeys) throws -> String? {
                guard let value = try container.decodeIfPresent(String.self, forKey: key), !value.isEmpty else { return nil }
                return value
            }
            func identifier(_ key: CodingKeys) throws -> String? {
                guard let value = try container.decodeIfPresent(MultiType.self, forKey: key)?.stringValue,
                      !value.isEmpty, value != "0" else { return nil }
                return value
            }
            self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
            self.address = try string(.address)
            self.zip = try string(.zip)
            self.town = try string(.town)
            self.stateId = try identifier(.stateId)
            self.stateCode = try string(.stateCode)
            self.countryId = try identifier(.countryId)
            self.countryCode = try string(.countryCode)
            self.currencyCode = try string(.currencyCode)
            self.defaultLanguage = try string(.defaultLanguage)
            self.email = try string(.email)
            self.phone = try string(.phone)
            self.phoneMobile = try string(.phoneMobile)
            self.url = try string(.url)
            self.vatNumber = try string(.vatNumber)
            self.managers = try string(.managers)
            self.logo = try string(.logo)
            self.logoSmall = try string(.logoSmall)
            self.logoMini = try string(.logoMini)
            self.logoSquarred = try string(.logoSquarred)
            self.logoSquarredSmall = try string(.logoSquarredSmall)
            self.logoSquarredMini = try string(.logoSquarredMini)
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

    // MARK: - Methods

    /// Original file of a logo variant, relative to the ``documentModulePart`` directory.
    ///
    /// - Parameter variant: Logo variant
    /// - Returns: `logos/<file>` for main and squared logos, `logos/thumbs/<file>` for thumbnails, or `nil` if the variant is not set
    public func logoOriginalFile(_ variant: LogoVariant) -> String? {
        let file: String?
        let directory: String
        switch variant {
        case .main: (file, directory) = (logo, "logos")
        case .small: (file, directory) = (logoSmall, "logos/thumbs")
        case .mini: (file, directory) = (logoMini, "logos/thumbs")
        case .squarred: (file, directory) = (logoSquarred, "logos")
        case .squarredSmall: (file, directory) = (logoSquarredSmall, "logos/thumbs")
        case .squarredMini: (file, directory) = (logoSquarredMini, "logos/thumbs")
        }
        guard let file, !file.isEmpty else { return nil }
        return "\(directory)/\(file)"
    }
}
