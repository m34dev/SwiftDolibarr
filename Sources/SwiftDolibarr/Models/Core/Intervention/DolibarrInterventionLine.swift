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
//  DolibarrInterventionLine.swift
//  SwiftDolibarr
//
//  Created by William Mead on 11/12/2024.
//

import Foundation
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
import OSLog
#endif

/// A single line item within a Dolibarr intervention.
///
/// Each line represents a time entry with a ``dateIntervene`` timestamp,
/// surfaced as ``dateIntervened`` for `Date`-typed access,
/// a ``durationSeconds`` (surfaced as ``duration`` for `Duration`-typed access),
/// and an optional description.
///
/// - Note: Requires the **Ficheinter** module to be activated in Dolibarr.
/// - SeeAlso: ``DolibarrIntervention``
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
@Observable
#endif
public final class DolibarrInterventionLine: CommonBusinessObjectLine {

    // MARK: - Properties

	// Required

	/// Intervention line date (Unix timestamp)
	///
	/// - Mapped Dolibarr property: **date** or **datei (deprecated)**
	public var dateIntervene: Int

	/// Intervention line duration in seconds
	///
	/// - Mapped Dolibarr property: **duration**
	public var durationSeconds: String
    
    /// Intervention line parent intervention ID
    ///
    /// - Mapped Dolibarr property: **fk_fichinter**
    public var interventionId: String

	// Optional

	/// Intervention line description
	///
	/// - Mapped Dolibarr property: **desc**
	public var description: String?

    // Computed

    /// Intervention line date
    public var dateIntervened: Date {
        Date(timeIntervalSince1970: TimeInterval(dateIntervene))
    }

    /// Intervention line duration as a `Duration`
    public var duration: Duration? {
        guard let seconds = Double(durationSeconds) else { return nil }
        return .seconds(seconds)
    }

    // MARK: - Enums

    enum CodingKeys: String, CodingKey {
        case date = "date"
		case dateIntervene = "datei"
		case durationSeconds = "duration"
        case durationSecondsV21 = "duree"
        case interventionId = "fk_fichinter"
        case desccriptionDecode = "desc"
        case descriptionEncode = "description"
    }

    // MARK: - Inits

	public init(
		dateIntervene: Int = Int(Date.now.timeIntervalSince1970),
		durationSeconds: String = "3600",
        interventionId: String = "0",
		description: String? = nil,
		id: String = "",
		rang: String = ""
	) {
		self.dateIntervene = dateIntervene
		self.durationSeconds = durationSeconds
        self.interventionId = interventionId
        self.description = description
		super.init(id: id, rang: rang)
    }

	public required init(from decoder: any Decoder) throws {
        do {
            #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
            Logger.logWithoutSignal("\(Self.self).init.decode", category: .api)
            #endif
            let container = try decoder.container(keyedBy: CodingKeys.self)
			self.dateIntervene = try container.decode(Int.self, forKey: .date)
			self.durationSeconds = try container.decode(String.self, forKey: .durationSeconds)
            self.interventionId = try container.decode(String.self, forKey: .interventionId)
            self.description = try container.decodeIfPresent(String.self, forKey: .desccriptionDecode)
			try super.init(from: decoder)
            if self.durationSeconds.isEmpty {
                self.durationSeconds = try container.decode(String.self, forKey: .durationSecondsV21)
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

    public init(copying source: DolibarrInterventionLine) {
        self.dateIntervene = source.dateIntervene
        self.durationSeconds = source.durationSeconds
        self.interventionId = source.interventionId
        self.description = source.description
        super.init(copying: source)
    }

    // MARK: - Methods

    public func copy(_ source: DolibarrInterventionLine) {
        self.dateIntervene = source.dateIntervene
        self.durationSeconds = source.durationSeconds
        self.interventionId = source.interventionId
        self.description = source.description
        super.copy(source)
    }

    // MARK: - Protocol methods

    override public func hash(into hasher: inout Hasher) {
        hasher.combine(dateIntervene)
		hasher.combine(durationSeconds)
        hasher.combine(interventionId)
		hasher.combine(optional: description)
		super.hash(into: &hasher)
    }

    override public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dateIntervene, forKey: .date)
        try container.encode(durationSeconds, forKey: .durationSeconds)
        try container.encode(durationSeconds, forKey: .durationSecondsV21)
        try container.encode(interventionId, forKey: .interventionId)
		try container.encodeIfPresent(description, forKey: .descriptionEncode)
		try super.encode(to: encoder)
    }

}
