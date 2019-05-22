//
//  TodayViewController.swift
//  BitcoinWidget
//
//  Created by R B on 2019-05-20.
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import UIKit
import NotificationCenter

typealias RefreshRateCompletion = (Bool) -> Void
class TodayViewController: UIViewController {
    
    @IBOutlet weak var rateLabel: UILabel!
    
    private let cryptoCurrency: CryptoCurrency = .bitcoin
    
    private let currency: Currency = .EURO
    
    private var timer: Timer?
    
    private let refreshTimeInterval: TimeInterval = 10
    
    private lazy var apiService: CoinDeskAPIService = {
        let networking = HTTPNetworking()
        return CoinDeskAPIService(networking: networking)
    }()
    
    private var currentPrice: Price? {
        didSet {
            guard let price = currentPrice else {
                rateLabel.text = "Loading..."
                return
            }
            rateLabel.text = "\(price.currency.symbol) \(price.rate)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        currentPrice = nil
        startTimer()
    }
    
    private func refreshRate(_ completion: ((Bool) -> Void)? = nil) {
        
        apiService.fetchCurrentPrice(cryptoCurrency: .bitcoin) { [weak self] result in
            
            guard let strongSelf = self else {
                return
            }
            
            let updatedPrice: Price?
            switch result {
            case let .success(currentPriceResponse):
                if let rate = currentPriceResponse.priceByCurrency[strongSelf.currency] {
                    updatedPrice = Price(rate: rate, currency: strongSelf.currency)
                }
                else {
                    updatedPrice = nil
                }
            case .failure:
                updatedPrice = nil
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.currentPrice = updatedPrice
            }
            
            let success = updatedPrice != nil
            completion?(success)
        }
    }
    
    private func startTimer() {
        resetTimer()
        self.timer = Timer.scheduledTimer(withTimeInterval: refreshTimeInterval, repeats: true) { [weak self] _ in
            self?.refreshRate()
        }
    }
    
    private func resetTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    deinit {
        resetTimer()
    }

}

extension TodayViewController: NCWidgetProviding {
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        refreshRate { (success) in
            if success {
                completionHandler(.newData)
            }
            else {
                completionHandler(.failed)
            }
        }
    }
}
