//
//  BaseCurrencyPickerView.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/11/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit

class BaseCurrencyPickerView: UIView {

    let currencyTitle = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(currencyTitle)
        currencyTitle.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            currencyTitle.topAnchor.constraint(equalTo: topAnchor),
            currencyTitle.bottomAnchor.constraint(equalTo: bottomAnchor),
            currencyTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            currencyTitle.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        currencyTitle.textColor = .titleColor
        currencyTitle.font = .titleFont
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
