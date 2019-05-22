//
//  CoinDeskEndpoint.swift
//  BitCoin
//
//  Created by R B on 2019-05-18.
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import Foundation

enum CoinDeskEndpoint {
    case currentPrice(cryptoCurrency: CryptoCurrency)
    case historicalPrice(cryptoCurrency: CryptoCurrency, filter: HistoricalFilter)
}

extension CoinDeskEndpoint: Endpoint {
    
    var basePath: String {
        return "https://api.coindesk.com/v1"
    }
    
    var path: String {
        switch self {
        case let .currentPrice(cryptoCurrency):
            return "\(basePath)/\(cryptoCurrency.coinDeskPriceIndexIdentifier)/currentprice.json"
        case let .historicalPrice(cryptoCurrency, filter):
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let startDate = dateFormatter.string(from: filter.startDate)
            let endDate = dateFormatter.string(from: filter.endDate)
            return "\(basePath)/\(cryptoCurrency.coinDeskPriceIndexIdentifier)/historical/close.json?start=\(startDate)&end=\(endDate)&currency=\(filter.currency.code)"
        }
    }
}


// MARK: - CryptoCurrency

private extension CryptoCurrency {
    
    var coinDeskPriceIndexIdentifier: String {
        switch self {
        case .bitcoin:
            return "bpi"
        }
    }
}


private extension Currency {
    
    var code: String {
        switch self {
        case .EURO:
            return "EUR"
        case .GBP:
            return "GBP"
        case .USD:
            return "USD"
        }
    }
}

