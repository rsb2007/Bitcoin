//
//  Reusable.swift
//  BitCoin
//
//  Created by R B on 2019-05-18.
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import Foundation
import UIKit

/// This will be used when reusable classes are code base not nib-base
protocol Reusable: class {
    /// The reuse identifier that we use for registering and dequeing cell
    static var reuseIdentifier: String { get }
}

// MARK: - Reusable.Default

extension Reusable {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

// MARK: - Date

extension Date {
    
    var currentDateWithMonthYear: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: Date())
    }
    
    func getString(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}
