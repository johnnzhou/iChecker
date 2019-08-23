//
//  UIFont+iChecker.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/23/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {

    class var exSmallTitleFont: UIFont {
        return UIFont(name: "Avenir-Black", size: 12) ?? systemFont(ofSize: 10)
    }

    class var smallTitleFont: UIFont {
        return UIFont(name: "Avenir-Heavy", size: 14) ?? systemFont(ofSize: 14)
    }

    class var titleFont: UIFont {
        return UIFont(name: "Avenir-Heavy", size: 18) ?? systemFont(ofSize: 18)
    }

    class var rateFont: UIFont {
        return UIFont(name: "Avenir-Heavy", size: 44) ?? systemFont(ofSize: 44)
    }

    class var mediumRateFont: UIFont {
        return UIFont(name: "Avenir-Heavy", size: 36) ?? systemFont(ofSize: 36)
    }

    class var someMediumRateFont: UIFont {
        return UIFont(name: "Avenir-Heavy", size: 30) ?? systemFont(ofSize: 30)
    }

    class var LargeRateFont: UIFont {
        return UIFont(name: "Avenir-Heavy", size: 56) ?? systemFont(ofSize: 56)
    }

    class var somewhatSmallFont: UIFont {
        return UIFont(name: "Avenir-Heavy", size: 24) ?? systemFont(ofSize: 24)
    }

    class var smallRateFont: UIFont {
        return UIFont(name: "Avenir-Heavy", size: 20) ?? systemFont(ofSize: 20)
    }
}
