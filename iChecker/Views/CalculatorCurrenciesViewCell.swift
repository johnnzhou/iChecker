//
//  CalculatorCurrenciesViewCell.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/11/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit

class CalculatorCurrenciesViewCell: UICollectionViewCell {

    let firstCurrencyContainer = UIView()
    let secondCurrencyContainer = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white

    }

    func initContainer() {
        contentView.addSubview(firstCurrencyContainer)
        firstCurrencyContainer.translatesAutoresizingMaskIntoConstraints = false
        firstCurrencyContainer.layer.cornerRadius = 15
        firstCurrencyContainer.backgroundColor = .lightGray

        contentView.addSubview(secondCurrencyContainer)
        secondCurrencyContainer.translatesAutoresizingMaskIntoConstraints = false
        secondCurrencyContainer.layer.cornerRadius = 15
        secondCurrencyContainer.backgroundColor = .lightGray

        NSLayoutConstraint.activate([
            firstCurrencyContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            firstCurrencyContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            firstCurrencyContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            firstCurrencyContainer.widthAnchor.constraint(equalToConstant: 334),
            firstCurrencyContainer.heightAnchor.constraint(equalToConstant: 115),
            secondCurrencyContainer.topAnchor.constraint(equalTo: firstCurrencyContainer.bottomAnchor, constant: 20),
            secondCurrencyContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            secondCurrencyContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            secondCurrencyContainer.widthAnchor.constraint(equalToConstant: 334),
            secondCurrencyContainer.heightAnchor.constraint(equalToConstant: 115),
        ])

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
