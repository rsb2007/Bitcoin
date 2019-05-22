//
//  CryptoCurrencyHistoricalPriceDetailViewModel.swift
//  BitCoin
//
//  Created by R B on 2019-05-20.
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import Foundation

enum CryptoCurrencyHistoricalPriceDetailViewModelState {
    case loading
    case loaded
    case error
}

protocol CryptoCurrencyHistoricalPriceDetailViewModelDelegate {
    
    func CryptoCurrencyHistoricalPriceDetailViewModel(_ viewModel: CryptoCurrencyHistoricalPriceDetailViewModel, didChangeStateTo state: CryptoCurrencyHistoricalPriceDetailViewModelState)
}

protocol CryptoCurrencyHistoricalPriceDetailViewModel {
    
    var delegate: CryptoCurrencyHistoricalPriceDetailViewModelDelegate? { get set }
    
    var selectedCryptoCurrencyCode: String { get }
    
    var selectedDateTitle: Date { get }
    
    func requestDetail()
    
    func numberOfRows() -> Int
    
    func currencyLabel(at index: Int) -> String?
    
    func priceLabel(at index: Int) -> String?
}
