//
//  CalculatorViewController.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/3/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit
import RealmSwift

class CalculatorViewController: UIViewController {

    var data: Results<ExchangeRate>?
    let realm = try! Realm()
    let baseContainer = UIView()
    let tableView = UITableView()

    let baseFlag = UIButton()
    let baseTextField = UITextField()
    let baseName = UIButton()
    let baseDetailName = UILabel()

    var currencies = [String]()
    var baseInConverter = String()
    var tempTextField = String()

    override func viewDidLoad() {
        super.viewDidLoad()


        baseInConverter = UserDefaults.standard.string(forKey: "baseInConverter")!
        self.tableView.tableFooterView = UIView(frame: .zero)

        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissTextField))
        baseContainer.addGestureRecognizer(gesture)
        tableView.addGestureRecognizer(gesture)

        initData(baseInConverter: baseInConverter)
        initTextField()
        initContainer()
        initContent()
    }

    func initData(baseInConverter: String) {
        currencies = UserDefaults.standard.array(forKey: "currencies") as! [String]
        data = realm.objects(ExchangeRate.self).filter("baseSymbol BEGINSWITH %@", baseInConverter)
        if let index = currencies.firstIndex(of: baseInConverter) {
            currencies.remove(at: index)
        }
    }

    func initTextField() {
        baseTextField.delegate = self
        baseTextField.keyboardType = .decimalPad
        baseTextField.addTarget(self, action: #selector(editChanged(_:)), for: .editingChanged)
    }

    func initContainer() {
        view.backgroundColor = .background

        view.addSubview(baseContainer)
        baseContainer.translatesAutoresizingMaskIntoConstraints = false
        baseContainer.layer.cornerRadius = 10
        baseContainer.backgroundColor = .white
        baseContainer.layer.shadowColor = UIColor.gray.cgColor
        baseContainer.layer.shadowOffset = CGSize.zero
        baseContainer.layer.shadowOpacity = 0.3
        baseContainer.layer.shadowRadius = 7.0
        baseContainer.layer.masksToBounds =  false

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .background
        tableView.delegate = self
        tableView.dataSource = self

        NSLayoutConstraint.activate([
            baseContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            baseContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            baseContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            baseContainer.heightAnchor.constraint(equalToConstant: 80),

            tableView.topAnchor.constraint(equalTo: baseContainer.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func initContent() {
        baseContainer.addSubview(baseFlag)
        baseFlag.translatesAutoresizingMaskIntoConstraints = false

        let country = Country()
        country.abbreName = baseInConverter

        baseFlag.setImage(country.flag.image(), for: .normal)
        baseFlag.addTarget(self, action: #selector(handleBaseCountryChanged), for: .touchUpInside)

        baseContainer.addSubview(baseName)
        baseName.translatesAutoresizingMaskIntoConstraints = false
        baseName.setTitle(baseInConverter, for: .normal)
        baseName.titleLabel?.font = .somewhatSmallFont
        baseName.setTitleColor(.titleColor, for: .normal)
        baseName.addTarget(self, action: #selector(handleBaseCountryChanged), for: .touchUpInside)


        baseContainer.addSubview(baseDetailName)
        baseDetailName.translatesAutoresizingMaskIntoConstraints = false
        baseDetailName.text = country.fullName
        baseDetailName.font = .exSmallTitleFont
        baseDetailName.textAlignment = .right
        baseDetailName.textColor = .someGray

        baseContainer.addSubview(baseTextField)
        baseTextField.translatesAutoresizingMaskIntoConstraints = false
        baseTextField.placeholder = "100"
        baseTextField.textAlignment = .right
        baseTextField.font = .mediumRateFont

        NSLayoutConstraint.activate([
            baseFlag.centerYAnchor.constraint(equalTo: baseContainer.centerYAnchor),
            baseFlag.leadingAnchor.constraint(equalTo: baseContainer.leadingAnchor, constant: 10),
            baseFlag.heightAnchor.constraint(equalToConstant: 40),
            baseFlag.widthAnchor.constraint(equalToConstant: 30),
            baseName.centerYAnchor.constraint(equalTo: baseContainer.centerYAnchor, constant: -5),
            baseName.leadingAnchor.constraint(equalTo: baseFlag.trailingAnchor, constant: 10),
            baseTextField.trailingAnchor.constraint(equalTo: baseContainer.trailingAnchor, constant: -10),
            baseTextField.topAnchor.constraint(equalTo: baseContainer.topAnchor, constant: 15),
            baseTextField.bottomAnchor.constraint(equalTo: baseContainer.bottomAnchor, constant: -30),
            baseTextField.leadingAnchor.constraint(equalTo: baseName.trailingAnchor),
            baseDetailName.topAnchor.constraint(equalTo: baseTextField.bottomAnchor, constant: 0),
            baseDetailName.trailingAnchor.constraint(equalTo: baseContainer.trailingAnchor, constant: -15),
            baseDetailName.leadingAnchor.constraint(equalTo: baseContainer.trailingAnchor, constant: -120)
        ])

    }
}

extension CalculatorViewController {
    @objc func handleBaseCountryChanged() {
        let alert = UIAlertController(title: "Choose your base", message: nil, preferredStyle: .actionSheet)
        var actions = [UIAlertAction]()
        for currency in currencies {
            let action = UIAlertAction(title: currency, style: .default) { _ in

                let country = Country()
                country.abbreName = currency

                self.baseFlag.setImage(country.flag.image(), for: .normal)
                self.baseName.setTitle(currency, for: .normal)
                self.baseDetailName.text = country.fullName
                self.initData(baseInConverter: currency)
                UserDefaults.standard.set(currency, forKey: "baseInConverter")
                self.tableView.reloadData()
            }
            actions.append(action)
        }

        for action in actions {
            alert.addAction(action)
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension CalculatorViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count - 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")

        guard let data = data else {
            return cell
        }

        let rate = data[indexPath.row]
        cell.textLabel?.text = rate.symbol?.abbreName
        cell.imageView?.image = rate.symbol?.flag.image()
        cell.selectionStyle = .none
        let num = Double(baseTextField.text!) ?? 100.0
        cell.detailTextLabel?.text = String(format: "%.2f", rate.now * num / 100.0)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension CalculatorViewController: UITableViewDelegate {

}

extension CalculatorViewController {
    @objc func dismissTextField() {
        baseTextField.endEditing(true)
    }
}

extension CalculatorViewController: UITextFieldDelegate {

    @objc func editChanged(_ sender: UITextField) {

        guard var text = sender.text else {
            return
        }

        if text.starts(with: "0") && !text.contains(".") {
            if text.count > 1 {
                text.remove(at: text.startIndex)
            }
        }
        baseTextField.text = text
        UIView.animate(withDuration: 0.5) {
            self.tableView.reloadData()
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let characterCountLimit = 11

        // We need to figure out how many characters would be in the string after the change happens
        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace = range.length

        let newLength = startingLength + lengthToAdd - lengthToReplace

        return newLength <= characterCountLimit
    }

}


