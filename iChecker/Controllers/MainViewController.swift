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

        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        initNavigation()
    }

    //setup navigationBar
    func initNavigation() {

        navigationItem.title = "Currency"
        navigationController?.navigationBar.prefersLargeTitles = true

        let settingButtonImage = UIImage(named: "settings.png")?.withRenderingMode(.alwaysOriginal)
        let settingButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        settingButton.setBackgroundImage(settingButtonImage, for: .normal)
        settingButton.addTarget(self, action: #selector(goToPreferences), for: .touchUpInside)
        settingButton.isUserInteractionEnabled = true

        settingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingButton.widthAnchor.constraint(equalToConstant: 20),
            settingButton.heightAnchor.constraint(equalToConstant: 20)
        ])

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingButton)
        tabBarController?.tabBar.isHidden = false
    }
}

extension MainViewController {
    @objc func goToPreferences() {
        let vc = SettingsViewController()
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true, completion: nil)
    }
}
