//
//  SettingNotificationViewController.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/4/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit

enum NotificationSection: Int, CaseIterable {
    case notification = 0
    case time
}


class SettingNotificationViewController: UITableViewController {

    let notificationSwitch = UISwitch()
    var scheduleNotification = [
        ExpandableTime(isExpanded: false, schedule: [
            NotificationTime(time: "9:00", checked: true),
            NotificationTime(time: "12:00", checked: false),
            NotificationTime(time: "15:00", checked: false),
            NotificationTime(time: "18:00", checked: false)
            ]
        )
    ]
    var isNotificationOn: Bool = false


    override func viewDidLoad() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Notification"
        super.viewDidLoad()
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.tableView.register(SettingNotificationViewCell.self, forCellReuseIdentifier: "\(SettingNotificationViewCell.self)")
    }
}


extension SettingNotificationViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sec = NotificationSection(rawValue: section) else {
            fatalError("Unknown Section \(section)")
        }

        switch sec {
        case .notification :
            return 1
        case .time:
            return scheduleNotification[0].isExpanded ? 4 : 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sec = NotificationSection(rawValue: indexPath.section) else {
            fatalError("Unknown Setion or Row: setion:\(indexPath.section), row: \(indexPath.row)")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingNotificationViewCell", for: indexPath)
        switch sec {
        case .notification:
            cell.textLabel?.text = "Nofitication"
            cell.selectionStyle = .none

            let notificationSwitch = UISwitch(frame: CGRect.zero)
            notificationSwitch.isOn = isNotificationOn
            notificationSwitch.addTarget(self, action: #selector(handleSwitchValueChanged(_:)), for: .valueChanged)
            cell.accessoryView = notificationSwitch
        case .time:
            let time = scheduleNotification[0].schedule[indexPath.row]
            cell.textLabel?.text = time.time
            cell.accessoryType = time.checked ? .checkmark : .none
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sec = NotificationSection(rawValue: section) else {
            fatalError("Unknown Section \(section)")
        }

        switch sec {
        case .notification:
            return "SCHEDULE NOTIFICATIONS"
        case .time:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let sec = NotificationSection(rawValue: section) else {
            fatalError("Unknown Section \(section)")
        }

        switch sec {
        case .notification:
            return "Notifications will be scheduled on the selected times during weekdays. The scheduled time are displayed in 24-HOUR time"
        case .time:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sec = NotificationSection(rawValue: indexPath.section) else {
            fatalError("Unknown Setion or Row: setion:\(indexPath.section), row: \(indexPath.row)")
        }

        switch sec {
        case .notification:
            // do nothing
            break
        case .time:
            let time = scheduleNotification[0].schedule[indexPath.row]
            scheduleNotification[0].schedule[indexPath.row].checked = !time.checked
            tableView.cellForRow(at: indexPath)?.accessoryType = !time.checked ? .checkmark : .none
            let safetyCheck = scheduleNotification[0].schedule.filter {$0.checked == true}
            if safetyCheck.count == 0 {
                notificationSwitch.isOn = false
                isNotificationOn = false
                scheduleNotification[0].isExpanded = false

                // set schedule notification back to default
                scheduleNotification[0].schedule[0].checked = true
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
}


extension SettingNotificationViewController {
    @objc func handleSwitchValueChanged(_ sender: UISwitch) {
        notificationSwitch.isOn = !isNotificationOn
        isNotificationOn = !isNotificationOn

        var indexPaths = [IndexPath]()

        for row in 0...3 {
            let indexPath = IndexPath(row: row, section: 1)
            indexPaths.append(indexPath)
        }

        let isExpanded = scheduleNotification[0].isExpanded
        scheduleNotification[0].isExpanded = !isExpanded

        if isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
}
