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
//  DolibarrSupplierReputation.swift
//  SwiftDolibarr
//
//  Created by William Mead on 18/11/2026.
//

import Foundation

/// Reputation of a supplier for a given product purchase price.
///
/// Dolibarr stores no reputation as an empty value, so a missing reputation is `nil`
/// rather than a case.
///
/// - SeeAlso: ``DolibarrProductSupplierPrice``
public enum DolibarrSupplierReputation: String, CaseIterable, Hashable, Sendable {

	/// Favorite supplier for this product
	case favorite = "FAVORITE"

	/// Supplier is not good for this product
	///
	/// The raw value keeps Dolibarr's spelling.
	case notGood = "NOTTHGOOD"

	/// Do not order this product from this supplier
	case doNotOrder = "DONOTORDER"

}
