//
//  SettingNotificationViewController.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/4/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift

enum NotificationSection: Int, CaseIterable {
    case notification = 0
    case time
}


class SettingNotificationViewController: UITableViewController {

    let notificationCenter = UNUserNotificationCenter.current()
    let notificationSwitch = UISwitch()
    let userDefaults = UserDefaults.standard
    let dateformatter = DateFormatter()
    let realm = try! Realm()

    var scheduleNotification = [
        ExpandableTime(isExpanded: false, schedule: [])
    ]
    var schedule = [String:Bool]()

    var isNotificationOn: Bool = false


    override func viewDidLoad() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Notification"
        super.viewDidLoad()

        dateformatter.dateFormat = "HH:mm"
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        let schedule = userDefaults.dictionary(forKey: "schedule") as! [String:Bool]
        scheduleNotification[0].isExpanded = schedule["isExpanded"] ?? false
        scheduleNotification[0].schedule.append(NotificationTime(time: "9:00", checked: schedule["9:00"] ?? true))
        scheduleNotification[0].schedule.append(NotificationTime(time: "12:00", checked: schedule["12:00"] ?? false))
        scheduleNotification[0].schedule.append(NotificationTime(time: "15:00", checked: schedule["15:00"] ?? false))
        scheduleNotification[0].schedule.append(NotificationTime(time: "18:00", checked: schedule["18:00"] ?? false))
        self.schedule.updateValue(schedule["isExpanded"] ?? false, forKey: "isExpanded")
        self.schedule.updateValue(schedule["9:00"] ?? true, forKey: "9:00")
        self.schedule.updateValue(schedule["12:00"] ?? false, forKey: "12:00")
        self.schedule.updateValue(schedule["15:00"] ?? false, forKey: "15:00")
        self.schedule.updateValue(schedule["18:00"] ?? false, forKey: "18:00")

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
            schedule.updateValue(!time.checked, forKey: time.time!)

            tableView.cellForRow(at: indexPath)?.accessoryType = !time.checked ? .checkmark : .none
            let safetyCheck = scheduleNotification[0].schedule.filter {$0.checked == true}
            if safetyCheck.count == 0 {
                notificationSwitch.isOn = false
                isNotificationOn = false
                scheduleNotification[0].isExpanded = false
                schedule.updateValue(false, forKey: "isExpanded")
                // set schedule notification back to default
                scheduleNotification[0].schedule[0].checked = true
                schedule.updateValue(true, forKey: "9:00")
            }
            userDefaults.set(schedule, forKey: "schedule")
            
            if isNotificationOn {
                // notification is no
                removeReminder() { [weak self] in
                    DispatchQueue.main.async {
                        self?.setupReminder()
                    }
                }
            } else {
                removaAllPendingNotifications()
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

        if notificationSwitch.isOn {
            // setup notifications
            setupReminder()
        } else {
            // remove all pending notifications
            print("remove all pending notifications")
            removaAllPendingNotifications()
        }

        var indexPaths = [IndexPath]()

        for row in 0...3 {
            let indexPath = IndexPath(row: row, section: 1)
            indexPaths.append(indexPath)
        }

        let isExpanded = scheduleNotification[0].isExpanded
        scheduleNotification[0].isExpanded = !isExpanded
        self.schedule["isExpanded"] = !isExpanded
        userDefaults.set(schedule, forKey: "schedule")
        if isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
}

extension SettingNotificationViewController {
    func removaAllPendingNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }

    func setupReminder() {
        let content = UNMutableNotificationContent()
        content.badge = 0
        content.subtitle = "Exchange Rate Report"
        guard let rate = realm.object(ofType: ExchangeRate.self, forPrimaryKey: "CNY-USD") else {
            return
        }
        content.body = "The current rate is \(rate.now)"

        let timeArray = userDefaults.dictionary(forKey: "schedule") as! [String:Bool]
        let timeList = timeArray.filter { $0.value == true }
        for time in timeList {
            guard let date = dateformatter.date(from: time.key) else { return }
            let userSetTime = Calendar.current.dateComponents([.hour, .minute], from: date)
            let userSetHour = userSetTime.hour
            let userSetMinute = userSetTime.minute
            var triggerDate = DateComponents(hour: userSetHour, minute: userSetMinute, second: 0)

            for i in 2...6 {
                triggerDate.weekday = i
                let triggerWorkDays = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
                let request = UNNotificationRequest(
                    identifier: "Reminder\(time.key)",
                    content: content,
                    trigger: triggerWorkDays
                )

                notificationCenter.add(request) { (error) in
                    if let error = error {
                        print(error)
                    }
                }
            }
        }
    }

    func removeReminder(completion: (() -> Void)? = nil) {
        let timeArray = userDefaults.dictionary(forKey: "schedule") as! [String:Bool]
        let timeList = timeArray.filter { $0.value == false }

        for time in timeList {
            notificationCenter.getPendingNotificationRequests { (notificationRequests) in
                for notifications in notificationRequests {
                    if notifications.identifier.contains(time.key) {
                        self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [notifications.identifier])
                    }
                }
                completion?()
            }
        }
    }
}

