//
//  CurrenciesListViewController.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/31/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit
import SwipeCellKit

class CurrenciesListViewController: UITableViewController {

    let userDefaults = UserDefaults.standard
    var pairs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pairs = userDefaults.array(forKey: "pairs") as! [String]
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddMorePressed))
        navigationItem.rightBarButtonItem?.tintColor = .titleColor
        navigationItem.title = "Currencies"

        self.tableView.isEditing = true
//        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.tableView.register(GeneralSettingViewCell.self, forCellReuseIdentifier: "\(GeneralSettingViewCell.self)")
    }
}

extension CurrenciesListViewController {
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            // handle action by updating model with deletion
//            if let index = self.pairs.firstIndex(of: self.pairs[indexPath.row]) {
//                self.pairs.remove(at: index)
//                self.userDefaults.set(self.pairs, forKey: "pairs")
//            }
//        }
//        return [deleteAction]
//    }
//
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//        options.backgroundColor = .background
//        return options
//    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralSettingViewCell", for: indexPath) as! GeneralSettingViewCell
        cell.textLabel?.text = pairs[indexPath.row]
//        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.pairs[sourceIndexPath.row]
        pairs.remove(at: sourceIndexPath.row)
        pairs.insert(movedObject, at: destinationIndexPath.row)
        userDefaults.set(pairs, forKey: "pairs")
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let index = self.pairs.firstIndex(of: self.pairs[indexPath.row]) {
            self.pairs.remove(at: index)
            self.userDefaults.set(self.pairs, forKey: "pairs")
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }

    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pairs.count
    }
}

extension CurrenciesListViewController: BaseCurrencyViewControllerDelegate {
    @objc func handleAddMorePressed() {
        let vc = BaseCurrencyViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }

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
        tableView.reloadData()
    }
}
