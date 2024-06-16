//
//  CoinDetailDataService.swift
//  CryptoTracker
//
//  Created by Omar Altali on 16/06/2024.
//

import SwiftUI
import Combine

class CoinDetailDataService {

    @Published var coinDetails: CoinDetailModel? = nil
    var coinDetailSubscription: AnyCancellable?
    let coin: CoinModel
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol, coin: CoinModel) {
        self.networkManager = networkManager
        self.coin = coin
        getCoinDetails()
    }

    func getCoinDetails() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
        coinDetailSubscription = networkManager.fetchData(from: url, type: CoinDetailModel.self)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] coinDetails in
                self?.coinDetails = coinDetails
                self?.coinDetailSubscription?.cancel()
            }
    }
}


// https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h
