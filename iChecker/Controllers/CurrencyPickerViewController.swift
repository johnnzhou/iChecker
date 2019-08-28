//
//  CurrencyPickerViewController.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/28/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit
import Hero

protocol CurrencyPickerViewControllerDelegate {
    func handleConfirmButtonPressed(sender: CurrencyPickerViewController, currency: String)
}

class CurrencyPickerViewController: UIViewController {

    let maskView = UIView()
    let contentContainerView = UIView()
    let contentView = UIView()
    let backButton = UIButton()
    let pickerView = UIPickerView()
    let confirmButton = UIButton()
    var currencyPicked: String? = nil

    var contentHeight = CGFloat(525)
    let baseCurrencyList = ["USD", "CNY", "HKD", "JPY", "CAD", "EUR", "BGP"]

    var delegate: CurrencyPickerViewControllerDelegate? = nil

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
        contentView.backgroundColor = .background
    }

    func initContent() {
        contentView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(#imageLiteral(resourceName: "leftArrow"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.titleColor, for: .normal)
        backButton.titleLabel?.font = .somewhatSmallFont
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        backButton.addTarget(self, action: #selector(handleBackButtonPressed), for: .touchUpInside)

        contentView.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.dataSource = self
        pickerView.delegate = self

        contentView.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.setTitle("Finish", for: .normal)
        confirmButton.titleLabel?.font = .titleFont
        confirmButton.titleLabel?.textColor = UIColor.white
        confirmButton.titleLabel?.textAlignment = .center
        confirmButton.layer.cornerRadius = 15
        confirmButton.backgroundColor = .veryPink
        confirmButton.addTarget(self, action: #selector(handleConfirmButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            pickerView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: -20),
            pickerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            pickerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            confirmButton.widthAnchor.constraint(equalToConstant: 120),
            confirmButton.heightAnchor.constraint(equalToConstant: 50),
            confirmButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            confirmButton.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100)
            ])
    }
}

extension CurrencyPickerViewController {
    @objc func handleConfirmButtonTapped() {
        delegate?.handleConfirmButtonPressed(sender: self, currency: currencyPicked ?? "")
        dismissPopup()
    }
}

extension CurrencyPickerViewController {
    @objc func dismissPopup() {
        dismiss(animated: true, completion: nil)
    }

    @objc func handleBackButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
}

extension CurrencyPickerViewController: UIPickerViewDelegate {
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

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyPicked = baseCurrencyList[row]
    }
}

extension CurrencyPickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return baseCurrencyList.count
    }
}
