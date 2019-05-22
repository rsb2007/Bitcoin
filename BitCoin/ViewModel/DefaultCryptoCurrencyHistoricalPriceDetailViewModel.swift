//
//  DefaultCryptoCurrencyHistoricalPriceDetailViewModel.swift
//  BitCoin
//
//  Created by R B on 2019-05-20.
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import Foundation

class DefaultCryptoCurrencyHistoricalPriceDetailViewModel {
    
    // MARK: - Internal Properties
    
    var selectedCryptoCurrencyCode: String {
        return cryptoCurrency.description.uppercased()
    }
    
    var selectedDateTitle: Date {
        return date//dateFormatter.string(from: date)
    }
    
    var delegate: CryptoCurrencyHistoricalPriceDetailViewModelDelegate?
    
    // MARK: - Private Properties
    
    private let apiService: CoinDeskAPIService
    
    private let cryptoCurrency: CryptoCurrency
    
    private let date: Date
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    
    private var state: CryptoCurrencyHistoricalPriceDetailViewModelState? {
        didSet {
            guard let state = state else {
                return
            }
            delegate?.CryptoCurrencyHistoricalPriceDetailViewModel(self, didChangeStateTo: state)
        }
    }
    
    private var prices: [Price] = []
    
    // MARK: - Initializers
    
    init(apiService: CoinDeskAPIService, cryptoCurrency: CryptoCurrency, date: Date) {
        self.apiService = apiService
        self.cryptoCurrency = cryptoCurrency
        self.date = date
    }
    
    // MARK: - Internal Methods
    
    func numberOfRows() -> Int {
        return prices.count
    }
    
    func currencyLabel(at index: Int) -> String? {
        return prices[index].currency.symbol
    }
    
    func priceLabel(at index: Int) -> String? {
        return "\(prices[index].rate)"
    }
}

// MARK: - CryptoCurrencyHistoricalPriceDetailViewModel

extension DefaultCryptoCurrencyHistoricalPriceDetailViewModel: CryptoCurrencyHistoricalPriceDetailViewModel {
    
    func requestDetail() {
        state = .loading
        let requestPriceForCurrencies: [Currency] = [.EURO, .GBP, .USD]
        var historicalPrices: [Price] = []
        apiService.fetchHistoricalPriceDetail(cryptoCurrency: cryptoCurrency, currencyList: requestPriceForCurrencies, date: date) { result in
            switch result {
            case let .success(response):
                historicalPrices = response.rateByCurrency.compactMap { Price(rate: $0.value, currency: $0.key) }
            case let .failure(error):
                print(error)
            }
            self.prices = historicalPrices
            DispatchQueue.main.async { [weak self] in
                self?.state = .loaded
            }
        }
    }
}
