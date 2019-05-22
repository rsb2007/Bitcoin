//
//  DefaultBitcoinListViewModel.swift
//  BitCoin
//
//  Created by R B on 2019-05-18.
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import Foundation

final class DefaultCryptoCurrencyHistoricalPriceViewModel {
    
    // MARK: - Internal Properties
    
    var prices: [Price] = []
    
    weak var delegate: CryptoCurrencyHistoricalPriceViewModelDelegate?
    
    // MARK: - Private Properties
    
    private let apiService: CoinDeskAPIService
    
    private var state: CryptoCurrencyHistoricalPriceViewModelState? {
        didSet {
            guard let state = state else {
                return
            }
            delegate?.cryptoCurrencyHistoricalPriceViewModel(self, didChangeStateTo: state)
        }
    }
    
    private var historicalPriceModel: HistoricalPriceModel? {
        didSet {
            var itemViewModels: [CryptoCurrencyHistoricalPriceItemViewModel] = []
            guard let model = historicalPriceModel else {
                historicalPriceItemViewModels = itemViewModels
                return
            }
            for (date, rate) in model.priceByDate {
                itemViewModels.append(DefaultCryptoCurrencyHistoricalPriceItemViewModel(date: date, rate: "\(rate)"))
            }
            itemViewModels.sort { $0.formattedDate > $1.formattedDate }
            historicalPriceItemViewModels = itemViewModels
        }
    }
    
    private var historicalPriceItemViewModels: [CryptoCurrencyHistoricalPriceItemViewModel] = []
    
    // MARK: - Initializers
    
    init(apiService: CoinDeskAPIService) {
        self.apiService = apiService
    }
    
    func load(for cryptoCurrency: CryptoCurrency, showIn currency: Currency, filter: HistoricalFilter) {
        
        state = .loading
        
        apiService.fetchHistoricalPrice(cryptoCurrency: cryptoCurrency, filter: filter) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            let newState: CryptoCurrencyHistoricalPriceViewModelState
            switch result {
            case let .success(historicalPriceResponse):
                strongSelf.historicalPriceModel = HistoricalPriceModel(currency: currency,
                                                            cryptoCurrency: cryptoCurrency,
                                                            priceByDate: historicalPriceResponse.priceByDate)
                newState = .loaded
            case .failure(_):
                newState = .failed(error: "Unable to load.")
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.state = newState
            }
        }
    }
}

// MARK: - CryptoCurrencyListViewModel

extension DefaultCryptoCurrencyHistoricalPriceViewModel: CryptoCurrencyHistoricalPriceViewModel {
    
    func numberOfSections() -> Int {
        guard let _ = historicalPriceModel else {
            return 0
        }
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        guard let model = historicalPriceModel else {
            return 0
        }
        return model.priceByDate.keys.count
    }
    
    func titleForHeaderInSection(_ section: Int) -> String? {
        return "Last 2 Weeks Prices"
    }
    
    func priceItemViewModel(at index: Int) -> CryptoCurrencyHistoricalPriceItemViewModel? {
        return historicalPriceItemViewModels[index]
    }
}

class HistoricalPriceModel {
    let currency: Currency
    let cryptoCurrency: CryptoCurrency
    let priceByDate: [Date: Double]
    
    init(currency: Currency, cryptoCurrency: CryptoCurrency, priceByDate: [Date: Double]) {
        self.currency = currency
        self.cryptoCurrency = cryptoCurrency
        self.priceByDate = priceByDate
    }
}
