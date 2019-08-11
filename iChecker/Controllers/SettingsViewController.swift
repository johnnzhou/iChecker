//
//  SettingsViewController.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/3/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit
import MessageUI
import Foundation

enum Section: Int, CaseIterable {
    case general = 0
    case about
}

enum About: Int, CaseIterable {
    case Disclaimer = 0
    case Feedback
    case FAQ
    case SpecialThanks
    case AboutMe

    public var aboutString: String {
        switch self {
        case .Disclaimer:
            return "Disclaimer"
        case .Feedback:
            return "Feedback"
        case .FAQ:
            return "FAQ"
        case .SpecialThanks:
            return "Special Thanks"
        case .AboutMe:
            return "About"
        }
    }
}

enum General: Int, CaseIterable {
    case Notification = 0
    case BaseCurrency

    public var generalString: String {
        switch self {
        case .Notification:
            return "Notification"
        case .BaseCurrency:
            return "Base Currency"
        }
    }
}

class SettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissView))

        navigationItem.hidesBackButton = true

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
            return General.allCases.count
        case .about:
            return About.allCases.count
        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sec = Section(rawValue: indexPath.section) else {
            fatalError("Unknow Section \(indexPath.section)")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsViewCell", for: indexPath)
        switch  sec {
        case .general:
            cell.textLabel?.text = General(rawValue: indexPath.row)?.generalString
            cell.accessoryType = .disclosureIndicator

        case .about:
            cell.textLabel?.text = About(rawValue: indexPath.row)?.aboutString
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
            return "GENERAl"
        case .about:
            return "ABOUT"
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let sec = Section(rawValue: indexPath.section) else {
            fatalError("Unknow Section \(indexPath.section)")
        }

        switch sec {
        case .general:
            guard let row = General(rawValue: indexPath.row) else {
                fatalError("Unknown Row \(indexPath.row)")
            }

            switch row {

            case .Notification:
                let vc = SettingNotificationViewController()
                navigationController?.pushViewController(vc, animated: true)
            case .BaseCurrency:
                let vc = BaseCurrencyViewController()
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: true, completion: nil)
            }

        case .about:
            guard let row = About(rawValue: indexPath.row) else {
                fatalError("Unknown Row \(indexPath.row)")
            }

            switch row {

            case .Disclaimer:
                let vc = DisclaimerViewController()
                navigationController?.pushViewController(vc, animated: true)
            case .Feedback:
                 sendFeedBack()
            case .FAQ:
                return
            case .SpecialThanks:
                return
            case .AboutMe:
                return
            }
        }

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

extension SettingsViewController: MFMailComposeViewControllerDelegate {

    @objc func sendFeedBack() {
        if MFMailComposeViewController.canSendMail() {
            let vc = MFMailComposeViewController()
            vc.mailComposeDelegate = self

            // configure sender/recipient info
            vc.setSubject("Feedback")
            vc.setToRecipients(["zhouz46@uw.edu"])
            vc.setMessageBody("Let me know what you think!", isHTML: false)
            self.present(vc, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: nil,
                                          message: "Unable to send feedback as the default mail app is deleted.", preferredStyle: .actionSheet)
            let goToAppStoreAction = UIAlertAction(title: "Install Mail App", style: .default) { _ in
                if let url = URL(string: "itms-apps://https://apps.apple.com/us/app/mail/id1108187098") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(goToAppStoreAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }

    // dismiss mailComposeViewController
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController {

    // dismiss settingviewcontroller
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}
