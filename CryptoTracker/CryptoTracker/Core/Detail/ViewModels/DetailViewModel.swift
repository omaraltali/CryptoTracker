//
//  DetailViewModel.swift
//  CryptoTracker
//
//  Created by Omar Altali on 16/06/2024.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {

    @Published var coin: CoinModel
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()

    init(coin: CoinModel, coinDetailService: CoinDetailDataService) {
        self.coinDetailService = coinDetailService
        self.coin = coin
    }

    private func addSubscribers() {

        coinDetailService.$coinDetails
            .sink { returnedCoinDetails in
                print("received coind detail data")
                print(returnedCoinDetails)
            }
            .store(in: &cancellables)

    }

}
