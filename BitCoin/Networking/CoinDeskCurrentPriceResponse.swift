//
//  CoinDeskCurrentPriceResponse.swift
//  BitCoin
//
//  Created by R B on 2019-05-18.
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import Foundation

typealias JSONObjectType = [String: AnyObject]
typealias JSONArrayType = [JSONObjectType]

protocol JSONObjectDecodable {
    
    init?(JSONObject: JSONObjectType)
}

protocol JSONArrayDecodable {
    
    init?(JSONArray: JSONArrayType)
}

struct CoinDeskCurrentPriceResponse {
    let priceByCurrency: [Currency: Double]
}

extension CoinDeskCurrentPriceResponse: JSONObjectDecodable {
    
    init?(JSONObject: JSONObjectType) {
        
        guard let bpiResponse = JSONObject["bpi"] as? JSONObjectType else {
            return nil
        }
        var priceByCurrency: [Currency: Double] = [:]
        for currencyCode in bpiResponse.keys {
            if let currency = Currency(string: currencyCode),
                let currencyResponse = bpiResponse[currencyCode] as? JSONObjectType,
                let rate = currencyResponse["rate_float"] as? Double {
                priceByCurrency[currency] = rate
            }
        }
        self.priceByCurrency = priceByCurrency
    }
}

private extension Currency {
    
    init?(string: String) {
        switch string {
        case "EUR":
            self = .EURO
        case "USD":
            self = .USD
        case "GBP":
            self = .GBP
        default:
            return nil
        }
    }
}
