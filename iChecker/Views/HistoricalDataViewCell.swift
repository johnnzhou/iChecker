//
//  HistoricalDataViewCell.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/17/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit

class HistoricalDataViewCell: UICollectionViewCell {

    // main container
    let mainContainer = UIView()
    let realTimeLabel = UILabel()
    let rate = UILabel()
    let dailyLabel = UILabel()
    let dailyLow = UILabel()
    let dailyHigh = UILabel()

    // trend container
    let trendContainer = UIView()
    let trendRate = UILabel()
    let trendDirection = UIImageView()

    // share container
    let shareContainer = UIView()
    let shareIcon = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
    let shareLabel = UILabel()

    // historical data container
    let historicalDataContainer = UIView()
    let range = UILabel()
    let rangeMax = UILabel()
    let rangeMin = UILabel()
    let average = UILabel()
    let averageChange = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        initContainer()
        initMain()
        initTrend()
        initShare()
        initHistoricalData()
    }

    func initContainer(){
        contentView.addSubview(mainContainer)
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.backgroundColor = .green
        mainContainer.layer.cornerRadius = 10
        mainContainer.layer.shadowColor = UIColor.gray.cgColor
        mainContainer.layer.shadowOffset = CGSize.zero
        mainContainer.layer.shadowOpacity = 0.3
        mainContainer.layer.shadowRadius = 5.0
        mainContainer.layer.masksToBounds = false

        contentView.addSubview(trendContainer)
        trendContainer.translatesAutoresizingMaskIntoConstraints = false
        trendContainer.backgroundColor = .blue
        trendContainer.layer.cornerRadius = 10
        trendContainer.layer.shadowColor = UIColor.gray.cgColor
        trendContainer.layer.shadowOffset = CGSize.zero
        trendContainer.layer.shadowOpacity = 0.3
        trendContainer.layer.shadowRadius = 5.0
        trendContainer.layer.masksToBounds = false

        contentView.addSubview(shareContainer)
        shareContainer.translatesAutoresizingMaskIntoConstraints = false
        shareContainer.backgroundColor = .gray
        shareContainer.layer.cornerRadius = 10
        shareContainer.layer.shadowColor = UIColor.gray.cgColor
        shareContainer.layer.shadowOffset = CGSize.zero
        shareContainer.layer.shadowOpacity = 0.3
        shareContainer.layer.shadowRadius = 5.0
        shareContainer.layer.masksToBounds = false

        contentView.addSubview(historicalDataContainer)
        historicalDataContainer.translatesAutoresizingMaskIntoConstraints = false
        historicalDataContainer.backgroundColor = .yellow
        historicalDataContainer.layer.cornerRadius = 10
        historicalDataContainer.layer.shadowColor = UIColor.gray.cgColor
        historicalDataContainer.layer.shadowOffset = CGSize.zero
        historicalDataContainer.layer.shadowOpacity = 0.3
        historicalDataContainer.layer.shadowRadius = 5.0
        historicalDataContainer.layer.masksToBounds = false

        NSLayoutConstraint.activate([
            mainContainer.widthAnchor.constraint(equalToConstant: 184),
            mainContainer.heightAnchor.constraint(equalToConstant: 180),
            mainContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            mainContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            trendContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            trendContainer.leadingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: 20),
            trendContainer.widthAnchor.constraint(equalToConstant: 118),
            trendContainer.heightAnchor.constraint(equalToConstant: 110),
            trendContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            shareContainer.topAnchor.constraint(equalTo: trendContainer.bottomAnchor, constant: 20),
            shareContainer.leadingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: 20),
            shareContainer.widthAnchor.constraint(equalToConstant: 118),
            shareContainer.heightAnchor.constraint(equalToConstant: 40),
            shareContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            historicalDataContainer.topAnchor.constraint(equalTo: mainContainer.bottomAnchor, constant: 50),
            historicalDataContainer.heightAnchor.constraint(equalToConstant: 120),
            historicalDataContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            historicalDataContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            historicalDataContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])

    }

    func initMain() {
        mainContainer.addSubview(realTimeLabel)
        realTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        realTimeLabel.text = "Real time:"

        mainContainer.addSubview(rate)
        rate.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.addSubview(dailyLabel)
        dailyLabel.translatesAutoresizingMaskIntoConstraints = false
        dailyLabel.text = "Daily: "
        mainContainer.addSubview(dailyLow)
        dailyLow.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.addSubview(dailyHigh)
        dailyHigh.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            realTimeLabel.topAnchor.constraint(equalTo: mainContainer.topAnchor, constant: 10),
            realTimeLabel.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 15),
            rate.topAnchor.constraint(equalTo: realTimeLabel.bottomAnchor, constant: 20),
            rate.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor),
            dailyLabel.topAnchor.constraint(equalTo: mainContainer.bottomAnchor, constant: -50),
            dailyLabel.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 15),
            dailyHigh.topAnchor.constraint(equalTo: dailyLabel.bottomAnchor, constant: 5),
            dailyHigh.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 15),
            dailyLow.topAnchor.constraint(equalTo: dailyLabel.bottomAnchor, constant: 5),
            dailyLow.leadingAnchor.constraint(equalTo: dailyHigh.trailingAnchor, constant: 20),
        ])
    }

    func initTrend() {
        trendContainer.addSubview(trendRate)
        trendRate.translatesAutoresizingMaskIntoConstraints = false
        trendContainer.addSubview(trendDirection)
        trendDirection.translatesAutoresizingMaskIntoConstraints = false

        trendRate.textColor = .black

        NSLayoutConstraint.activate([
            trendRate.centerXAnchor.constraint(equalTo: trendContainer.centerXAnchor),
            trendRate.centerYAnchor.constraint(equalTo: trendContainer.centerYAnchor, constant: -10),
            trendDirection.topAnchor.constraint(equalTo: trendRate.bottomAnchor, constant: 10),
            trendDirection.centerXAnchor.constraint(equalTo: trendContainer.centerXAnchor)
        ])
    }

    func initShare() {
        shareContainer.addSubview(shareIcon)
        shareIcon.translatesAutoresizingMaskIntoConstraints = false
        let iconImage = UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal)
        shareIcon.setBackgroundImage(iconImage, for: .normal)
        shareContainer.addSubview(shareLabel)
        shareLabel.translatesAutoresizingMaskIntoConstraints = false
        shareLabel.text = "Share"



        NSLayoutConstraint.activate([
            shareIcon.centerYAnchor.constraint(equalTo: shareContainer.centerYAnchor),
            shareIcon.centerXAnchor.constraint(equalTo: shareContainer.centerXAnchor, constant: -20),
            shareIcon.widthAnchor.constraint(equalToConstant: 20),
            shareIcon.heightAnchor.constraint(equalToConstant: 20),
            shareLabel.leadingAnchor.constraint(equalTo: shareIcon.trailingAnchor, constant: 10),
            shareLabel.centerYAnchor.constraint(equalTo: shareContainer.centerYAnchor)
        ])
    }

    func initHistoricalData() {
        historicalDataContainer.addSubview(range)
        range.translatesAutoresizingMaskIntoConstraints = false
        historicalDataContainer.addSubview(rangeMax)
        rangeMax.translatesAutoresizingMaskIntoConstraints = false
        historicalDataContainer.addSubview(rangeMin)
        rangeMin.translatesAutoresizingMaskIntoConstraints = false
        historicalDataContainer.addSubview(average)
        average.translatesAutoresizingMaskIntoConstraints = false
        historicalDataContainer.addSubview(averageChange)
        averageChange.translatesAutoresizingMaskIntoConstraints = false
        averageChange.text = "Avg Change: " + "0.007"

        NSLayoutConstraint.activate([
            range.topAnchor.constraint(equalTo: historicalDataContainer.topAnchor, constant: 10),
            range.leadingAnchor.constraint(equalTo: historicalDataContainer.leadingAnchor, constant: 15),
            rangeMax.topAnchor.constraint(equalTo: range.bottomAnchor, constant: 30),
            rangeMax.leadingAnchor.constraint(equalTo: historicalDataContainer.leadingAnchor, constant: 15),
            average.topAnchor.constraint(equalTo: rangeMax.bottomAnchor, constant: 10),
            average.leadingAnchor.constraint(equalTo: historicalDataContainer.leadingAnchor, constant: 15),
            rangeMin.topAnchor.constraint(equalTo: range.bottomAnchor, constant: 30),
            rangeMin.leadingAnchor.constraint(equalTo: rangeMax.trailingAnchor, constant: 20),
            averageChange.topAnchor.constraint(equalTo: rangeMin.bottomAnchor, constant: 10),
            averageChange.leadingAnchor.constraint(equalTo: average.trailingAnchor, constant: 20),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
