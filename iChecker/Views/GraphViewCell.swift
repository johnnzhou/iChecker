//
//  GraphViewCell.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/17/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit
import Charts

protocol GraphViewCellDelegate {
    func handleSegmentControlPressed(sender: GraphViewCell)
}


class GraphViewCell: UICollectionViewCell {
    let container = UIView()
    let segmentControl = UISegmentedControl(items: ["7 days", "15 days", "30 days"])
    let lineChart = LineChartView()
    var delegate: GraphViewCellDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        initContainer()
        initSegmentControl()
        initGraph()
    }

    func initContainer() {
        contentView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    func initSegmentControl() {
        container.addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.center = self.contentView.center
        segmentControl.addTarget(self, action: #selector(handleSegmentControlPressed(_:)), for: .valueChanged)

        segmentControl.selectedSegmentIndex = 0
        segmentControl.layer.cornerRadius = 5

        NSLayoutConstraint.activate([
            segmentControl.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ])

    }

    func initGraph() {
        container.addSubview(lineChart)
        lineChart.translatesAutoresizingMaskIntoConstraints = false
//        lineChart.dragEnabled = false
//        lineChart.pinchZoomEnabled = false
        lineChart.animate(xAxisDuration: 3, easingOption: .easeInBounce)
        lineChart.xAxis.enabled = false
        lineChart.rightAxis.enabled = false
        lineChart.legend.enabled = false
        lineChart.backgroundColor = .white
        lineChart.setScaleEnabled(false)
        lineChart.leftAxis.drawAxisLineEnabled = false
        lineChart.leftAxis.drawGridLinesEnabled = false

        NSLayoutConstraint.activate([
            lineChart.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 10),
            lineChart.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            lineChart.widthAnchor.constraint(equalTo: container.widthAnchor),
            lineChart.heightAnchor.constraint(equalTo: container.heightAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GraphViewCell {
    @objc func handleSegmentControlPressed(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("7 days")
        case 1:
            print("15 days")
        case 2:
            print("30 days")
        default:
            break
        }
    }
}
