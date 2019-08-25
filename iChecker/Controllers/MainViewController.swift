//
//  MainViewController.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/3/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit
import RealmSwift
import PromiseKit
import SwiftyJSON
import SVProgressHUD

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var currencyTableView: UITableView!

    let realm = try! Realm()
    var pairs = [String]()
    var currencies = [String]()
    var id: String? = nil
    var finalData: ExchangeRate!

    let numberAttribute = [
        NSAttributedString.Key.foregroundColor : UIColor.titleColor,
        NSAttributedString.Key.font : UIFont.rateFont
    ]

    let smallNumberAttribute = [
        NSAttributedString.Key.foregroundColor : UIColor.titleColor,
        NSAttributedString.Key.font : UIFont.smallRateFont
    ]

    private func dailyRequest(base: String, symbol: String) -> Promise<Void> {
        let url = "https://api.exchangerate-api.com/v4/latest/\(base)"
        return firstly() {
            return Promise()
            }.then { _ in
                Alamofire.request(url, method: .get).responseData()
            }.done() { data in
                let json = try JSON(data: data.data)
                var rate = json["rates"]["\(symbol)"].rawValue as! Double
                var result: ExchangeRate!
                if let currenciesRate = self.realm.object(ofType: ExchangeRate.self, forPrimaryKey: "\(base)-\(symbol)") {
                    result = currenciesRate
                } else {
                    let currenciesRate = self.realm.object(ofType: ExchangeRate.self, forPrimaryKey: "\(symbol)-\(base)")
                    rate = 1.0 / rate
                    result = currenciesRate
                }
                do {
                    try self.realm.write {
                        result.changeRate = (rate - result.now) / result.now * 100
                        result.now = rate
                        if result.dailyHigh < rate {
                            result.dailyHigh = rate
                            result.trend = true
                        }
                        if result.dailyLow > rate {
                            result.dailyLow = rate
                            result.trend = false
                        }
                    }
                } catch {
                    print("Error in storing data \(error)")

                }
            }.done() {
                DispatchQueue.main.async {
                    self.currencyTableView.reloadData()
                }
        }
    }

    private func initialRequest(base: String, symbol: String, startsAt: String, endsAt: String) -> Promise<Void> {
        let url = "https://api.exchangeratesapi.io/history?start_at=\(startsAt)&end_at=\(endsAt)&base=\(base)&symbols=\(symbol)";
        return firstly() {
            return Promise()
            }.then() { _ in
                Alamofire.request(url, method: .get).responseData()
            }.done() { data in
                let json = try JSON(data: data.data)
                #if DEBUG
                print(json)
                #endif
                let rates = json["rates"]
                var result = [String:Double]()
                for (key,value):(String, JSON) in rates {
                    result.updateValue(value[symbol].rawValue as! Double, forKey: key)
                }
                let finalResult = self.sortData(result: result.sorted { $0.0 < $1.0 })

                let baseCountry = Country()
                let symbolCountry = Country()
                baseCountry.abbreName = base
                symbolCountry.abbreName = symbol

                let data = ExchangeRate()
                data.baseSymbol = "\(base)-\(symbol)"
                data.base = baseCountry
                data.symbol = symbolCountry
                data.dates = finalResult.0
                data.rates = finalResult.1
                data.dailyLow = finalResult.1.min() ?? 10000
                data.dailyHigh = finalResult.1.max() ?? 0
                data.changeRate = (finalResult.1[finalResult.1.count - 1] - finalResult.1[finalResult.1.count - 2]) / finalResult.1[finalResult.1.count - 1] * 100
                data.trend = (finalResult.1[finalResult.1.count - 1] - finalResult.1[finalResult.1.count - 2]) > 0
                data.now = finalResult.1[finalResult.1.count - 1]
                data.rangeMax = data.rates.max()!
                data.rangeMin = data.rates.min()!
                data.average = data.rates.average()!
                data.averageChange = (data.rates.map { abs(data.average - $0) }.reduce(0, +)) / Double(data.rates.count)
                do {
                    try self.realm.write {
                        self.realm.add(data)
                    }
                } catch {
                    print("Error in saving data to Realm \(error)")
                }
            }.done() {
                DispatchQueue.main.async {
                    self.currencyTableView.reloadData()
                }
            SVProgressHUD.dismiss()
        }
    }

    private func isAppAlreadyLaunchedOnce() -> Bool {
        let userDefaults = UserDefaults.standard
        if userDefaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil {
            return true
        } else {
            userDefaults.setValue(true, forKey: "isAppAlreadyLaunchedOnce")
            userDefaults.setValue(["CAD", "CNY", "EUR", "JPY", "HKD", "USD", "GBP"], forKey: "currencies")
            userDefaults.setValue(["USD-CNY", "CNY-HKD", "CNY-JPY", "USD-EUR", "USD-GBP", "USD-JPY"], forKey: "pairs")
            return false
        }
    }

    private func sortData(result: Array<(key: String, value: Double)>) -> (List<String>,List<Double>) {
        let dates = List<String>()
        let rates = List<Double>()
        for pair in result {
            dates.append(pair.key)
            rates.append(pair.value * 100)
        }

        return (dates, rates)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currencyTableView.delegate = self
        currencyTableView.dataSource = self
        currencyTableView.register(MainViewCell.self, forCellReuseIdentifier: "\(MainViewCell.self)")

        currencyTableView.separatorStyle = .none
        currencyTableView.backgroundColor = .background
        initNavigation()
        configerTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let endsAt = dateFormatter.string(from: Date())
        let startsAt = dateFormatter.string(from: Date(timeIntervalSinceNow: -42*24*60*60))



        if isAppAlreadyLaunchedOnce() {
            print("launched once")
            guard let keys = UserDefaults.standard.array(forKey: "pairs") else {
                fatalError("Unable to retrieve plist info")
            }
            pairs = keys as! [String]
            let count = keys.count

            for first in 0..<count {
                let pair = pairs[first].split(separator: "-")
                let _ = dailyRequest(base: String(pair[0]), symbol: String(pair[1]))
                
            }
        } else {
            SVProgressHUD.show()
            guard let currency = UserDefaults.standard.array(forKey: "currencies"),
                let keys = UserDefaults.standard.array(forKey: "pairs") else {
                fatalError("Unable to retrieve plist info")
            }
            currencies = currency as! [String]
            pairs = keys as! [String]
            let count = currency.count
            for first in 0..<count {
                for second in (first + 1)..<count {
                    let _ = when(fulfilled: initialRequest(base: currencies[first],
                                                           symbol: currencies[second],
                                                           startsAt: startsAt,
                                                           endsAt: endsAt))
                }
            }
        }
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
        navigationController?.navigationBar.backgroundColor = .background
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
        return pairs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = currencyTableView.dequeueReusableCell(withIdentifier: "MainViewCell", for: indexPath) as! MainViewCell

        cell.translatesAutoresizingMaskIntoConstraints = false

        guard let keys = UserDefaults.standard.array(forKey: "pairs") else {
            return cell
        }
        pairs = keys as! [String]
        let primaryKey = keys[indexPath.row] as! String
        var optional = [String]()
        optional.append(String(primaryKey.split(separator: "-")[1]))
        optional.append(String(primaryKey.split(separator: "-")[0]))
        let optionalKey = optional.joined(separator: "-")
        id = primaryKey
        if let rates = realm.object(ofType: ExchangeRate.self, forPrimaryKey: primaryKey) {
            finalData = rates
        }
        if let rates = realm.object(ofType: ExchangeRate.self, forPrimaryKey: optionalKey) {
            finalData = rates
        }

        if finalData != nil {
            cell.flag.image = finalData.base?.flag.image()
            cell.baseName.text = finalData.base?.abbreName
            let realTime = String(format: "%.3f", finalData.now).split(separator: ".")
            cell.rate.attributedText = attributedString(first: String(realTime[0]), decimal: String(realTime[1]))
            cell.high.text = "H: " + String(format: "%.3f", finalData.dailyHigh)
            cell.low.text = "L: " + String(format: "%.3f", finalData.dailyLow)
            cell.trendArrow.image = finalData.trend ? #imageLiteral(resourceName: "increase") : #imageLiteral(resourceName: "decrease")
        }

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
