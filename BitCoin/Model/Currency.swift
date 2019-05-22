//
//  Currency.swift
//  BitCoin
//
//  Created by R B on 2019-05-18.
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import Foundation

enum Currency {
    case EURO
    case GBP
    case USD
}

// MARK: - Currency

extension Currency {
    
    var symbol: String {
        switch self {
        case .EURO:
            return "€"
        case .GBP:
            return "£"
        case .USD:
            return "$"
        }
    }
}

