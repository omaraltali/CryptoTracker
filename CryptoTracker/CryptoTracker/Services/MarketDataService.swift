//
//  MarketDataService.swift
//  CryptoTracker
//
//  Created by Omar Altali on 01/06/2024.
//

import Foundation
import Combine

class MarketDataService {

    @Published var marketData: MarketDataModel? = nil
    var marketDatasubscription: AnyCancellable?
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        getMarketData()
    }

    func getMarketData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        marketDatasubscription = networkManager.fetchData(from: url, type: GlobalData.self)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] marketData in
                self?.marketData = marketData.data
                self?.marketDatasubscription?.cancel()
            }
    }
}
