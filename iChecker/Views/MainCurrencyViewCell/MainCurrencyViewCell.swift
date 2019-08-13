//
//  MainCurrencyViewCell.swift
//  iChecker
//
//  Created by JOHN ZZN on 8/13/19.
//  Copyright © 2019 John Zhou. All rights reserved.
//

import UIKit

class MainCurrencyViewCell: UITableViewCell {
    @IBOutlet weak var currencyIcon: UIImageView!
    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var currencyRate: UILabel!
    @IBOutlet weak var dailyHigh: UILabel!
    @IBOutlet weak var dailyLow: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
