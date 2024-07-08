//
//  CoinDataService.swift
//  CryptoTracker
//
//  Created by Omar Altali on 25/05/2024.
//

import Combine
import SwiftUI

protocol CoinDataServiceProtocol {
    func fetchCoins() -> AnyPublisher<[CoinModel], Never>
}

class CoinDataService: CoinDataServiceProtocol {

    private var coinSubscription: Set<AnyCancellable> = []
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        fetchCoins()
    }

  @discardableResult  func fetchCoins() -> AnyPublisher<[CoinModel], Never> {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {
            return Just([]).eraseToAnyPublisher()
        }

        return networkManager.fetchData(from: url, type: [CoinModel].self)
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}

//
//
//class CoinDataService {
//
//    @Published var allCoins: [CoinModel] = []
//    var coinSubscription: AnyCancellable?
//    private let networkManager: NetworkManagerProtocol
//
//    init(networkManager: NetworkManagerProtocol) {
//        self.networkManager = networkManager
//        getCoins()
//    }
//
//    func getCoins() {
//        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
//        coinSubscription = networkManager.fetchData(from: url, type: [CoinModel].self)
//            .sink { completion in
//                if case let .failure(error) = completion {
//                    print(error.localizedDescription)
//                }
//            } receiveValue: { [weak self] coins in
//                self?.allCoins = coins
//                self?.coinSubscription?.cancel()
//            }
//    }
//}
