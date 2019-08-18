//
//  MainViewCell.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/14/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit

protocol MainViewCellDelegate {
    func handleInfoButtonPressed(sender: MainViewCell)
}

class MainViewCell: UITableViewCell {

    let containerView = UIView()
    let content = UIView()
    let flag = UIImageView()
    let name = UILabel()
    let rate = UILabel()
    let high = UILabel()
    let low = UILabel()
    let info = UIButton()
    let trendArrow = UIImageView()

    let trend: Bool = true
    var delegate: MainViewCellDelegate? = nil

    let numberAttribute = [
        NSAttributedString.Key.foregroundColor : UIColor.cyan,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 50)
    ]

    let smallNumberAttribute = [
        NSAttributedString.Key.foregroundColor : UIColor.black,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)
    ]


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initContainer()
        initContent()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initContainer() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear

        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            containerView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }


    func attributedString(first: String, decimal: String) -> NSAttributedString {
        let result = NSMutableAttributedString(string: "")

        result.append(NSAttributedString(string: first, attributes: numberAttribute))
        result.append(NSAttributedString(string: decimal, attributes: smallNumberAttribute))

        return result
    }

    func initContent() {
        containerView.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false

        content.backgroundColor = .yellow

        content.layer.cornerRadius = 10
        content.layer.shadowColor = UIColor.gray.cgColor
        content.layer.shadowOffset = CGSize.zero
        content.layer.shadowOpacity = 0.3
        content.layer.shadowRadius = 5.0
        content.layer.masksToBounds = false

        content.addSubview(flag)
        flag.translatesAutoresizingMaskIntoConstraints = false

        content.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = "HKD"
        name.textColor = .black

        content.addSubview(rate)
        rate.translatesAutoresizingMaskIntoConstraints = false
        rate.attributedText = attributedString(first: "6", decimal: ".869")

        content.addSubview(high)
        high.translatesAutoresizingMaskIntoConstraints = false
        high.textColor = .green
        high.text = "H: " + "6.789"

        content.addSubview(low)
        low.translatesAutoresizingMaskIntoConstraints = false
        low.textColor = .magenta
        low.text = "L: " + "6.567"

        content.addSubview(info)
        info.translatesAutoresizingMaskIntoConstraints = false
        info.setImage(#imageLiteral(resourceName: "info"), for: .normal)
        info.addTarget(self, action: #selector(handleInfoButtonPressed(_:)), for: .touchUpInside)

        content.addSubview(trendArrow)
        trendArrow.translatesAutoresizingMaskIntoConstraints = false
        trendArrow.image = trend ? #imageLiteral(resourceName: "increase") : #imageLiteral(resourceName: "decrease")

        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            content.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            content.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            content.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            flag.centerYAnchor.constraint(equalTo: content.centerYAnchor),
            flag.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 12),
            flag.widthAnchor.constraint(equalToConstant: 45),
            flag.heightAnchor.constraint(equalToConstant: 45),
            name.centerYAnchor.constraint(equalTo: content.centerYAnchor),
            name.leadingAnchor.constraint(equalTo: flag.trailingAnchor, constant: 10),
            rate.topAnchor.constraint(equalTo: content.topAnchor, constant: 20),
            rate.leadingAnchor.constraint(equalTo: name.trailingAnchor, constant: 60),
            high.leadingAnchor.constraint(equalTo: name.trailingAnchor, constant: 60),
            high.topAnchor.constraint(equalTo: content.bottomAnchor, constant: -30),
            low.leadingAnchor.constraint(equalTo: high.trailingAnchor, constant: 30),
            low.topAnchor.constraint(equalTo: content.bottomAnchor, constant: -30),
            info.widthAnchor.constraint(equalToConstant: 36),
            info.heightAnchor.constraint(equalToConstant: 36),
            info.centerYAnchor.constraint(equalTo: content.centerYAnchor),
            info.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -10),
            trendArrow.leadingAnchor.constraint(equalTo: rate.trailingAnchor, constant: 15),
            trendArrow.topAnchor.constraint(equalTo: content.topAnchor, constant: 40)
        ])
    }
}

extension MainViewCell {
    @objc func handleInfoButtonPressed(_ sender: UIButton) {
        delegate?.handleInfoButtonPressed(sender: self)
    }
}
