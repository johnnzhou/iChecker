//
//  SubMainViewController.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/17/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit
import Hero
import Charts

enum Sections: Int, CaseIterable {
    case data = 0
    case graph
}

class SubMainViewController: UIViewController {

    var dayRange: Int = 7
    let rates = [7.0429,
                 7.0429,
                 7.0339,
                 7.0244,
                 7.0435,
                 7.0580,
                 7.0624,
                 7.0626,
                 7.0626,
                 7.0454,
                 7.0604,
                 7.0261,
                 7.0507,
                 6.9401,
                 6.9402,
                 6.9402,
                 6.8986,
                 6.8842,
                 6.8844,
                 6.8936,
                 6.8792,
                 6.8798,
                 6.8798,
                 6.8726,
                 6.8726,
                 6.8792,
                 6.8811,
                 6.8817,
                 6.8819,
                 6.8817,
                 6.8800]

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
        navigationItem.title = "🇨🇳 - 🇺🇸"
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


            return cell
        case .graph:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(GraphViewCell.self)", for: indexPath) as! GraphViewCell
            cell.delegate = self
            var lineChartEntry = [ChartDataEntry]()
            for i in 0..<dayRange {
                let value = ChartDataEntry(x: Double(i), y: rates[dayRange - 1 - i])
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
