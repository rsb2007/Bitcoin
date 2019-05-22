//
//  Networking.swift
//  BitCoin
//
//  Created by R B on 2019-05-18.
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import Foundation

enum NetworkingError: Error {
    case unableToSubmit
    case noData
    case other(Error)
}

typealias NetworkingRequestResult = Result<Data, NetworkingError>
typealias NetworkingRequestCompletion = (NetworkingRequestResult) -> Void

protocol Networking {
    
    func request(from endpoint: Endpoint, completion: @escaping NetworkingRequestCompletion) -> CancelableTask?
}

protocol CancelableTask {
    
    func cancelTask()
}
