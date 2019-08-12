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
    var eval: String? = nil
//     calculator

//    @IBAction func onePressed(_ sender: UIButton) {
//        eval?.append("1")
//    }
//
//    @IBAction func twoPressed(_ sender: UIButton) {
//        eval?.append("2")
//    }
//
//    @IBAction func threePressed(_ sender: UIButton) {
//        eval?.append("3")
//    }
//
//    @IBAction func fourPressed(_ sender: UIButton) {
//        eval?.append("4")
//    }
//
//    @IBAction func fivePressed(_ sender: UIButton) {
//        eval?.append("5")
//    }
//
//    @IBAction func sixPressed(_ sender: UIButton) {
//        eval?.append("6")
//    }
//
//    @IBAction func sevenPressed(_ sender: UIButton) {
//        eval?.append("7")
//    }
//
//    @IBAction func eightPressed(_ sender: UIButton) {
//        eval?.append("8")
//    }
//
//    @IBAction func ninePressed(_ sender: UIButton) {
//        eval?.append("9")
//    }
//
//    @IBAction func zeroPressed(_ sender: UIButton) {
//        eval?.append("0")
//    }
//
//    @IBAction func additionPressed(_ sender: UIButton) {
//        eval?.append(" + ")
//    }
//
//    @IBAction func subtractionPressed(_ sender: UIButton) {
//        eval?.append(" - ")
//    }
//
//    @IBAction func multiplicationPressed(_ sender: UIButton) {
//        eval?.append(" * ")
//    }
//
//    @IBAction func divisionPressed(_ sender: UIButton) {
//        eval?.append(" / ")
//    }
//
//
//    @IBAction func deletionPressed(_ sender: UIButton) {
//        eval?.removeLast()
//    }


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
//        firstTextField.text = eval
        let numberInput = ((firstTextField.text ?? "100") as NSString).doubleValue
        secondResultantLabel.text = String(numberInput * 7)
    }
}

// calculator evaluation
//extension CalculatorViewController {
//
//}

