//
//  CoinDesk.swift
//  BitCoin
//
//  Created by R B on 2019-05-18.
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import Foundation

struct HistoricalFilter {
    let startDate: Date
    let endDate: Date
    let currency: Currency
    
    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
        self.currency = .EURO
    }
    
    init(startDate: Date, endDate: Date, currency: Currency) {
        self.startDate = startDate
        self.endDate = endDate
        self.currency = currency
    }
}

enum CoinDeskAPIError: Error {
    case parseError
    case networkError
}

typealias CoinDeskAPIServiceFetchCurrentPriceResult = Result<CoinDeskCurrentPriceResponse, CoinDeskAPIError>
typealias CoinDeskAPIServiceFetchCurrentPriceCompletion = (CoinDeskAPIServiceFetchCurrentPriceResult) -> Void

typealias CoinDeskAPIServiceFetchHistoricalPriceResult = Result<CoinDeskHistoricalPriceResponse, CoinDeskAPIError>
typealias CoinDeskAPIServiceFetchHistoricalPriceCompletion = (CoinDeskAPIServiceFetchHistoricalPriceResult) -> Void

typealias CoinDeskAPIServicePriceIndexByDateResult = Result<CoinDeskPriceIndexByDateResponse, CoinDeskAPIError>
typealias CoinDeskAPIServicePriceIndexByDateCompletion = (CoinDeskAPIServicePriceIndexByDateResult) -> Void

final class CoinDeskAPIService {
    
    // MARK: - Private Properties
    
    private let networking: Networking
    
    // MARK: - Initializers
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func fetchCurrentPrice(cryptoCurrency: CryptoCurrency, completion: @escaping CoinDeskAPIServiceFetchCurrentPriceCompletion) {
        let endpoint: CoinDeskEndpoint = .currentPrice(cryptoCurrency: cryptoCurrency)
        _ = networking.request(from: endpoint) { result in
            switch result {
            case let .success(data):
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONObjectType,
                    let currentPriceResponse = CoinDeskCurrentPriceResponse(JSONObject: jsonObject) else {
                        completion(.failure(.parseError))
                        return
                }
                completion(.success(currentPriceResponse))
            case .failure:
                completion(.failure(.networkError))
            }
        }
    }
    
    func fetchHistoricalPrice(cryptoCurrency: CryptoCurrency, filter: HistoricalFilter, completion: @escaping CoinDeskAPIServiceFetchHistoricalPriceCompletion) {
        let endpoint: CoinDeskEndpoint = .historicalPrice(cryptoCurrency: cryptoCurrency, filter: filter)
        _ = networking.request(from: endpoint) { result in
            switch result {
            case let .success(data):
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONObjectType else {
                    completion(.failure(.parseError))
                    return
                }
                guard let historicalPriceResponse = CoinDeskHistoricalPriceResponse(JSONObject: jsonObject) else {
                    completion(.failure(.parseError))
                    return
                }
                completion(.success(historicalPriceResponse))
            case .failure:
                completion(.failure(.networkError))
            }
        }
    }
    
    func fetchHistoricalPriceDetail(cryptoCurrency: CryptoCurrency, currencyList: [Currency], date: Date, completion: @escaping CoinDeskAPIServicePriceIndexByDateCompletion) {
        var rateByCurrency : [Currency: Double] = [:]
        let dispatchGroup = DispatchGroup()
        currencyList.forEach {
            let filter = HistoricalFilter(startDate: date, endDate: date, currency: $0)
            dispatchGroup.enter()
            let currency = $0
            fetchHistoricalPrice(cryptoCurrency: cryptoCurrency, filter: filter) { result in
                switch result {
                case let .success(response):
                    let rate = response.priceByDate[date]
                    rateByCurrency[currency] = rate
                case .failure:
                    print("Unable to fetch Historical Price Detail...")
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            let response = CoinDeskPriceIndexByDateResponse(rateByCurrency: rateByCurrency)
            completion(.success(response))
        }
    }
}
