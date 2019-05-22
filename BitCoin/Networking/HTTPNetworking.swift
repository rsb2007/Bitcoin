//
//  HTTPNetworking.swift
//  BitCoin
//
//  Created by R B on 2019-05-18.
//  Copyright © 2019 Raj Bedi. All rights reserved.
//

import Foundation

final class HTTPNetworking {
    
    // MARK: - Private Properties
    
    private let session: URLSession
    
    // MARK: - Initializers
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

// MARK: - Networking

extension HTTPNetworking: Networking {

    func request(from endpoint: Endpoint, completion: @escaping NetworkingRequestCompletion) -> CancelableTask? {
        guard let urlRequest = endpoint.makeUrlRequest() else {
            completion(.failure(.unableToSubmit))
            return nil
        }
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(.other(error)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }
        dataTask.resume()
        return dataTask
    }
}

private extension Endpoint {
    
    func makeUrlRequest() -> URLRequest? {
        guard let url = URL(string: path) else {
            return nil
        }
        return URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
    }
}

extension URLSessionDataTask: CancelableTask {
    
    func cancelTask() {
        cancel()
    }
}
