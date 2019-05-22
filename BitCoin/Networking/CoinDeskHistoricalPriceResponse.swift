//
//  CoinDeskHistoricalPriceResponse.swift
//  BitCoin
//
//  Created by R B on 2019-05-18.
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import Foundation

typealias CoinDeskHistoricalPriceByDate = [Date: Double]

struct CoinDeskHistoricalPriceResponse {
    let priceByDate: CoinDeskHistoricalPriceByDate
}

extension CoinDeskHistoricalPriceResponse: JSONObjectDecodable {
    
    init?(JSONObject: JSONObjectType) {
        guard let bpiResponse = JSONObject["bpi"] as? JSONObjectType else {
            return nil
        }
        var priceByDate: CoinDeskHistoricalPriceByDate = [:]
        for dateString in bpiResponse.keys {
            if let date = CoinDeskHistoricalPriceResponse.dateFormatter.date(from: dateString),
                let rate = bpiResponse[dateString] as? Double {
                priceByDate[date] = rate
            }
        }
        self.priceByDate = priceByDate
    }
}

extension CoinDeskHistoricalPriceResponse {
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
