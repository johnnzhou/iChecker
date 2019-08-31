//
//  Country.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/20/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import Foundation
import RealmSwift

public enum CountryName: String, CaseIterable {
    case CAD = "CAD"
    case CNY = "CNY"
    case EUR = "EUR"
    case HKD = "HKD"
    case JPY = "JPY"
    case USD = "USD"
    case GBP = "GBP"

    public var fullName: String {
        switch self {
        case .CAD:
            return "Canadian Dollar"
        case .CNY:
            return "Chinese Yuan"
        case .EUR:
            return "Euro"
        case .HKD:
            return "HongKong Dollar"
        case .JPY:
            return "Japanese Yen"
        case .USD:
            return "United States Dollar"
        case .GBP:
            return "Pound"
        }
    }

    public var flagString: String {
        switch self {
        case .CAD:
            return "🇨🇦"
        case .CNY:
            return "🇨🇳"
        case .EUR:
            return "🇪🇺"
        case .HKD:
            return "🇭🇰"
        case .JPY:
            return "🇯🇵"
        case .USD:
            return "🇺🇸"
        case .GBP:
            return "🇬🇧"
        }
    }
}

class Country: Object {
    @objc dynamic var abbreName: String = ""
    
    public var flag: String {
        return CountryName(rawValue: abbreName)!.flagString
    }

    public var fullName: String {
        return CountryName(rawValue: abbreName)!.fullName
    }
}
