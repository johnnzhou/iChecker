//
//  MainViewController.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/3/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initNavigation()
    }

    //setup navigationBar
    func initNavigation() {

        navigationItem.title = "Currency"
        navigationController?.navigationBar.prefersLargeTitles = true

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToPreferences))
        navigationItem.rightBarButtonItem = addButton
        tabBarController?.tabBar.isHidden = false
    }


}

extension MainViewController {
    @objc func goToPreferences() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
}
