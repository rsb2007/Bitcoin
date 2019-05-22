//
//  CryptoCurrencyHistoricalPriceDetailViewController.swift
//  BitCoin
//
//  Created by R B on 2019-05-18.
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import Foundation
import UIKit

final class CryptoCurrencyHistoricalPriceDetailViewController: UIViewController {

    // MARK: - Private Properties
    
    @IBOutlet private var errorLabel: UILabel!
   
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet private var priceIndexTableView: UITableView!
    
    // MARK: - Internal Properties
    
    var viewModel: CryptoCurrencyHistoricalPriceDetailViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
        if let date = viewModel?.selectedDateTitle {
            title = "\(date.getString(for: date))"
        }
        viewModel?.delegate = self
        viewModel?.requestDetail()
    }
}


// MARK: - CryptoCurrencyHistoricalPriceDetailViewModelDelegate

extension CryptoCurrencyHistoricalPriceDetailViewController: CryptoCurrencyHistoricalPriceDetailViewModelDelegate {
    
    func CryptoCurrencyHistoricalPriceDetailViewModel(_ viewModel: CryptoCurrencyHistoricalPriceDetailViewModel, didChangeStateTo state: CryptoCurrencyHistoricalPriceDetailViewModelState) {
        switch state {
        case .loading:
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            priceIndexTableView.isHidden = true
            errorLabel.isHidden = true
        case .loaded:
            activityIndicatorView.isHidden = false
            priceIndexTableView.isHidden = false
            errorLabel.isHidden = true
            priceIndexTableView.reloadData()
        case .error:
            errorLabel.isHidden = false
            priceIndexTableView.isHidden = true
            activityIndicatorView.isHidden = true
        }
    }
}


// MARK: - UITableViewDataSource

extension CryptoCurrencyHistoricalPriceDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoCurrencyHistoricalPriceDetailViewCell.reuseIdentifier, for: indexPath) as? CryptoCurrencyHistoricalPriceDetailViewCell else {
            return UITableViewCell()
        }
        cell.currencyLabel.text = viewModel?.currencyLabel(at: indexPath.row)
        cell.priceLabel.text = viewModel?.priceLabel(at: indexPath.row)
        return cell
    }
}

extension CryptoCurrencyHistoricalPriceDetailViewController: Reusable { }
