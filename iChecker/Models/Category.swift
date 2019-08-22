//
//  Category.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/22/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    var data = ExchangeRate()
}
