//
//  MainViewController.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/3/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var currencyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
        currencyTableView.register(MainViewCell.self, forCellReuseIdentifier: "\(MainViewCell.self)")

        currencyTableView.separatorStyle = .none

        initNavigation()
        configerTableView()
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

extension MainViewController {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = currencyTableView.dequeueReusableCell(withIdentifier: "MainViewCell", for: indexPath) as! MainViewCell
        cell.delegate = self
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.flag.image = "🏴󠁧󠁢󠁥󠁮󠁧󠁿".image()
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func configerTableView() {
        currencyTableView.rowHeight = UITableView.automaticDimension
        currencyTableView.estimatedRowHeight = 200
    }
}

extension MainViewController: MainViewCellDelegate {
    func handleInfoButtonPressed(sender: MainViewCell) {
        let vc = SubMainViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
