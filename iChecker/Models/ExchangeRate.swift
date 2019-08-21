//
//  ExchangeRate.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/21/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import Foundation
import RealmSwift

class ExchangeRate: Object {
    @objc dynamic var base: Country? = Country()
    @objc dynamic var symbol: Country? = Country()
    @objc dynamic var average: Double = 0.0
    @objc dynamic var averageChange: Double = 0.0
    @objc dynamic var dailyHigh: Double = 0.0
    @objc dynamic var dailyLow: Double = 0.0
    var dates = List<String>()
    var rates = List<Double>()
}
