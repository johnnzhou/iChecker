//
//  AppDelegate.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/3/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON
import Alamofire
import PromiseKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let currencies = ["CAD", "CNY", "EUR", "JPY", "HKD", "USD", "GBP"]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        #if DEBUG
            print(Realm.Configuration.defaultConfiguration.fileURL)
        #endif

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let endsAt = dateFormatter.string(from: Date())
        let startsAt = dateFormatter.string(from: Date(timeIntervalSinceNow: -31*24*60*60))

        if isAppAlreadyLaunchedOnce() {
            print("launched once")
        } else {
            for first in 0..<currencies.count {
                for second in (first + 1)..<currencies.count {
                    let _ = alamofireRequest(base: currencies[first],
                                             symbol: currencies[second],
                                             startsAt: startsAt,
                                             endsAt: endsAt)
                }
            }

        }
        // controll the interfaces programmatically
//        let viewController = TabBarController()
//        window = UIWindow()
//        window?.rootViewController = viewController
//        window?.makeKeyAndVisible()
        return true
    }


    private func alamofireRequest(base: String, symbol: String, startsAt: String, endsAt: String) -> Promise<Void> {
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
                data.base = baseCountry
                data.symbol = symbolCountry
                data.dates = finalResult.0
                data.rates = finalResult.1
                data.average = data.rates.average()!
                let realm = try! Realm()
                do {
                    try realm.write {
                        realm.add(data)
                    }
                } catch {
                    print("Error in saving data to Realm \(error)")
                }
            }
    }

    private func isAppAlreadyLaunchedOnce() -> Bool {
        let userDefaults = UserDefaults.standard
        if userDefaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil {
            return true
        } else {
            userDefaults.setValue(true, forKey: "isAppAlreadyLaunchedOnce")
            return false
        }
    }

    private func sortData(result: Array<(key: String, value: Double)>) -> (List<String>,List<Double>) {
        let dates = List<String>()
        let rates = List<Double>()
        for pair in result {
            dates.append(pair.key)
            rates.append(pair.value)
        }

        return (dates, rates)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

