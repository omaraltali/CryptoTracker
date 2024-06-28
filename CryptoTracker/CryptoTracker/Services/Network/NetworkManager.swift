//
//  NetworkManager.swift
//  CryptoTracker
//
//  Created by Omar Altali on 31/05/2024.
//

import Foundation
import Combine

class NetworkManager: NetworkManagerProtocol {

    static let shared = NetworkManager()

    private init () {}

    func fetchData<T: Decodable>(from url: URL, type: T.Type) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) in
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .retry(3)
            .eraseToAnyPublisher()
    }
}

