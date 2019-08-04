//
//  NotificationTime.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/4/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import Foundation

enum Time: Int, CaseIterable {
    case opening = 0
    case noonTime
    case afternoon
    case closing

    public var timeString: String {
        switch self {
        case .opening:
            return "9:00"
        case .noonTime:
            return "12:00"
        case .afternoon:
            return "15:00"
        case .closing:
            return "18:00"
        }
    }
}

struct NotificationTime {
    var time: String? = nil
    var checked: Bool = false
}
