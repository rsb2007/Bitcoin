//
//  CryptoCurrencyListViewController.swift
//  BitCoin
//
//  Created by R B on 2019-05-18.
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import Foundation
import UIKit

protocol CryptoCurrencyHistoricalPriceViewControllerDelegate: class {

    func cryptoCurrencyHistoricalPriceViewController(_ viewController: CryptoCurrencyHistoricalPriceViewController, didSelectDate date: Date)
}

class CryptoCurrencyHistoricalPriceViewController: UIViewController {

    // MARK: - Constants
    
    private enum Constants {
        static let headerHeight: CGFloat = 50.0
        static let estimatedRowHeight: CGFloat = 80.0
    }

    // MARK: - Internal Properties
    
    weak var delegate: CryptoCurrencyHistoricalPriceViewControllerDelegate?
    
    var viewModel: CryptoCurrencyHistoricalPriceViewModel?
   
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Overriden Methods
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
}

//MARK: - DataSource

extension CryptoCurrencyHistoricalPriceViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.titleForHeaderInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoCurrencyHistoricalPriceItemCell.reuseIdentifier, for: indexPath) as? CryptoCurrencyHistoricalPriceItemCell else {
            fatalError("Unable to dequeue CryptoCurrencyHistoricalPriceTableViewCell")
        }
        if let priceItemViewModel = viewModel?.priceItemViewModel(at: indexPath.row) {
            cell.historicalDateLabel.text = priceItemViewModel.formattedDate
            cell.historicalPriceLabel.text = priceItemViewModel.formattedPrice
            cell.currencyLabel.text = "$"
            
        }
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension CryptoCurrencyHistoricalPriceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let date = viewModel?.priceItemViewModel(at: indexPath.item)?.date else {
            return
        }
        delegate?.cryptoCurrencyHistoricalPriceViewController(self, didSelectDate: date)
    }
}

// MARK: - CryptoCurrencyListViewModelDelegate

extension CryptoCurrencyHistoricalPriceViewController: CryptoCurrencyHistoricalPriceViewModelDelegate {
    
    func cryptoCurrencyHistoricalPriceViewModel(_ viewModel: CryptoCurrencyHistoricalPriceViewModel, didChangeStateTo state: CryptoCurrencyHistoricalPriceViewModelState) {
        
        switch state {
        case .loading:
            tableView.isHidden = true
            statusLabel.isHidden = true
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            view.bringSubviewToFront(activityIndicatorView)
        case .loaded:
            tableView.isHidden = false
            activityIndicatorView.isHidden = true
            statusLabel.isHidden = true
            view.bringSubviewToFront(tableView)
            tableView.reloadData()
        case let .failed(errorMessage):
            tableView.isHidden = true
            activityIndicatorView.isHidden = false
            statusLabel.isHidden = false
            view.bringSubviewToFront(statusLabel)
            statusLabel.text = errorMessage
        }
    }
}
