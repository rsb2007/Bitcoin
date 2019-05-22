//
//  CryptoCurrencyHistoricalPriceDetailViewCell.swift
//  BitCoin
//
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import UIKit

class CryptoCurrencyHistoricalPriceDetailViewCell: UITableViewCell {
    
    // MARK: - Internal Properties

    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension CryptoCurrencyHistoricalPriceDetailViewCell: Reusable { }
