//
//  CryptoCurrencyPriceProvider.swift
//  BitCoin
//
//  Created by R B on 2019-05-18.
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import Foundation

typealias CryptoCurrencyPriceProviderFetchCurrentPriceResult = Result<Price, Error>
typealias CryptoCurrencyPriceProviderFetchCurrentPriceCompletion = (CryptoCurrencyPriceProviderFetchCurrentPriceResult) -> Void

typealias CryptoCurrencyPriceProviderFetchHistoricalPriceResult = Result<Price, Error>
typealias CryptoCurrencyPriceProviderFetchHistoricalPriceCompletion = (CryptoCurrencyPriceProviderFetchHistoricalPriceResult) -> Void

protocol CryptoCurrencyPriceProvider {
    
    @discardableResult
    func requestCurrentPrice(for cryptoCurrency: CryptoCurrency, completion: CryptoCurrencyPriceProviderFetchCurrentPriceCompletion) -> CancelableTask?
    
    @discardableResult
    func requestHistoricalPrice(for cryptoCurrency: CryptoCurrency, completion: CryptoCurrencyPriceProviderFetchHistoricalPriceCompletion) -> CancelableTask?
}
