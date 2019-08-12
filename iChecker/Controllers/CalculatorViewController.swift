//
//  CalculatorViewController.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/3/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    @IBOutlet weak var firstContainer: UIView!
    @IBOutlet weak var secondContainer: UIView!

    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondResultantLabel: UILabel!

    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initContainer()
        secondResultantLabel.text = String(100.0 * 7)
        firstTextField.addTarget(self, action: #selector(firstContainerTapped), for: .editingChanged)
    }

    func initContainer() {
        firstContainer.layer.cornerRadius = 10
        firstContainer.layer.shadowColor = UIColor.gray.cgColor
        firstContainer.layer.shadowOffset = CGSize.zero
        firstContainer.layer.shadowOpacity = 0.3
        firstContainer.layer.shadowRadius = 7.0
        firstContainer.layer.masksToBounds =  false

        secondContainer.layer.cornerRadius = 10
        secondContainer.layer.shadowColor = UIColor.gray.cgColor
        secondContainer.layer.shadowOffset = CGSize.zero
        secondContainer.layer.shadowOpacity = 0.3
        secondContainer.layer.shadowRadius = 7.0
        secondContainer.layer.masksToBounds =  false
    }
}

extension CalculatorViewController {
    @objc func firstContainerTapped() {
        let numberInput = ((firstTextField.text ?? "100") as NSString).doubleValue
        secondResultantLabel.text = String(numberInput * 7)

    }
}

