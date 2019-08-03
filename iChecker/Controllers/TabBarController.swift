//
//  TabBarController.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/3/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    // initialize TabBar Item, which has rawValue of Integer
    // and cases inside are iterable
    enum Tab: Int, CaseIterable {
        case main = 0
        case calculator = 1

        var tabBarItem: UITabBarItem {
            switch self {
            case .main:
                return UITabBarItem(
                    title: "Main",
                    image: #imageLiteral(resourceName: "addMore").withRenderingMode(.alwaysOriginal),
                    selectedImage: #imageLiteral(resourceName: "addMore").withRenderingMode(.alwaysOriginal)
                )
            case .calculator:
                return UITabBarItem(
                    title: "Calculator",
                    image: #imageLiteral(resourceName: "leftArrow").withRenderingMode(.alwaysOriginal),
                    selectedImage: #imageLiteral(resourceName: "leftArrow").withRenderingMode(.alwaysOriginal)
                )
            }
        }

        var viewController: UIViewController {
            let viewController: UIViewController
            switch self {
            case .main:
                viewController = MainViewController()
            case .calculator:
                viewController = CalculatorViewController()

            }
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.tabBarItem = tabBarItem
            return navigationController
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // set viewControllers to be the Tabbar item's viewController property
        viewControllers = Tab.allCases.map { $0.viewController }

        // todo: change color
        tabBar.tintColor = .white
    }


}
