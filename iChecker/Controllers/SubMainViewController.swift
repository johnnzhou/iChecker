//
//  SubMainViewController.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/17/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit
import Hero
import RealmSwift
import Charts

enum Sections: Int, CaseIterable {
    case data = 0
    case graph
}

class SubMainViewController: UIViewController {

    var id: String? = nil
    let realm = try! Realm()
    var data: ExchangeRate? = nil
    var rates: List<Double>? = nil

    let numberAttribute = [
        NSAttributedString.Key.foregroundColor : UIColor.cyan,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30)
    ]

    let smallNumberAttribute = [
        NSAttributedString.Key.foregroundColor : UIColor.black,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)
    ]

    let rateAttribute = [
        NSAttributedString.Key.foregroundColor : UIColor.cyan,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 50)
    ]

    let smallRateAttribute = [
        NSAttributedString.Key.foregroundColor : UIColor.black,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)
    ]

    init(id: String, data: ExchangeRate) {
        super.init(nibName: nil, bundle: nil)
        self.id = id
        self.data = data
        self.rates = self.data?.rates
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var dayRange: Int = 7

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let colletionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return colletionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        initNavigation()
        initCollectionView()
    }

    func initNavigation() {
        guard let dataList = data else {
            return
        }
        navigationItem.title = "\(dataList.base?.flag ?? "") - \(dataList.symbol?.flag ?? "")"
    }

    func initCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        collectionView.contentInset = UIEdgeInsets(top: 20, left: 12, bottom: 40, right: 12)

        collectionView.register(HistoricalDataViewCell.self, forCellWithReuseIdentifier: "\(HistoricalDataViewCell.self)")
        collectionView.register(GraphViewCell.self, forCellWithReuseIdentifier: "\(GraphViewCell.self)")
    }
}

extension SubMainViewController {
    func attributedString(first: String, decimal: String) -> NSAttributedString {
        let result = NSMutableAttributedString(string: "")

        result.append(NSAttributedString(string: first, attributes: numberAttribute))
        result.append(NSAttributedString(string: ".", attributes: numberAttribute))
        result.append(NSAttributedString(string: decimal, attributes: smallNumberAttribute))
        result.append(NSAttributedString(string: "%", attributes: numberAttribute))
        return result
    }

    func attributedRateString(first: String, decimal: String) -> NSAttributedString {
        let result = NSMutableAttributedString(string: "")

        result.append(NSAttributedString(string: first, attributes: rateAttribute))
        result.append(NSAttributedString(string: ".", attributes: rateAttribute))
        result.append(NSAttributedString(string: decimal, attributes: smallRateAttribute))
        return result
    }
}

extension SubMainViewController: UICollectionViewDelegate {

}

extension SubMainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Sections.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sec = Sections(rawValue: section) else {
            fatalError("Unknown Section \(section)")
        }

        switch sec {
        case .data:
            return 1
        case .graph:
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sec = Sections(rawValue: indexPath.section) else {
            fatalError("Unknown Section \(indexPath.section)")
        }

        switch sec {
        case .data:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(HistoricalDataViewCell.self)", for: indexPath) as! HistoricalDataViewCell
            guard let dataList = data else {
                return cell
            }
            let realTime = String(format: "%.3f", dataList.now).split(separator: ".")
            let trendRate = String(format: "%.3f", dataList.changeRate).split(separator: ".")
            cell.rate.attributedText = attributedRateString(first: String(realTime[0]), decimal: String(realTime[1]))
            cell.dailyLow.text = "L:" + String(format: "%.3f", dataList.dailyLow)
            cell.dailyHigh.text = "H: " + String(format: "%.3f", dataList.dailyHigh)
            cell.trendRate.attributedText = attributedString(first: String(trendRate[0]), decimal: String(trendRate[1]));
            cell.trendDirection.image = dataList.trend ? #imageLiteral(resourceName: "increase") : #imageLiteral(resourceName: "decrease")
            cell.range.text = "\(dataList.dates[0]) -- \(dataList.dates[dataList.dates.count - 1])"
            cell.rangeMax.text = "Max: " + String(format: "%.3f", dataList.rangeMax)
            cell.rangeMin.text = "Min: " + String(format: "%.3f", dataList.rangeMin)
            cell.average.text = "Average: " + String(format: "%.3f", dataList.average)
            cell.averageChange.text = "Avg Change: " + String(format: "%.3f", dataList.averageChange)

            return cell
        case .graph:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(GraphViewCell.self)", for: indexPath) as! GraphViewCell
            cell.delegate = self
            guard let ratesList = rates else {
                return cell
            }
            var lineChartEntry = [ChartDataEntry]()
            for i in 0..<dayRange {
                let value = ChartDataEntry(x: Double(i), y: ratesList[dayRange - 1 - i])
                lineChartEntry.append(value)
            }

            let dataSet = LineChartDataSet(entries: lineChartEntry, label: "")
            dataSet.mode = .cubicBezier
            dataSet.drawCirclesEnabled = false
            dataSet.lineWidth = 1.8
            dataSet.circleRadius = 4
            dataSet.setCircleColor(.white)
            let gradient = [ChartColorTemplates.colorFromString("#DBEBC2").cgColor,
                            ChartColorTemplates.colorFromString("#ACDBC9").cgColor]
            let gradientColor = CGGradient(colorsSpace: nil, colors: gradient as CFArray, locations: nil)!
            dataSet.fillAlpha = 1
            dataSet.fill = Fill(linearGradient: gradientColor, angle: 90)
            dataSet.drawFilledEnabled = true
            dataSet.drawHorizontalHighlightIndicatorEnabled = false
            dataSet.valueFont = .systemFont(ofSize: 9)

            let data = LineChartData(dataSet: dataSet)
            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 9)!)
            data.setDrawValues(false)

            cell.lineChart.animate(xAxisDuration: 1.5, easingOption: .easeInQuad)
            cell.lineChart.data = data

            return cell
        }
    }
}

extension SubMainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let sec = Sections(rawValue: indexPath.section) else {
            fatalError("Unknow Section \(indexPath.section)")
        }
        let width = view.bounds.width
        switch sec {
        case .data:
            return CGSize(width: width - 20, height: 450)
        case .graph:
            return CGSize(width: width, height: 450)
        }
    }
}

extension SubMainViewController: GraphViewCellDelegate {
    func handleSegmentControlPressed(sender: GraphViewCell) {

        let index = sender.segmentControl.selectedSegmentIndex
        switch index {
        case 0:
            dayRange = 7
        case 1:
            dayRange = 15
        case 2:
            dayRange = 30
        default:
            break
        }
        print(dayRange)
        self.collectionView.reloadData()
    }
}
