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
    let toLabel = UILabel()
    let fromButton = UIButton()
    let toButton = UIButton()

    var contentHeight = CGFloat(525)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initMask()
        initContainer()
        initContent()

//        contentHeight = view.bounds.height - 300
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
        contentView.addSubview(contentTitle)
        contentTitle.translatesAutoresizingMaskIntoConstraints = false
        contentTitle.text = "I want to convert from ..."
        contentTitle.textColor = .titleColor
        contentTitle.font = .somewhatSmallFont

        contentView.addSubview(toLabel)
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.text = "to ..."
        toLabel.textColor = .titleColor
        toLabel.font = .somewhatSmallFont

        contentView.addSubview(fromButton)
        fromButton.translatesAutoresizingMaskIntoConstraints = false
        fromButton.titleLabel?.font = .somewhatSmallFont
        fromButton.backgroundColor = .white
        fromButton.layer.cornerRadius = 15
        fromButton.setImage(#imageLiteral(resourceName: "arrowGray"), for: .normal)
        fromButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -80)
        fromButton.setTitleColor(.titleColor, for: .normal)
        fromButton.addTarget(self, action: #selector(goToCurrencyPicker), for: .touchUpInside)


        contentView.addSubview(toButton)
        toButton.translatesAutoresizingMaskIntoConstraints = false
        toButton.titleLabel?.font = .somewhatSmallFont
        toButton.backgroundColor = .white
        toButton.layer.cornerRadius = 15
        toButton.setImage(#imageLiteral(resourceName: "arrowGray"), for: .normal)
        toButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -80)
        toButton.setTitleColor(.titleColor, for: .normal)

        contentView.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.setTitle("Finish", for: .normal)
        confirmButton.titleLabel?.font = .titleFont
        confirmButton.titleLabel?.textColor = UIColor.white
        confirmButton.titleLabel?.textAlignment = .center
        confirmButton.layer.cornerRadius = 15
        confirmButton.backgroundColor = .veryPink
        confirmButton.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)

        NSLayoutConstraint.activate([
            contentTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            contentTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            toLabel.topAnchor.constraint(equalTo: contentTitle.bottomAnchor, constant: 120),
            toLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            fromButton.widthAnchor.constraint(equalToConstant: 150),
            fromButton.heightAnchor.constraint(equalToConstant: 60),
            fromButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            fromButton.bottomAnchor.constraint(equalTo: toLabel.topAnchor, constant: -20),
            toButton.widthAnchor.constraint(equalToConstant: 150),
            toButton.heightAnchor.constraint(equalToConstant: 60),
            toButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            toButton.topAnchor.constraint(equalTo: toLabel.bottomAnchor, constant: 20),
//            pickerView.topAnchor.constraint(equalTo: contentTitle.bottomAnchor, constant: -20),
//            pickerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            pickerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            confirmButton.widthAnchor.constraint(equalToConstant: 120),
            confirmButton.heightAnchor.constraint(equalToConstant: 50),
            confirmButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            confirmButton.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100)
        ])
    }
}

extension BaseCurrencyViewController: CurrencyPickerViewControllerDelegate {
    func handleConfirmButtonPressed(sender: CurrencyPickerViewController, currency: String) {
        fromButton.setTitle(currency, for: .normal)
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

    @objc func goToCurrencyPicker() {
        let vc = CurrencyPickerViewController()
        present(vc, animated: true, completion: nil)
    }
}
