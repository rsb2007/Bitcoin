//
//  CryptoCurrencyHomeViewModel.swift
//  BitCoin
//
//  Created by R B on 2019-05-18.
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import Foundation

enum CryptoCurrencyHomeViewModelState {
    case loading
    case loaded(price: Price)
    case failed(error: String)
}

protocol CryptoCurrencyHomeViewModelDelegate: class {
    
    func cryptoCurrencyHomeViewModel(_ viewModel: CryptoCurrencyHomeViewModel, didChangeStateTo state: CryptoCurrencyHomeViewModelState)
}

protocol CryptoCurrencyHomeViewModel {
    
    var delegate: CryptoCurrencyHomeViewModelDelegate? { get }
    
    var title: String { get }
    
    var selectedCurrencyTitle: String { get }
    
    var selectedCryptoCurrency: CryptoCurrency { get }
    
    var historicalPriceViewModel: CryptoCurrencyHistoricalPriceViewModel { get }
    
    func load()
}
