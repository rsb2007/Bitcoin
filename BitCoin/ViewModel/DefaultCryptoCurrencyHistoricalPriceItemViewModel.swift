//
//  DefaultCryptoCurrencyHistoricalPriceItemViewModel.swift
//  BitCoin
//
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import Foundation

final class DefaultCryptoCurrencyHistoricalPriceItemViewModel {
    
    // MARK: - Internal Properties
    
    let date: Date
    
    // MARK: - Private Properties
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private let rate: String
    
    // MARK: - Initializers
    
    init(date: Date, rate: String) {
        self.date = date
        self.rate = rate
    }
}

// MARK: - CryptoCurrencyHistoricalPriceItemViewModel

extension DefaultCryptoCurrencyHistoricalPriceItemViewModel: CryptoCurrencyHistoricalPriceItemViewModel {

    var formattedDate: String {
        return DefaultCryptoCurrencyHistoricalPriceItemViewModel.dateFormatter.string(from: date)
    }
    
    var formattedPrice: String {
        return rate
    }
}
