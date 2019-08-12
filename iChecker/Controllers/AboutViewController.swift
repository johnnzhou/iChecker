//
//  AboutViewController.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/11/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    let contentContainer = UIView()
    let titleString = UILabel()
    let content = UILabel()

    override func viewDidLoad() {
        navigationItem.title = "About"
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

        titleString.text = "About"
        titleString.textColor = UIColor.black

        contentContainer.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false

        content.text = "This app is inspired by my internship at Miidii tech, where I learned a lot about swift programming and product design. I want to implement what I learned to create something new"
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
