//
//  CryptoCurrencyHistoricalPriceTableViewCell.swift
//  BitCoin
//
//  Created by R B on 2019-05-18.
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import UIKit

class CryptoCurrencyHistoricalPriceItemCell: UITableViewCell {

    // MARK: - Internal Properties
    
    @IBOutlet weak var historicalDateLabel: UILabel!
    
    @IBOutlet weak var historicalPriceLabel: UILabel!
        
    @IBOutlet weak var currencyLabel: UILabel!
    
    // MARK: - Overridden Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - Reusable

extension CryptoCurrencyHistoricalPriceItemCell: Reusable { }
