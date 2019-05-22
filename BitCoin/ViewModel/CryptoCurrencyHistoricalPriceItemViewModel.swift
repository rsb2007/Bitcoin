//
//  CryptoCurrencyHistoricalPriceItemViewModel.swift
//  BitCoin
//
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import Foundation

protocol CryptoCurrencyHistoricalPriceItemViewModel {
    
    var date: Date { get }
    
    var formattedDate: String { get }
    
    var formattedPrice: String { get }
    
}
