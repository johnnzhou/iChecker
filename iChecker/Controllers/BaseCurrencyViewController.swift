//
//  BaseCurrencyViewController.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/6/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit
import Hero

class BaseCurrencyViewController: UIViewController {

    let maskView = UIView()
    let contentContainerView = UIView()
    let contentView = UIView()
    let contentTitle = UILabel()
    let pickerView = UIPickerView()
    let confirmButton = UIButton()

    let contentHeight = CGFloat(425)
    let baseCurrencyList = ["USD", "CNY", "HKD", "JPY", "CAD", "EUR"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initMask()
        initContainer()
        initContent()

        hero.isEnabled = true
        contentContainerView.hero.modifiers = [.opacity(0), .translate(y: contentHeight)]
        maskView.hero.modifiers = [.opacity(0)]
    }

    func initMask() {
        view.addSubview(maskView)
        maskView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            maskView.topAnchor.constraint(equalTo: view.topAnchor),
            maskView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            maskView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            maskView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        maskView.isUserInteractionEnabled = true
        maskView.addGestureRecognizer(gesture)
    }

    func initContainer() {
        view.addSubview(contentContainerView)
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentContainerView.heightAnchor.constraint(equalToConstant: contentHeight)
        ])

        contentContainerView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: contentContainerView.topAnchor)
        ])
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = UIColor.lightGray
    }

    func initContent() {
        contentView.addSubview(contentTitle)
        contentTitle.translatesAutoresizingMaskIntoConstraints = false
        contentTitle.text = "Choose your base currency"
        contentTitle.textColor = UIColor.black

        contentView.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.dataSource = self
        pickerView.delegate = self

        contentView.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.setTitle("Finish", for: .normal)
        confirmButton.titleLabel?.textColor = UIColor.white
        confirmButton.titleLabel?.textAlignment = .center
        confirmButton.layer.cornerRadius = 15
        confirmButton.backgroundColor = UIColor.red
        confirmButton.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)

        NSLayoutConstraint.activate([
            contentTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            contentTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            pickerView.topAnchor.constraint(equalTo: contentTitle.bottomAnchor, constant: -20),
            pickerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            pickerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            confirmButton.widthAnchor.constraint(equalToConstant: 120),
            confirmButton.heightAnchor.constraint(equalToConstant: 50),
            confirmButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            confirmButton.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 60)
        ])
    }
}

extension BaseCurrencyViewController {
    @objc func dismissPopup() {
        dismiss(animated: true, completion: nil)
    }

    @objc func confirmButtonPressed() {
        // save data
        dismissPopup()
    }
}

extension BaseCurrencyViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let rowSize = pickerView.rowSize(forComponent: component)
        let rowView = view as? BaseCurrencyPickerView ?? BaseCurrencyPickerView(frame: CGRect(origin: CGPoint.zero, size: rowSize))
        rowView.currencyTitle.text = baseCurrencyList[row]

        return rowView
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.bounds.width
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}

extension BaseCurrencyViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return baseCurrencyList.count
    }
}
