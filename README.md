# Swift Dolibarr

[![Latest Release](https://lab.frogg.it/dolibarr/swiftdolibarr/-/badges/release.svg)](https://lab.frogg.it/dolibarr/swiftdolibarr/-/releases)
[![Pipeline status](https://lab.frogg.it/dolibarr/swiftdolibarr/badges/main/pipeline.svg)](https://lab.frogg.it/dolibarr/swiftdolibarr/-/commits/main)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fm34dev%2Fswiftdolibarr%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/m34dev/swiftdolibarr)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fm34dev%2Fswiftdolibarr%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/m34dev/swiftdolibarr)

A Swift package providing `Codable` and `Observable` model types for the [Dolibarr ERP CRM](https://www.dolibarr.org) REST API. Decode JSON responses from the Dolibarr API directly into strongly-typed Swift objects and encode them back for create/update requests.

This is the underlying data model layer for [DoliApp](https://doliapp.eu) by [M34D](https://m34d.com), a native Apple platform client for Dolibarr.
 
> **Note:** This package is a **data model layer only**. It does not include networking, authentication, or API client logic. You provide your own HTTP layer (e.g. `URLSession`) and use these models to encode/decode the JSON payloads.

## Requirements

- Swift 6.1+
- iOS 18+ / macOS 15+ / Mac Catalyst 18+ / tvOS 18+ / visionOS 2+ / watchOS 11+
- Dolibarr v18+ (may work with older versions of Dolibarr)

## Installation

### Xcode project

Add SwiftDolibarr dependency: File -> Add Package Dependencies
```
https://github.com/m34dev/swiftdolibarr.git
```

### Swift package

Add SwiftDolibarr as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/m34dev/swiftdolibarr.git", from: "0.30.0"),
]
```

Then add it to your target's dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: ["SwiftDolibarr"]
),
```

## Supported Dolibarr Objects

### Core

| Module | Models |
|---|---|
| **Third Parties** | `DolibarrThirdParty`, `DolibarrContact` |
| **Products & Stock** | `DolibarrProduct`, `DolibarrWarehouse`, `DolibarrStockMovement` |
| **Quotes** | `DolibarrQuote`, `DolibarrQuoteLine` |
| **Orders** | `DolibarrOrder`, `DolibarrOrderLine` |
| **Invoices** | `DolibarrInvoice`, `DolibarrInvoiceLine` |
| **Suppliers / Purchases** | `DolibarrSupplierOrder`, `DolibarrSupplierOrderLine`, `DolibarrSupplierInvoice`, `DolibarrSupplierInvoiceLine` |
| **Interventions** | `DolibarrIntervention`, `DolibarrInterventionLine` |
| **Expense Reports** | `DolibarrExpenseReport`, `DolibarrExpenseReportLine` |
| **Projects & Tasks** | `DolibarrProject`, `DolibarrTask` |
| **Agenda Events** | `DolibarrAgendaEvent` |
| **Users** | `DolibarrUser`, `DolibarrUserPermissions` |
| **Setup** | `DolibarrCountry`, `DolibarrExpenseReportType`, `DolibarrShippingMethod`, `DolibarrPaymentTerm` |

### External

| Publisher | Modules | Models |
|---|---|---|
| **CODE42** | LaReponse | `LaReponseArticle`, `LaReponseComment` |

## Usage

### Decoding API responses

```swift
import SwiftDolibarr

let data: Data = // ... JSON from Dolibarr REST API
let decoder = JSONDecoder()

// Decode a single invoice
let invoice = try decoder.decode(DolibarrInvoice.self, from: data)
print(invoice.ref)				// e.g. "FA2026-0001"
print(invoice.totalInclTax)		// e.g. "1200.00"

// Decode a list of third parties
let thirdParties = try decoder.decode([DolibarrThirdParty].self, from: data)
```

### Creating objects for API requests

```swift
let newInvoice = DolibarrInvoice(
    date: Int(Date().timeIntervalSince1970),
    typeCode: "0",
    paidCode: "0",
    lines: [],
    thirdPartyId: "42",
    statusCode: "0"
)

let encoder = JSONEncoder()
let jsonData = try encoder.encode(newInvoice)
// Send jsonData to the Dolibarr API
```

### Object statuses

Each object type has predefined statuses mapped from Dolibarr statuses:

```swift
let invoice: DolibarrInvoice = // ...
let status = invoice.status
```

## Architecture

All models conform to `Codable`, `Hashable`, `Identifiable`, and are marked `@Observable` for seamless SwiftUI integration. The type hierarchy is:

- **`DolibarrObject`** — Base protocol enforcing `id` property
- **`CommonBusinessObject`** — Base class adding status, entity, notes, and extra fields
- **`CommonCommercialTransactionObject`** — Transactional class adding ref, totals, linked third party, and currency for documents (invoices, orders, quotes)
- **`DolibarrThirdParty` `DolibarrProduct` `DolibarrQuote` `...`** - Final object classes

Property names are mapped to Dolibarr API field names via `CodingKeys`, so you work with idiomatic Swift naming while the JSON stays compatible with the Dolibarr API.

## Contributing

Contributions are welcome! This project is maintained by [M34D](https://m34d.com). Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on reporting bugs, suggesting features, submitting changes, and adding new models.

## Versioning

This project uses [Semantic Versioning](https://semver.org) with the following scheme: MAJOR.MINOR.PATCH

## License

Swift Dolibarr is licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.

