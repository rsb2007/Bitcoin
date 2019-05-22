//
//  CryptoCurrency.swift
//  BitCoin
//
//  Created by R B on 2019-05-18.
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import Foundation

enum CryptoCurrency {
    case bitcoin
}

// MARK: - CustomStringConvertible

extension CryptoCurrency: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .bitcoin:
            return "Bitcoin"
        }
    }
}
