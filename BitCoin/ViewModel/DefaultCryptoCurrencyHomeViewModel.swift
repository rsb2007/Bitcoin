//
//  DefaultCryptoCurrencyHomeViewModel.swift
//  BitCoin
//
//  Created by R B on 2019-05-18.
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import Foundation

final class DefaultCryptoCurrencyHomeViewModel {
    
    // MARK: - Internal Properties
    
    weak var delegate: CryptoCurrencyHomeViewModelDelegate?
    
    let historicalPriceViewModel: CryptoCurrencyHistoricalPriceViewModel
    
    let selectedCryptoCurrency: CryptoCurrency
    
    // MARK: - Private Properties
    
    private let apiService: CoinDeskAPIService
    
    private var state: CryptoCurrencyHomeViewModelState? {
        didSet {
            guard let state = state else {
                return
            }
            delegate?.cryptoCurrencyHomeViewModel(self, didChangeStateTo: state)
        }
    }
    
    private var timer: Timer?
    
    private let refreshTimeInterval: TimeInterval = 60
    
    private let selectedCurrency: Currency
    
    // MARK: - Initializers
    
    init(apiService: CoinDeskAPIService) {
        self.apiService = apiService
        self.selectedCryptoCurrency = .bitcoin
        self.selectedCurrency = .EURO
        self.historicalPriceViewModel = DefaultCryptoCurrencyHistoricalPriceViewModel(apiService: apiService)
    }
    
    private func refreshCurrentPrice() {
        state = .loading
        apiService.fetchCurrentPrice(cryptoCurrency: selectedCryptoCurrency) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            let newState: CryptoCurrencyHomeViewModelState
            switch result {
            case let .success(currentPriceResponse):
                if let rate = currentPriceResponse.priceByCurrency[strongSelf.selectedCurrency] {
                    let price = Price(rate: rate, currency: strongSelf.selectedCurrency)
                    newState = .loaded(price: price)
                }
                else {
                    newState = .failed(error: "Unable to load.")
                }
            case .failure(_):
                newState = .failed(error: "Unable to load.")
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.state = newState
            }
        }
    }
    
    
    // MARK: - Private Methods
    
    private func startTimer() {
        resetTimer()
        self.timer = Timer.scheduledTimer(withTimeInterval: refreshTimeInterval, repeats: true) { [weak self] _ in
            self?.refreshCurrentPrice()
        }
    }
    
    private func resetTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // MARK: - Deinitializer
    
    deinit {
        resetTimer()
    }
}

// MARK: - CryptoCurrencyListViewModel

extension DefaultCryptoCurrencyHomeViewModel: CryptoCurrencyHomeViewModel {
    
    var title: String {
        return selectedCryptoCurrency.description
    }
    
    var selectedCurrencyTitle: String {
        return selectedCurrency.symbol
    }
    
    func load() {
        startTimer()
        refreshCurrentPrice()
        
        let todayDate = Date()
        if let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: todayDate),
            let dateBeforeTwoWeeks = Calendar.current.date(byAdding: .weekOfYear, value: -2, to: yesterday) {
            let filter = HistoricalFilter(startDate: dateBeforeTwoWeeks, endDate: yesterday)
            historicalPriceViewModel.load(for: selectedCryptoCurrency, showIn: selectedCurrency, filter: filter)
        }
    }
}
