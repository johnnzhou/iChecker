//
//  MainViewController.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/3/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift
import PromiseKit
import SwiftyJSON
import SVProgressHUD

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UNUserNotificationCenterDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var currencyTableView: UITableView!

    let realm = try! Realm()
    var pairs = [String]()
    var currencies = [String]()
    var finalData: ExchangeRate!
    let userNotification = UNUserNotificationCenter.current()

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
                let rate = (json["rates"]["\(symbol)"].rawValue as! Double) * 100.0
                var result: ExchangeRate!
                if let currenciesRate = self.realm.object(ofType: ExchangeRate.self, forPrimaryKey: "\(base)-\(symbol)") {
                    result = currenciesRate
                }
                let count = result.rates.count
                do {
                    try self.realm.write {
                        result.changeRate = (rate - result.rates[count - 2]) / result.rates[count - 2] * 100.0
                        result.now = rate
                        result.trend = result.changeRate > 0
                        if result.dailyHigh < rate {
                            result.dailyHigh = rate
                        }
                        if result.dailyLow > rate {
                            result.dailyLow = rate
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
                let reverseData = ExchangeRate()
                let count = finalResult.1.count

                data.baseSymbol = "\(base)-\(symbol)"
                reverseData.baseSymbol = "\(symbol)-\(base)"

                data.base = baseCountry
                reverseData.base = symbolCountry

                data.symbol = symbolCountry
                reverseData.symbol = baseCountry

                data.dates = finalResult.0
                reverseData.dates = finalResult.0

                data.rates = finalResult.1
                reverseData.rates = finalResult.2

                data.dailyLow = finalResult.1[count - 1]
                reverseData.dailyLow = finalResult.2[count - 1]

                data.dailyHigh = finalResult.1[count - 1]
                reverseData.dailyHigh = finalResult.2[count - 1]

                data.changeRate = (finalResult.1[count - 1] - finalResult.1[count - 2]) / finalResult.1[count - 1] * 100.0
                reverseData.changeRate = (  finalResult.2[count - 1] - finalResult.2[count - 2]  ) / finalResult.2[count - 1] * 100.0

                data.trend = data.changeRate > 0
                reverseData.trend = !data.trend 

                data.now = finalResult.1[count - 1]
                reverseData.now = finalResult.2[count - 1]

                data.rangeMax = data.rates.max()!
                reverseData.rangeMax = reverseData.rates.max()!

                data.rangeMin = data.rates.min()!
                reverseData.rangeMin = reverseData.rates.min()!

                data.average = data.rates.average()!
                reverseData.average = reverseData.rates.average()!

                data.averageChange = (data.rates.map { abs(data.average - $0) }.reduce(0, +)) / Double(count)
                reverseData.averageChange = (reverseData.rates.map { abs(reverseData.average - $0) }.reduce(0, +)) / Double(count)

                do {
                    try self.realm.write {
                        self.realm.add(data)
                        self.realm.add(reverseData)
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
            userDefaults.set(["9:00":true, "12:00":false, "15:00":false, "18:00":false, "isExpanded":false], forKey: "schedule")
            return false
        }
    }

    private func sortData(result: Array<(key: String, value: Double)>) -> (List<String>,List<Double>, List<Double>) {
        let dates = List<String>()
        let rates = List<Double>()
        let reversedRates = List<Double>()
        for pair in result {
            dates.append(pair.key)
            rates.append(pair.value * 100)
            reversedRates.append( 1.0 / pair.value * 100.0)
        }

        return (dates, rates, reversedRates)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let options: UNAuthorizationOptions = [.alert, .sound, .badge]

        userNotification.delegate = self
        userNotification.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }

//        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
//        longPressRecognizer.minimumPressDuration = 1.5
//        longPressRecognizer.delegate = self
//        longPressRecognizer.delaysTouchesBegan = true
//        currencyTableView.addGestureRecognizer(longPressRecognizer)

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
            #if DEBUG
            print("launched once")
            #endif
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
        navigationController?.navigationBar.prefersLargeTitles = false

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

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: settingButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMore))
        navigationItem.rightBarButtonItem?.tintColor = .black
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

    @objc func addMore() {
        let vc = BaseCurrencyViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension MainViewController: BaseCurrencyViewControllerDelegate {
    func handleConfirmButtonPressed(sender: BaseCurrencyViewController) {
        guard let base = sender.fromButton.titleLabel?.text else {
            return
        }
        guard let symbol = sender.toButton.titleLabel?.text else {
            return 
        }

        let baseSymbol = "\(base)-\(symbol)"
        guard let keys = UserDefaults.standard.array(forKey: "pairs") else {
            fatalError("Unable to retrieve plist info")
        }
        pairs = keys as! [String]
        pairs.append(baseSymbol)
        UserDefaults.standard.set(pairs, forKey: "pairs")
        currencyTableView.reloadData()
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
        if let rates = realm.object(ofType: ExchangeRate.self, forPrimaryKey: primaryKey) {
            finalData = rates
        }

        if finalData != nil {
            cell.baseFlag.image = finalData.base?.flag.image()
            cell.baseName.text = finalData.base?.abbreName
            cell.symbolFlag.image = finalData.symbol?.flag.image()
            cell.symbolName.text = finalData.symbol?.abbreName

            let realTime = String(format: "%.2f", finalData.now).split(separator: ".")
            cell.rate.attributedText = attributedString(first: String(realTime[0]), decimal: String(realTime[1]))
            cell.high.text = "H: " + String(format: "%.2f", finalData.dailyHigh)
            cell.low.text = "L: " + String(format: "%.2f", finalData.dailyLow)
            cell.trendArrow.image = finalData.trend ? #imageLiteral(resourceName: "increase") : #imageLiteral(resourceName: "decrease")
        }

        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = pairs[indexPath.row]
        let vc = SubMainViewController(id: id)
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
