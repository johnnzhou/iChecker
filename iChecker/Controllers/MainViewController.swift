//
//  MainViewController.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/3/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var currencyTableView: UITableView!
    let realm = try! Realm()
    let currencies = UserDefaults.standard.array(forKey: "pairs")
    var id: String? = nil
    var finalData: ExchangeRate!

    let numberAttribute = [
        NSAttributedString.Key.foregroundColor : UIColor.cyan,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 40)
    ]

    let smallNumberAttribute = [
        NSAttributedString.Key.foregroundColor : UIColor.black,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
    ]
    
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

    func attributedString(first: String, decimal: String) -> NSAttributedString {
        let result = NSMutableAttributedString(string: "")

        result.append(NSAttributedString(string: first, attributes: numberAttribute))
        result.append(NSAttributedString(string: ".", attributes: numberAttribute))
        result.append(NSAttributedString(string: decimal, attributes: smallNumberAttribute))

        return result
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
        return currencies?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = currencyTableView.dequeueReusableCell(withIdentifier: "MainViewCell", for: indexPath) as! MainViewCell

        cell.translatesAutoresizingMaskIntoConstraints = false

        guard let currenciesList = currencies else {
            return cell
        }
        let primaryKey = currenciesList[indexPath.row] as! String
        var optional = [String]()
        optional.append(String(primaryKey.split(separator: "-")[1]))
        optional.append(String(primaryKey.split(separator: "-")[0]))
        let optionalKey = optional.joined(separator: "-")
        id = primaryKey
        if let rates = realm.object(ofType: ExchangeRate.self, forPrimaryKey: primaryKey) {
            finalData = rates
        } else {
            finalData = realm.object(ofType: ExchangeRate.self, forPrimaryKey: optionalKey)
        }

        cell.flag.image = finalData.base?.flag.image()
        cell.baseName.text = finalData.base?.abbreName
        let realTime = String(format: "%.3f", finalData.now).split(separator: ".")
        cell.rate.attributedText = attributedString(first: String(realTime[0]), decimal: String(realTime[1]))
        cell.high.text = "H: " + String(format: "%.3f", finalData.dailyHigh)
        cell.low.text = "L: " + String(format: "%.3f", finalData.dailyLow)
        cell.trendArrow.image = finalData.trend ? #imageLiteral(resourceName: "increase") : #imageLiteral(resourceName: "decrease")

        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = id else {
            return
        }
        let vc = SubMainViewController(id: id, data: finalData)
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func configerTableView() {
        currencyTableView.rowHeight = UITableView.automaticDimension
        currencyTableView.estimatedRowHeight = 200
    }
}
