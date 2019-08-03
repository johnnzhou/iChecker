//
//  SettingsViewController.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/3/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit
import Foundation

enum Section: Int {
    case general = 0
    case about
}

class SettingsViewController: UITableViewController {

    var general: [String] = ["Notification", "Base Currency"]
    var about: [String] = ["Disclaimer", "Feedback", "FAQ", "Special Thanks", "About"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initTableView()
        initNavigation()
        initTableViewCell()
    }

    func initTableView() {
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
    }

    func initNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Preferenecs"
//        tabBarController?.tabBar.isHidden = true
    }

    func initTableViewCell() {
        tableView.register(settingsViewCell.self, forCellReuseIdentifier: "\(settingsViewCell.self)")

    }
}

extension SettingsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let sec = Section(rawValue: section) else {
            fatalError("Unknown section \(section)")
        }

        switch sec {
        case .general:
            return general.count
        case .about:
            return about.count
        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sec = Section(rawValue: indexPath.section) else {
            fatalError("Unknow Section \(indexPath.section)")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsViewCell", for: indexPath)
        switch  sec {
        case .general:
            cell.textLabel?.text = general[indexPath.row]
            if indexPath.row == 1{
                cell.accessoryType = .disclosureIndicator
            } else {
                
            }

        case .about:
            cell.textLabel?.text = about[indexPath.row]
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sec = Section(rawValue: section) else {
            fatalError("Unknown Section \(section)")
        }

        switch  sec {
        case .general:
            return "General"
        case .about:
            return "About"
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let sec = Section(rawValue: section) else {
            fatalError("Unknown Section \(section)")
        }

        switch sec {
        case .general:
            return ""
        case .about:
            return "Designed by John Zhou \n University of Washington"
        }
    }
}
