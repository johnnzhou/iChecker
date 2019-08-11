//
//  DisclaimerViewController.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/11/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit

class DisclaimerViewController: UIViewController {
    let contentContainer = UIView()
    let titleString = UILabel()
    let content = UILabel()

    override func viewDidLoad() {
        navigationItem.title = "Disclaimer"
        navigationItem.largeTitleDisplayMode = .never

        view.backgroundColor = UIColor.white
        content.numberOfLines = 0
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initContainer()
        initContent()
    }

    func initContainer() {
        view.addSubview(contentContainer)
        contentContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            contentContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

    }

    func initContent() {
        contentContainer.addSubview(titleString)
        titleString.translatesAutoresizingMaskIntoConstraints = false

        titleString.text = "DISCLAIMER"
        titleString.textColor = UIColor.black

        contentContainer.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false

        content.text = "All the data are retrieved from European Central Bank, which may be different from the actual rates used by your bank or card issuer. Please check the actual rates with your bank."
        content.textColor = UIColor.black

        NSLayoutConstraint.activate([
            titleString.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 10),
            titleString.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            content.topAnchor.constraint(equalTo: titleString.bottomAnchor, constant: 10),
            content.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 10),
            content.leadingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -10),
            content.widthAnchor.constraint(equalToConstant: 375)
        ])

    }

}
