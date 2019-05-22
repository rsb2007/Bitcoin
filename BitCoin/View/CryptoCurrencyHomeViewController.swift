//
//  CryptoCurrencyHomeViewController.swift
//  BitCoin
//
//  Created by R B on 2019-05-18.
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import Foundation
import UIKit

class CryptoCurrencyHomeViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    var viewModel: CryptoCurrencyHomeViewModel?
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var selectedCurrencyLabel: UILabel!
    
    private var historicalPriceViewController: CryptoCurrencyHistoricalPriceViewController?
    
    // MARK: - Overridden Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel?.load()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let historicalPriceViewController = destination as? CryptoCurrencyHistoricalPriceViewController {
            self.historicalPriceViewController = historicalPriceViewController
            var historicalPriceViewModel = viewModel?.historicalPriceViewModel
            historicalPriceViewModel?.delegate = historicalPriceViewController
            historicalPriceViewController.viewModel = historicalPriceViewModel
            historicalPriceViewController.delegate = self
        }
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        title = viewModel?.title
        navigationController?.navigationBar.prefersLargeTitles = true
        selectedCurrencyLabel.text = viewModel?.selectedCurrencyTitle
        dateLabel.text = Date().currentDateWithMonthYear
    }
}

// MARK: - CryptoCurrencyListViewModelDelegate

extension CryptoCurrencyHomeViewController: CryptoCurrencyHomeViewModelDelegate {
    
    func cryptoCurrencyHomeViewModel(_ viewModel: CryptoCurrencyHomeViewModel, didChangeStateTo state: CryptoCurrencyHomeViewModelState) {
        switch state {
        case .loading:
            priceLabel.isHidden = false
            priceLabel.text = "Loading..."
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            view.bringSubviewToFront(activityIndicatorView)
        case let .loaded(price):
            activityIndicatorView.isHidden = true
            priceLabel.isHidden = false
            view.bringSubviewToFront(priceLabel)
            priceLabel.text = "\(price.rate)"
        case .failed:
            activityIndicatorView.isHidden = false
            priceLabel.isHidden = true
            priceLabel.text = "Unable to load."
        }
    }
}


// MARK: - CryptoCurrencyHistoricalPriceViewControllerDelegate

extension CryptoCurrencyHomeViewController: CryptoCurrencyHistoricalPriceViewControllerDelegate {
    
    func cryptoCurrencyHistoricalPriceViewController(_ viewController: CryptoCurrencyHistoricalPriceViewController, didSelectDate date: Date) {
        guard let viewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: CryptoCurrencyHistoricalPriceDetailViewController.reuseIdentifier) as? CryptoCurrencyHistoricalPriceDetailViewController else {
            return
        }
        let networking = HTTPNetworking()
        let apiService = CoinDeskAPIService(networking: networking)
        guard let cryptoCurrency = viewModel?.selectedCryptoCurrency else {
            return
        }
        let viewModel = DefaultCryptoCurrencyHistoricalPriceDetailViewModel(apiService: apiService,
                                                                            cryptoCurrency: cryptoCurrency,
                                                                            date: date)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
}
