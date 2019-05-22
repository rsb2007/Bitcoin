//
//  CryptoCurrencyListViewModel.swift
//  BitCoin
//
//  Created by R B on 2019-05-18.
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import Foundation

enum CryptoCurrencyHistoricalPriceViewModelState {
    case loading
    case loaded
    case failed(error: String)
}

protocol CryptoCurrencyHistoricalPriceViewModelDelegate: class {
    
    func cryptoCurrencyHistoricalPriceViewModel(_ viewModel: CryptoCurrencyHistoricalPriceViewModel, didChangeStateTo state: CryptoCurrencyHistoricalPriceViewModelState)
}

protocol CryptoCurrencyHistoricalPriceViewModel {
 
    var delegate: CryptoCurrencyHistoricalPriceViewModelDelegate? { get set }
    
    func load(for cryptoCurrency: CryptoCurrency, showIn currency: Currency, filter: HistoricalFilter)
    
    func numberOfSections() -> Int
    
    func numberOfRowsInSection(_ section: Int) -> Int
    
    func titleForHeaderInSection(_ section: Int) -> String?
    
    func priceItemViewModel(at index: Int) -> CryptoCurrencyHistoricalPriceItemViewModel?
}
