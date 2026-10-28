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
//  DolibarrObjectDomain.swift
//  SwiftDolibarr
//
//  Created by William Mead on 16/03/2026.
//

import Foundation

/// The business domain a ``DolibarrObjectStatus`` belongs to.
///
/// Used to disambiguate status codes that share the same numeric value
/// across different Dolibarr modules (e.g., code `"0"` means *draft*
/// generically but *inactive* for third parties).
///
/// - SeeAlso: ``DolibarrObjectStatus``
public enum DolibarrObjectDomain: String, Sendable, Codable, Equatable, Hashable {
    case generic
    case thirdParty
    case product
    case warehouse
    case quote
    case order
    case invoice
    case intervention
    case expenseReport
    case project
    case task
    case agendaEvent
    case supplierOrder
    case supplierInvoice
}
